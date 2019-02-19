//
//  STFileManager.m
//  STCam
//
//  Created by guyunlong on 10/10/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "STFileManager.h"
#import "PrefixHeader.h"

@implementation STFileManager
+ (STFileManager *)sharedManager{
    static STFileManager *sharedManager = nil;
    static dispatch_once_t manyiToken;
    dispatch_once(&manyiToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(NSString*)getRootPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    return cachesDirectory;
}
-(NSString*)getDirectPath:(NSString*)directory{
    NSString* cachesDirectory = [self getRootPath];
    NSString *targetDirectory = [cachesDirectory stringByAppendingPathComponent:directory];
    return targetDirectory;
}
- (NSString *)localPathForFile:(NSString *)fileIdentifier inDirectory:(NSString *)directoryName {
    NSString *fileName = [fileIdentifier lastPathComponent];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    return [[cachesDirectory stringByAppendingPathComponent:directoryName] stringByAppendingPathComponent:fileName];
}

- (BOOL)createDirectoryNamed:(NSString *)directory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *targetDirectory = [cachesDirectory stringByAppendingPathComponent:directory];
    
    NSError *error;
    return [[NSFileManager defaultManager] createDirectoryAtPath:targetDirectory
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:&error];
}

- (BOOL)fileExistsForUrl:(NSString *)urlString {
    return [self fileExistsForUrl:urlString inDirectory:nil];
}

- (BOOL)fileExistsForUrl:(NSString *)urlString inDirectory:(NSString *)directoryName {
    return [self fileExistsWithName:[urlString lastPathComponent] inDirectory:directoryName];
}


- (BOOL)fileExistsWithName:(NSString *)fileName
               inDirectory:(NSString *)directoryName {
    BOOL exists = NO;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    // if no directory was provided, we look by default in the base cached dir
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[cachesDirectory stringByAppendingPathComponent:directoryName] stringByAppendingPathComponent:fileName]]) {
        exists = YES;
    }
    
    return exists;
}

- (BOOL)fileExistsWithName:(NSString *)fileName {
    return [self fileExistsWithName:fileName inDirectory:nil];
}

-(NSArray*)getFilesInDirectory:(NSString*)directoryName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *targetDirectory = [cachesDirectory stringByAppendingPathComponent:directoryName];
    NSArray *fileList = [[NSArray alloc] init];//fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSError *error = nil;
    fileList = [fileManager contentsOfDirectoryAtPath:targetDirectory error:&error];
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    for (NSString *file in fileList) {
        NSString *path = [targetDirectory stringByAppendingPathComponent:file];
        [fileArray addObject:path];
    }
    return [fileArray copy];
}
- (BOOL)deleteFileWithName:(NSString *)fileName{
    BOOL deleted = NO;
    
    NSError *error;
    NSURL *fileLocation = [NSURL fileURLWithPath:fileName];
    // Move downloaded item from tmp directory to te caches directory
    // (not synced with user's iCloud documents)
    [[NSFileManager defaultManager] removeItemAtURL:fileLocation error:&error];
    
    if (error) {
        deleted = NO;
        DDLogDebug(@"Error deleting file: %@", error);
    } else {
        deleted = YES;
    }
    return deleted;
}
@end
