//
//  MainViewController.h
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import <UIKit/UIKit.h>
#import "MyViewController.h"
#import "EncryptViewController.h"
#import "App.h"
#import "TDogAppDelegate.h"

@interface MainViewController : UIViewController <UITabBarDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    MyViewController *myViewCtl;
    EncryptViewController *encryptViewCtl;
	App *app;

    BOOL isKorean;
	
	UITabBar *tabBar;
	BOOL isRetina;	
    //
    UILabel *messageLabel;
    NSTimer *showMsgTimer;
}
@property (nonatomic, retain) UITabBar *tabBar;
@property (nonatomic, retain) App *app;
@property (nonatomic, retain) MyViewController *myViewCtl;
@property (nonatomic, retain) EncryptViewController *encryptViewCtl;
@property (nonatomic, assign) BOOL isKorean;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;

- (IBAction)openEncryptView:(id)sender;
//
- (void)checkRetinaSupport;
- (void)checkLanguage;
- (void)showMessageLabel:(NSString *)msg;
- (void)showMessageLabelLong:(NSString *)msg;
- (NSData *)encryptDo:(NSString *)_str :(NSString *)password;
- (NSString *)decryptDo:(NSData *)data :(NSString *)password;
- (void)openEncryptViewForUpdate:(FavoriteDo *)fd;
@end
