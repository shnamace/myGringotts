//
//  TDogAppDelegate.h
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import <UIKit/UIKit.h>
#include "MainViewController.h"
@interface TDogAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	MainViewController *mainViewCtl;

	BOOL isKorean;
	BOOL isExit;
    BOOL isRetina;
}
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewCtl;

#pragma mark -
#pragma mark view change
- (void)initialProcess;
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
