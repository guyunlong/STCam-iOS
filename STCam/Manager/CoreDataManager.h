//
//  CoreDataManager.h
//  
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "DeviceModel.h"
#import "SDVideoModel.h"
@interface CoreDataManager : NSObject
+ (CoreDataManager *)sharedManager;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


/**
 *保存设备
 */
-(BOOL)saveDevice:(DeviceModel*)model;
/**
 *删除设备
 */
-(BOOL)deleteDevice:(DeviceModel*)model;
/**
 *获取所有设备
 */
-(NSMutableArray*)getAllNode;
/**
 *设备是否存在数据库中
 */
-(BOOL)isDeviceExist:(DeviceModel*)model;

/**
 *保存录像
 */
-(BOOL)saveSDVideo:(SDVideoModel*)model;

/**
 *录像是否存在数据库中
 */
-(BOOL)isVideoExist:(SDVideoModel*)model;

/**
 根据设备的sn返回设备信息
 @param sn 序列号
 @return model
 */
-(DeviceModel*)getDeviceModel:(NSString*)sn;

- (void)saveContext;

@end
