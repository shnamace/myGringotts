//
//  EncryptViewController.h
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "App.h"
#import "/usr/include/sqlite3.h"
#import "FavoriteDo.h"
@interface EncryptViewController : App <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {

	UITableView *listView;
    UILabel *titleLabel;
    UIImageView *titleImageView;

    NSInteger currow;
    
    BOOL    isRetina;
    BOOL    isKorean;
    UIActivityIndicatorView *actIndicator;
    
    UIActionSheet *actionSheet;
    UIPickerView *pickerView;
    
    UIButton *closeBtn;
    //
    UITextField *titleTF;
    UITextField *descTF;
    UITextField *info1TF;
    UITextField *info2TF;
    UITextField *info3TF;
    UITextField *info4TF;
    UITextField *info5TF;
    //UITextField *info6TF;
    UITextField *keyTF;
    UITextField *hintTF;
    UITextView *info6TV;
    //
    NSInteger idx;
    NSString *title,*desc,*info1,*info2,*info3,*info4,*info5,*info6,*key, *hint;
    //
    UIButton * overTapBtn;
    UITextField *currentField;
    NSInteger _endTFtag;
    //
    NSData *encInfo1;
    NSData *encInfo2;
    NSData *encInfo3;
    NSData *encInfo4;
    NSData *encInfo5;
    NSData *encInfo6;
    
    NSMutableArray *encDataList;
    //
    UIButton *encryptBtn;
    UIButton *decryptBtn;
    UIButton *saveBtn;
    //
    UILabel *blackLabel;
    //
    NSString *filePrefix;
    BOOL isOverwrite;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keyword:(NSString *)_keyword lang:(BOOL)_lang retina:(BOOL)_retina title:(NSString *)__title;

@property (nonatomic, retain) IBOutlet UITableView *listView;
@property (nonatomic, retain) IBOutlet UIImageView *titleImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *closeBtn;
@property (nonatomic, retain) IBOutlet UIButton *overTapBtn;
@property (nonatomic, retain) IBOutlet UIButton *encryptBtn;
@property (nonatomic, retain) IBOutlet UIButton *decryptBtn;
@property (nonatomic, retain) IBOutlet UIButton *saveBtn;

@property (nonatomic, retain) IBOutlet UILabel *blackLabel;

@property (nonatomic, copy) NSData *encInfo1;
@property (nonatomic, copy) NSData *encInfo2;
@property (nonatomic, copy) NSData *encInfo3;
@property (nonatomic, copy) NSData *encInfo4;
@property (nonatomic, copy) NSData *encInfo5;
@property (nonatomic, copy) NSData *encInfo6;

@property (nonatomic, copy) NSString *title,*desc,*info1,*info2,*info3,*info4,*info5,*info6,*key, *hint;
@property (nonatomic, copy) NSString *filePrefix;

- (void)reloadListView; // called by tvMain...
- (IBAction)resetButtonClicked:(id)sender;
- (IBAction)touchToClose:(id)sender;
- (IBAction)buttonClicked:(id)sender;
- (IBAction)overTapBtnClicked:(id)sender;
- (void)initialDo:(FavoriteDo *)fd;
@end
