//
//  App.h
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import <UIKit/UIKit.h>

@class MainViewController;

@interface App : UIViewController {
	MainViewController *mainViewCtl;
}

@property (nonatomic, retain) MainViewController *mainViewCtl;

@end
