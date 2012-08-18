//
//  SetFileManager.h
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import "Header.h"
#import <Foundation/Foundation.h>

@interface SetFileManager : NSObject {
    
}
// Dicionary Open
+ (BOOL)saveSetFile:(NSMutableDictionary *)dic;
+ (NSDictionary *)loadSetFile;

// Directory path
+ (NSString *)getDocPath;
+ (NSString *)getLibPath;
+ (NSString *)getMyLibPath;
+ (NSString *)getMyLibEncPath;
+ (NSString *)getMyDBPath;
+ (BOOL)isEncFileExist:(NSString *)fileName;
// get file list
+ (NSArray *)getFileListOnMyLibEncPath;
//
+ (BOOL)removeAllEncFileOnMyLibEncPath;
+ (BOOL)removeEncFileOnMyLibEncPath:(NSString *)fileName;
+ (BOOL)removeFile:(NSString *)filePath;
@end
