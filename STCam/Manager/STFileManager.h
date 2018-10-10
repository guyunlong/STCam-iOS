//
//  STFileManager.h
//  STCam
//
//  Created by guyunlong on 10/10/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STFileManager : NSObject
+ (STFileManager *)sharedManager;

/**
 沙盒系统的跟路径

 @return 沙盒路径
 */
-(NSString*)getRootPath;

/**
 获得文件路径
 
 @return 文件夹全路径
 */
-(NSString*)getDirectPath:(NSString*)path;

- (NSString *)localPathForFile:(NSString *)fileIdentifier inDirectory:(NSString *)directoryName;


/**
 创建文件路径

 @param directory 路径
 @return 创建成功
 */
- (BOOL)createDirectoryNamed:(NSString *)directory;

- (BOOL)fileExistsForUrl:(NSString *)urlString ;

- (BOOL)fileExistsForUrl:(NSString *)urlString inDirectory:(NSString *)directoryName;


- (BOOL)fileExistsWithName:(NSString *)fileName
               inDirectory:(NSString *)directoryName ;

- (BOOL)fileExistsWithName:(NSString *)fileName;

-(NSArray*)getFilesInDirectory:(NSString*)directoryName;

- (BOOL)deleteFileWithName:(NSString *)fileName;
@end
