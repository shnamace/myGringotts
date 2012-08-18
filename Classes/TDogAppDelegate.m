//
//  TDogAppDelegate.m
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#include <sys/xattr.h>
#import "TDogAppDelegate.h"
#import "MainViewController.h"
#import "Header.h"
#import "SetFileManager.h"
#import "DBUtil.h"

@implementation TDogAppDelegate

@synthesize window;
@synthesize mainViewCtl;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    isExit = FALSE;
    
    [self performSelectorOnMainThread:@selector(initialProcess) withObject:self waitUntilDone:YES];
        
    MainViewController *mvc = [[MainViewController alloc] initWithNibName:@"MainView" bundle:[NSBundle mainBundle]];
    [mvc.view setFrame:CGRectMake(0, 20, 320, 460)];
    self.mainViewCtl = mvc;
    mvc = nil;
    [mvc release];
    
    self.window.rootViewController = self.mainViewCtl;
	[self.window makeKeyAndVisible];
    
	return YES;
}

- (void)initialProcess {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    if (![self isExistsMyLibFolder]) {
        if ([self createMyLibFolder]) {
        } else {
            NSLog(@"[DEBUG] Create Library Folder Fail!!\n");
        }
    } else {
    }

	NSMutableDictionary *setDic = (NSMutableDictionary *)[SetFileManager loadSetFile];
	if (setDic == NULL) { // app 처음 실행시 설정 file 초기화
		[self initializeDicionary];
        if (![DBUtil createFavoriteTable]) {
            NSLog(@"[DEBUG]createFavoriteTable Failed..\n");
        }
		setDic = nil; [setDic release];
	} else {
	}
	[pool release];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	/*
	 Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
	 */
}


- (void)dealloc {
	[mainViewCtl release];
	[window release];
	[super dealloc];
}
- (BOOL)isExistsMyLibFolder {
	BOOL status = YES;
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if ([fileManager fileExistsAtPath:[SetFileManager getMyLibPath]]) {
	} else {
        status = NO;
    }
    [fileManager release];
	return status;
}

- (BOOL)createMyLibFolder {
	BOOL status = YES;
    
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSError *err = nil;
	
    if ([fileManager createDirectoryAtPath:[SetFileManager getMyLibPath] withIntermediateDirectories:YES attributes:nil error:&err]) {
        if ([self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[SetFileManager getMyLibPath]]]){
        } else {
            NSLog(@"[DEBUG]Do Not Back UP FAIL!!\n");
        }
	} else {
        NSLog(@"[DEBUG] createDirectory[getMyLibPath]AtPath Fail!! : %@", [err localizedDescription]);
        status = NO;
    }
    
    if ([fileManager createDirectoryAtPath:[SetFileManager getMyLibEncPath] withIntermediateDirectories:YES attributes:nil error:&err]) {
        if ([self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[SetFileManager getMyLibEncPath]]]){
        } else {
            NSLog(@"[DEBUG]Do Not Back UP FAIL!!\n");
        }
	} else {
        NSLog(@"[DEBUG] createDirectory[getMyLibEncPath] Fail!! : %@", [err localizedDescription]);
        status = NO;
    }

    if ([fileManager createDirectoryAtPath:[SetFileManager getMyDBPath] withIntermediateDirectories:YES attributes:nil error:&err]) {
        if ([self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[SetFileManager getMyDBPath]]]){
        } else {
            NSLog(@"[DEBUG]Do Not Back UP FAIL!!\n");
        }
	} else {
        NSLog(@"[DEBUG] createDirectory[getMyDBPath] Fail!! : %@", [err localizedDescription]);
        status = NO;
    }
    
    [fileManager release];
	return status;
}
- (void) initializeDicionary {
    NSMutableDictionary *setDic = (NSMutableDictionary *)[SetFileManager loadSetFile];
    setDic = [[NSMutableDictionary alloc] initWithCapacity:20];
	NSString *appversion = [NSString stringWithFormat:@"%s",APP_VERSION];
	[setDic setObject:appversion forKey:@"app_version"];
    isKorean = FALSE;
    [SetFileManager saveSetFile:setDic];
    setDic = nil;
    [setDic release];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}
@end
