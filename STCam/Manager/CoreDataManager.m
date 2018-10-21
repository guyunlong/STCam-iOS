//
//  CoreDataManager.m
//

#import "CoreDataManager.h"

@implementation CoreDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
+ (CoreDataManager *)sharedManager {
    static CoreDataManager *sharedManager = nil;
    static dispatch_once_t manyiToken;
    dispatch_once(&manyiToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Manyipay.CoreDataSimple" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    //新增(数据迁移)
    NSDictionary * option = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),
                              NSInferMappingModelAutomaticallyOption:@(YES)};
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:option error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    return _persistentStoreCoordinator;
}
- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}
-(BOOL)saveDevice:(DeviceModel *)model{
    //获取应用程序委托的引用，再用引用获取创建好的托管对象上下文。
    NSError *error;
    //创建提取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //为已创建好的实体利用检索到的上下文创建一个实体描述
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Node"
                                                         inManagedObjectContext:self.managedObjectContext];
    //创建好了以后发送给提取请求，以便请求能够知道要查找的实体类型
    [request setEntity:entityDescription];
    
    //确定持久库中是否存在与此字段相对应的托管对象，所以穿件一个谓词来确定字段的正确对象：
   NSPredicate *pred = [NSPredicate predicateWithFormat:@"sn == %@",model.SN];
   [request setPredicate:pred];
    
    
    //由于我们还不知道是从持久库中加载托管对象还是创建新的托管对象，
    //所以声明一个指向NSManagedObject的指针并将他设置为nil
    NSManagedObject *object = nil;
    
    //再次在上下文中执行提取请求
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (objects == nil)
    {
        NSLog(@"There was an error!");
        return false;
    }
    
    //检查示范返回了标准匹配的对象，若果有则加载它，如果没有则创建一个新的托管对象来保存此字段的文本
    if ([objects count] > 0)
    {
        object = [objects objectAtIndex:0];
    }
    else
    {
        object= [NSEntityDescription insertNewObjectForEntityForName:@"Node"
                                              inManagedObjectContext:self.managedObjectContext];
    }
    //使用键值编码来设置行号以及托管对象的文本
    [object setValue:model.SN forKey:@"sn"];
    [object setValue:model.User forKey:@"usr"];
    [object setValue:model.Pwd forKey:@"pwd"];
    //完成循环之后要通知上下文保存其更改
    [self saveContext];
    return true;
}

/**
 *保存录像
 */
-(BOOL)saveSDVideo:(SDVideoModel*)model{
    //获取应用程序委托的引用，再用引用获取创建好的托管对象上下文。
    NSError *error;
    //创建提取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //为已创建好的实体利用检索到的上下文创建一个实体描述
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Video"
                                                         inManagedObjectContext:self.managedObjectContext];
    //创建好了以后发送给提取请求，以便请求能够知道要查找的实体类型
    [request setEntity:entityDescription];
    
    //确定持久库中是否存在与此字段相对应的托管对象，所以穿件一个谓词来确定字段的正确对象：
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@",model.sdVideo];
    [request setPredicate:pred];
    
    
    //由于我们还不知道是从持久库中加载托管对象还是创建新的托管对象，
    //所以声明一个指向NSManagedObject的指针并将他设置为nil
    NSManagedObject *object = nil;
    
    //再次在上下文中执行提取请求
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (objects == nil)
    {
        NSLog(@"There was an error!");
        return false;
    }
    
    //检查示范返回了标准匹配的对象，若果有则加载它，如果没有则创建一个新的托管对象来保存此字段的文本
    if ([objects count] > 0)
    {
        object = [objects objectAtIndex:0];
    }
    else
    {
        object= [NSEntityDescription insertNewObjectForEntityForName:@"Video"
                                              inManagedObjectContext:self.managedObjectContext];
    }
    //使用键值编码来设置行号以及托管对象的文本
    [object setValue:model.url forKey:@"url"];
    [object setValue:model.sdVideo forKey:@"name"];
    [object setValue:@1 forKey:@"viewed"];
    //完成循环之后要通知上下文保存其更改
    [self saveContext];
    return true;
}

/**
 *录像是否存在数据库中
 */
