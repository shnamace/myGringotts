//
//  SetFileManager.m
//
//  SetFileManager.m
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import "SetFileManager.h"
#include <sys/xattr.h>

#define MYLIB   "mylibrary"
#define MYENC   "myencode"
#define MYDB   "mydatabase"

@implementation SetFileManager

+ (NSString *)getDocPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [paths objectAtIndex:0];
	return docPath;
}

+ (NSString *)getLibPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *libPath = [paths objectAtIndex:0];
	return libPath;
}

+ (NSString *)getMyLibPath {
	return [NSString stringWithFormat:@"%@/%s",[self getLibPath],MYLIB];
}
+ (NSString *)getMyLibEncPath {
	return [NSString stringWithFormat:@"%@/%s",[self getMyLibPath],MYENC];
}

+ (NSString *)getMyDBPath {
	return [NSString stringWithFormat:@"%@/%s",[self getMyLibPath],MYDB];
}

+ (BOOL)isEncFileExist:(NSString *)fileName{
	BOOL status = YES;
	NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self getMyLibEncPath], fileName];
	if (![fileManager fileExistsAtPath:filePath]) {
        status = NO;
    }
    [fileManager release];
	return status;
}
+ (NSArray *)getFileListOnMyLibEncPath{
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSError *err;
    return [fileManager contentsOfDirectoryAtPath:[self getMyLibEncPath] error:&err];
}
+ (BOOL)removeEncFileOnMyLibEncPath:(NSString *)fileName{
	BOOL status = YES;
	NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *videoFilePath = [NSString stringWithFormat:@"%@/%@", [self getMyLibEncPath], fileName];
	NSError *err;
    
	if ([fileManager fileExistsAtPath:videoFilePath]) {
		if (![fileManager removeItemAtPath:videoFilePath error:&err]) {
			NSLog(@"[DEBUG] Enc File Remove Fail! : %@\n", [err localizedDescription]);
			status = NO;
		} else {
			NSLog(@"[DEBUG] Enc File Remove Success! : %@\n", videoFilePath);
        }
    } else {
        NSLog(@"Enc Not Exists:%@\n",videoFilePath);
	} 
    return status;
}
+ (BOOL)removeAllEncFileOnMyLibEncPath{
	BOOL status = YES;
	NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *videoFilePath = [self getMyLibEncPath];
	NSError *err;
    
	if ([fileManager fileExistsAtPath:videoFilePath]) {
		if (![fileManager removeItemAtPath:videoFilePath error:&err]) {
			NSLog(@"[DEBUG]removeAllEncFileOnMyLibEncPath Remove Fail! : %@\n", [err localizedDescription]);
			status = NO;
		} else {
        }
    } else {
        NSLog(@"Enc Not Exists:%@\n",videoFilePath);
	} 
    
    if ([fileManager createDirectoryAtPath:[SetFileManager getMyLibEncPath] withIntermediateDirectories:YES attributes:nil error:&err]) {
        if ([self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[SetFileManager getMyLibEncPath]]]){
        } else {
            NSLog(@"[DEBUG]Do Not Back UP FAIL!!\n");
        }
	} else {
        NSLog(@"[DEBUG] removeAllEncFileOnMyLibEncPath[getMyLibEncPath] Fail!! : %@", [err localizedDescription]);
        status = NO;
    }

    
    return status;
}

+ (BOOL)removeFile:(NSString *)filePath{
	BOOL status = YES;
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSError *err;
	if ([fileManager fileExistsAtPath:filePath]) {
		if (![fileManager removeItemAtPath:filePath error:&err]) {
			NSLog(@"[DEBUG]removeFile:File Remove Fail! : %@", [err localizedDescription]);
			status = NO;
		}
    } else {
        NSLog(@"[DEBUG]removeFile:File Not Exists\n");
        status = NO;
	} 
	return status;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+ (BOOL)saveSetFile:(NSMutableDictionary *)dic {
	BOOL status = YES;
    NSString *setFilePath = [[NSString alloc] initWithFormat:@"%@/%s", [self getMyLibPath], SET_FILE_NAME];
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSError *err;
	if ([fileManager fileExistsAtPath:setFilePath]) {
		if (![fileManager removeItemAtPath:setFilePath error:&err]) {
			NSLog(@"[DEBUG] File Remove Fail! : %@", [err localizedDescription]);
			status = NO;
		}
	}
	if (![dic writeToFile:setFilePath atomically:NO]) {
		NSLog(@"[DEBUG] File Write Fail!");
		status = NO;
	}
	return status;
}

+ (NSDictionary *)loadSetFile {
	NSDictionary *dic = NULL;
    NSString *setFilePath = [[NSString alloc] initWithFormat:@"%@/%s", [self getMyLibPath], SET_FILE_NAME];
	if (![[NSFileManager alloc] fileExistsAtPath:setFilePath]) {
		// NSLog(@"[DEBUG] File Not Found!");
		return dic;
	}
	dic = [[NSDictionary alloc] initWithContentsOfFile:setFilePath];
	return dic;
}
@end
