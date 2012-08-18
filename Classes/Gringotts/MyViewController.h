//
//  MyViewController.h
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import <UIKit/UIKit.h>
#import "App.h"
@interface MyViewController : App <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    
	UITableView *listView;
	
	NSMutableArray *myList;
	
	BOOL	isKorean;
	BOOL	isRetina;
	
	UIButton *editBtn;
	UIButton *deleteAllBtn;
	
	UIActivityIndicatorView *actIndicator;
	
    UIImageView *titleImageView;
    
    UILabel *introLabel;
    UIButton *introBtn;

}
@property (nonatomic, retain) IBOutlet UIImageView *titleImageView;
@property (nonatomic, retain) NSMutableArray *myList;

@property (nonatomic, retain) IBOutlet UITableView *listView;
@property (nonatomic, retain) IBOutlet UIButton *editBtn;
@property (nonatomic, retain) IBOutlet UIButton *deleteAllBtn;
@property (nonatomic, retain) IBOutlet UILabel *introLabel;
@property (nonatomic, retain) IBOutlet UIButton *introBtn;

#pragma mark -
#pragma mark UIButton handle
- (IBAction)editToList:(id)sender;
- (IBAction)deleteMyList:(id)sender;
- (IBAction)touchToClose:(id)sender;
- (IBAction)touchToNext:(id)sender;

- (void)actIndicatorStop:(NSTimer *) time;

- (void)setBtnVisible;
- (void)checkRetinaSupport;
- (void)checkLanguage;
- (void)titleBtnEnable;
- (void)refreshListView;
@end