-(BOOL)isVideoExist:(SDVideoModel*)model{
    //获取应用程序委托的引用，再用引用获取创建好的托管对象上下文。
    NSError *error;
    //创建提取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //为已创建好的实体利用检索到的上下文创建一个实体描述
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Video"
                                                         inManagedObjectContext:self.managedObjectContext];
    //创建好了以后发送给提取请求，以便请求能够知道要查找的实体类型
    [request setEntity:entityDescription];
    
    //确定持久库中是否存在与此字段相对应的托管对象，所以穿件一个谓词来确定字段的正确对象：
    //(tid == %ld) AND (dte==%@)
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@",model.sdVideo];
    [request setPredicate:pred];
    
    
    //再次在上下文中执行提取请求
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (objects == nil)
    {
        NSLog(@"There was an error!");
        return NO;
    }
    else{
        if ([objects count]>0) {
            return YES;
        }
        else{
            return NO;
        }
        
    }
}

-(BOOL)isDeviceExist:(DeviceModel*)model{
    //获取应用程序委托的引用，再用引用获取创建好的托管对象上下文。
    NSError *error;
    //创建提取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //为已创建好的实体利用检索到的上下文创建一个实体描述
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Node"
                                                         inManagedObjectContext:self.managedObjectContext];
    //创建好了以后发送给提取请求，以便请求能够知道要查找的实体类型
    [request setEntity:entityDescription];
    
    //确定持久库中是否存在与此字段相对应的托管对象，所以穿件一个谓词来确定字段的正确对象：
    //(tid == %ld) AND (dte==%@)
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"sn == %@",model.SN];
    [request setPredicate:pred];
   
    
    //再次在上下文中执行提取请求
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (objects == nil)
    {
        NSLog(@"There was an error!");
        return false;
    }
    else{
        if ([objects count]>0) {
            return true;
        }
        else{
            return false;
        }
        
    }
    
}
-(DeviceModel*)getDeviceModel:(NSString*)sn{
    NSError *error;
    //创建提取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //为已创建好的实体利用检索到的上下文创建一个实体描述
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Node"
                                                         inManagedObjectContext:self.managedObjectContext];
    //创建好了以后发送给提取请求，以便请求能够知道要查找的实体类型
    [request setEntity:entityDescription];
    
    //确定持久库中是否存在与此字段相对应的托管对象，所以穿件一个谓词来确定字段的正确对象：
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"sn == %@",sn];
    [request setPredicate:pred];
    
    
    //由于我们还不知道是从持久库中加载托管对象还是创建新的托管对象，
    //所以声明一个指向NSManagedObject的指针并将他设置为nil
    
    //再次在上下文中执行提取请求
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (objects == nil)
    {
        NSLog(@"There was an error!");
        return nil;
    }
    else if([objects count] > 0){
       NSManagedObject *object =  [objects objectAtIndex:0];
        DeviceModel * model = [DeviceModel new];
        [model setSN:[object valueForKey:@"sn"]];
        [model setPwd:[object valueForKey:@"pwd"]];
        [model setUser:[object valueForKey:@"usr"]];
        return model;
    }
    else{
        return nil;
    }
}
-(BOOL)deleteDevice:(DeviceModel*)model{
    //获取应用程序委托的引用，再用引用获取创建好的托管对象上下文。
    NSError *error;
    //创建提取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //为已创建好的实体利用检索到的上下文创建一个实体描述
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Node"
                                                         inManagedObjectContext:self.managedObjectContext];
    //创建好了以后发送给提取请求，以便请求能够知道要查找的实体类型
    [request setEntity:entityDescription];
    
    //确定持久库中是否存在与此字段相对应的托管对象，所以穿件一个谓词来确定字段的正确对象：
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"sn == %@",model.SN];
    [request setPredicate:pred];
    
    
    //由于我们还不知道是从持久库中加载托管对象还是创建新的托管对象，
    //所以声明一个指向NSManagedObject的指针并将他设置为nil
    NSManagedObject *msg0 = nil;
    
    //再次在上下文中执行提取请求
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (objects == nil)
    {
        NSLog(@"There was an error!");
        return false;
    }
    
    //检查示范返回了标准匹配的对象，若果有则加载它，如果没有则创建一个新的托管对象来保存此字段的文本
    if ([objects count] > 0)
    {
        msg0 = [objects objectAtIndex:0];
        [self.managedObjectContext deleteObject:msg0];
        [self saveContext];
    }
    return true;
}


-(NSMutableArray*)getAllNode{
    //获取应用程序委托的引用，再用引用获取创建好的托管对象上下文。
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Node"
                                                         inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entityDescription];
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray * nodearray = [NSMutableArray new];
    for (NSManagedObject *object in objects) {
        DeviceModel * model = [DeviceModel new];
        [model setSN:[object valueForKey:@"sn"]];
        [model setPwd:[object valueForKey:@"pwd"]];
        [model setUser:[object valueForKey:@"usr"]];
        [nodearray addObject:model];
    }
    return nodearray;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
