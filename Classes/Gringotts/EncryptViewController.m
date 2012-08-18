//
//  EncryptViewController.m
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import "EncryptViewController.h"
#import "MainViewController.h"
#import "SetFileManager.h"
#import "Header.h"
#import "Util.h"
#import "DBUtil.h"
@implementation EncryptViewController

@synthesize listView;
@synthesize titleImageView;
@synthesize titleLabel;
@synthesize closeBtn;
@synthesize overTapBtn;
//
@synthesize encInfo1;
@synthesize encInfo2;
@synthesize encInfo3;
@synthesize encInfo4;
@synthesize encInfo5;
@synthesize encInfo6;
//
@synthesize encryptBtn;
@synthesize decryptBtn;
@synthesize saveBtn;
@synthesize blackLabel;
@synthesize title,desc,info1,info2,info3,info4,info5,info6,key,hint;
@synthesize filePrefix;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keyword:(NSString *)_keyword lang:(BOOL)_lang retina:(BOOL)_retina title:(NSString *)__title
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	}
    isKorean = _lang;
    isRetina = _retina;
	return self;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    self.overTapBtn.enabled=NO;
    
    [self resetButtonClicked:nil];

	actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[actIndicator setFrame:CGRectMake(297, 10, 20, 20)];
	[self.view addSubview:actIndicator];
    
	[listView reloadData];

    [super viewDidLoad];
}
- (void)initialDo:(FavoriteDo *)fd {
    [self resetButtonClicked:nil];
    

    if (fd == nil) {
        isOverwrite = FALSE;
        self.filePrefix = [DBUtil getFilePrefix];
    } else  {
        isOverwrite = TRUE;
        
        idx = fd.idx;
        self.title = fd.title;
        self.desc = fd.desc;
        self.hint = fd.hint;
        
        NSString *encStr = @"*****";
        self.info1 = encStr;
        self.info2 = encStr;
        self.info3 = encStr;
        self.info4 = encStr;
        self.info5 = encStr;
        self.info6 = encStr;
        
        self.filePrefix = fd.aes1;
        
        // encDataList
        encDataList = [[NSMutableArray alloc] init];
        for (int i=1; i<=6;i++) {
            NSString *fileName = [NSString stringWithFormat:@"%@%d",self.filePrefix,i];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",[SetFileManager getMyLibEncPath],fileName];
            NSData *tempData = [NSData dataWithContentsOfFile:filePath];
            [encDataList addObject:tempData];
        }
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//NSLog (@"[TVMyListViewController]-[shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation \n");
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	//NSLog (@"[TVMyListViewController]-[didReceiveMemoryWarning \n");
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	//NSLog (@"[TVMyListViewController]-[viewDidUnload \n");
		
	[super viewDidUnload];

    self.listView = nil;
    self.titleImageView = nil;
    self.titleLabel = nil;
    self.closeBtn = nil;
    self.overTapBtn = nil;
    //
    self.encInfo1 = nil;
    self.encInfo2 = nil;
    self.encInfo3 = nil;
    self.encInfo4 = nil;
    self.encInfo5 = nil;
    self.encInfo6 = nil;
    //
    self.encryptBtn = nil;
    self.decryptBtn = nil;
    self.saveBtn = nil;
    //
    self.blackLabel = nil;
    //
    self.title = nil;
    self.desc = nil;
    self.info1 = nil;
    self.info2 = nil;
    self.info3 = nil;
    self.info4 = nil;
    self.info5 = nil;
    self.info6 = nil;
    self.key = nil;
    
    self.filePrefix = nil;
}

- (void)dealloc {
	[listView release];
	[titleImageView release];
    [titleLabel release];
    
    [closeBtn release];
    [overTapBtn release];
    //
    [encInfo1 release];
    [encInfo2 release];
    [encInfo3 release];
    [encInfo4 release];
    [encInfo5 release];
    [encInfo6 release];
    //
    [encryptBtn release];
    [decryptBtn release];
    [saveBtn release];
    [blackLabel release];
    
    [title release];
    [desc release];
    [info1 release];
    [info2 release];
    [info3 release];
    [info4 release];
    [info5 release];
    [info6 release];
    [key release];
    
    [filePrefix release];
    
	[super dealloc];
}

#pragma mark -
#pragma mark UITableViewDataSource.
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
        return 140;
    else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section  0 || section == 4 || section == 5)
        return 40;
   // else {
      //  return 0;
    //}
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        UIView *uv = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(12, 0, 308, 40)] autorelease];
        label.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        label.text = (isKorean)?@"Category":@"Category";
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 1;
        label.textAlignment = UITextAlignmentLeft;
        
        label.backgroundColor = [UIColor clearColor];//
        label.textColor = [UIColor darkGrayColor];
        label.highlightedTextColor = [UIColor whiteColor];
        [uv addSubview:label];
        
        CGRect btnRect = CGRectMake(210, 7, 95, 30);
        UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cleanBtn.Frame=btnRect;
        cleanBtn.showsTouchWhenHighlighted = TRUE;
        [cleanBtn addTarget:self action:@selector(resetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cleanBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        cleanBtn.titleLabel.textColor = [UIColor blueColor];
        [cleanBtn setTitle:(isKorean)?@"Reset":@"Reset" forState:UIControlStateNormal];
        cleanBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        [uv addSubview:cleanBtn];

        UIButton *clearbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearbtn.tag = 1210;
        clearbtn.Frame=CGRectMake(0, 0, 209, 40);
        clearbtn.showsTouchWhenHighlighted = FALSE;
        [clearbtn addTarget:self action:@selector(clearKeyboard) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:clearbtn];

        return  uv;
    } else if (section == 1) {
        UIView *uv = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(12, 0, 308, 40)] autorelease];
        label.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        label.text = (isKorean)?@"Secret Information":@"Secret Information";
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 1;
        label.textAlignment = UITextAlignmentLeft;
        
        label.backgroundColor = [UIColor clearColor];//
        label.textColor = [UIColor darkGrayColor];
        label.highlightedTextColor = [UIColor whiteColor];
        [uv addSubview:label];
        
        UIButton *clearbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearbtn.tag = 1211;
        clearbtn.Frame=CGRectMake(0, 0, 320, 40);
        clearbtn.showsTouchWhenHighlighted = FALSE;
        [clearbtn addTarget:self action:@selector(clearKeyboard) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:clearbtn];

        
        return  uv;
    } else if (section == 2) {
        UIView *uv = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(12, 0, 308, 40)] autorelease];
        label.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        label.text = (isKorean)?@"Encryption/Decryption key":@"Encryption/Decryption key";
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 1;
        label.textAlignment = UITextAlignmentLeft;
        
        label.backgroundColor = [UIColor clearColor];//
        label.textColor = [UIColor darkGrayColor];
        label.highlightedTextColor = [UIColor whiteColor];
        [uv addSubview:label];
        
        UIButton *clearbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearbtn.tag = 1212;
        clearbtn.Frame=CGRectMake(0, 0, 320, 40);
        clearbtn.showsTouchWhenHighlighted = FALSE;
        [clearbtn addTarget:self action:@selector(clearKeyboard) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:clearbtn];
        
        return  uv;
    } else {
        return nil;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *uv = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
    if (section == 2) {
        int _x = 10, _w = 90, _inc = 12;
        CGRect searchRect = CGRectMake(_x, 20, _w, 50);
        encryptBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        encryptBtn.Frame=searchRect;
        encryptBtn.showsTouchWhenHighlighted = TRUE;
        [encryptBtn addTarget:self action:@selector(encryptClicked) forControlEvents:UIControlEventTouchUpInside];
        encryptBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0F];//boldSystemFontOfSize
        encryptBtn.titleLabel.textColor = [UIColor blueColor];
        [encryptBtn setTitle:(isKorean)?@"Encrypt":@"Encrypt" forState:UIControlStateNormal];
        [uv addSubview:encryptBtn];

        searchRect = CGRectMake(_x+_w+_inc+1, 20, _w+4, 50);
        saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        saveBtn.Frame=searchRect;
        saveBtn.showsTouchWhenHighlighted = TRUE;
        [saveBtn addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
        saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0F];//boldSystemFontOfSize
        saveBtn.titleLabel.textColor = [UIColor blueColor];
        [saveBtn setTitle:(isKorean)?@"Save":@"Save" forState:UIControlStateNormal];
        [uv addSubview:saveBtn];

        searchRect = CGRectMake(_x+_w*2+_inc*2+4+1, 20, _w, 50);
        decryptBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        decryptBtn.Frame=searchRect;
        decryptBtn.showsTouchWhenHighlighted = TRUE;
        [decryptBtn addTarget:self action:@selector(decryptClicked) forControlEvents:UIControlEventTouchUpInside];
        decryptBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0F];//boldSystemFontOfSize
        decryptBtn.titleLabel.textColor = [UIColor blueColor];
        [decryptBtn setTitle:(isKorean)?@"Decrypt":@"Decrypt" forState:UIControlStateNormal];
        [uv addSubview:decryptBtn];
        return  uv;
    } else {
        return uv;
    }
}

- (void)saveYesSelectDo{
    if ([self.title length] < 1) {
        [mainViewCtl showMessageLabel:@"Please, input title!"];
        titleTF.backgroundColor = [UIColor yellowColor];
        NSInteger section = 0;
        NSInteger row = 0;
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
        [listView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

        return;
    }
    if ([self.info1 length] < 1) {
        [mainViewCtl showMessageLabel:@"Please, input information1"];
        info1TF.backgroundColor = [UIColor yellowColor];
        NSInteger section = 0;
        NSInteger row = 1;
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
        [listView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return;
    }
    
    if ([self.info1 hasPrefix:@"*"] || [self.key length] < 1) {
       //NSLog(@"self.info1:%@,[self.key length]:%d\n",self.info1,[self.key length]);
        [mainViewCtl showMessageLabel:@"Encryption skip!!"];
        [self saveDo];
    } else {
       // NSLog(@"encrypt start\n");
        
        [actIndicator startAnimating];
        [mainViewCtl showMessageLabel:@"Encryption Start..."];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.2];
        [blackLabel setFrame:CGRectMake(0, 40, 320, 420)];
        [UIView commitAnimations];
        
        //112112
        [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(encryptSaveDo) userInfo:NULL repeats:NO];	

    }
}
- (void)encryptSaveDo{
    [self encryptStart];
    [self saveDo];
    [self showEncryptEndSign];
}
- (void)saveDo{
    NSString * newFilePrefix = self.filePrefix;
    for (int i=1; i <= 6; i++) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@%d",[SetFileManager getMyLibEncPath],newFilePrefix,i];
        if ([[encDataList objectAtIndex:i-1] writeToFile:filePath atomically:true]) {
          //  NSLog(@"write success\n");
        } else {
            NSLog(@"[DEBUG]saveYesSelectDo:write fail\n");
        }
    }
    
    if ([self.info2 length] < 1)
        self.info2 = @"";
    if ([self.info3 length] < 1)
        self.info3 = @"";
    if ([self.info4 length] < 1)
        self.info4 = @"";
    if ([self.info5 length] < 1)
        self.info5 = @"";
    if ([self.info6 length] < 1)
        self.info6 = @"";
    
    FavoriteDo *favoriteDo = [[FavoriteDo alloc] init];
    favoriteDo.idx = idx;
    favoriteDo.title = self.title;
    favoriteDo.desc = self.desc;
    favoriteDo.hint = self.hint;
    
    favoriteDo.aes1 = newFilePrefix;
    favoriteDo.aes2 = newFilePrefix;
    favoriteDo.aes3 = newFilePrefix;
    favoriteDo.aes4 = newFilePrefix;
    favoriteDo.aes5 = newFilePrefix;
    favoriteDo.aes6 = newFilePrefix;
    favoriteDo.regdate = [DBUtil getCurrentDate];
    favoriteDo.reminder = @"";
    
    if (isOverwrite) {
        if (![DBUtil updateFavorite:favoriteDo]) {
            NSLog(@"[DEBUG]saveClicked:updateFavorite Fail!!\n");
        }
        [mainViewCtl showMessageLabel:@"Update Success!!"];
    } else {
        if (![DBUtil insertFavorite:favoriteDo]) {
            NSLog(@"[DEBUG]saveClicked:insertFavorite Fail!!\n");
        }
        [mainViewCtl showMessageLabel:@"Save Success!!"];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(showKeyLast) userInfo:NULL repeats:NO];	
    
    favoriteDo = nil; [favoriteDo release];
    
    [self touchToClose:nil];

}
- (void)saveClicked {
    self.key = keyTF.text;
    [self clearKeyboard];
    if ([self.key length] < 1) {
        [mainViewCtl showMessageLabel:@"Input Encryption Key!!"];
        keyTF.backgroundColor = [UIColor yellowColor];
        NSInteger section = 2;
        NSInteger row = 0;
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
        [listView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"You have to remember the Encryption Key. Are you sure?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = 100;
        [alert show];
        [alert release];
        alert = nil;
    }
}
- (void)showKeyLast{
    if (![self.key isEqualToString:@""]&&[self.key length] >= 1){
        NSString *_msg = [NSString stringWithFormat:@"Do not forget Key:[%@]",self.key];
        [mainViewCtl showMessageLabelLong:_msg];
        
        [self resetButtonClicked:nil];
        
        self.key = @"";
        keyTF.text = self.key;
    }
}
- (void)decryptClicked {
    [self clearKeyboard];
    self.key = keyTF.text;
    
    if (encDataList == nil || ![self.info1 hasPrefix:@"*"]) {
        [mainViewCtl showMessageLabel:@"Not Encryption Status"];//No information for decryptions!"];
        
        NSInteger section = 2;
        NSInteger row = 0;
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
        [listView selectRowAtIndexPath:idxPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];

    } else if ([self.key length] < 1) {
        [mainViewCtl showMessageLabel:@"No Key for decryptions!"];
        keyTF.backgroundColor = [UIColor yellowColor];
        NSInteger section = 2;
        NSInteger row = 0;
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
        [listView selectRowAtIndexPath:idxPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    } else {
        [actIndicator startAnimating];
        [mainViewCtl showMessageLabel:@"Decryption Start..."];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.2];
        [blackLabel setFrame:CGRectMake(0, 40, 320, 420)];
        [UIView commitAnimations];

        
        [NSTimer scheduledTimerWithTimeInterval:0.000000001f target:self selector:@selector(showDecryptStartSign) userInfo:NULL repeats:NO];	

    }
}
- (void)showDecryptStartSign{
    NSString *password = self.key;//@"1234";
    int i = 0;
    self.info1 = [mainViewCtl decryptDo:[encDataList objectAtIndex:i] :password];
    if ([self.info1 isEqualToString:@"HMAC Mismatch"]) {
        [mainViewCtl showMessageLabel:[NSString stringWithFormat:@"Decryption Key(%@) mismatch!!\n",password]];
        self.info1 = @"";

        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.2];
        [blackLabel setFrame:CGRectMake(321, 40, 320, 420)];
        [UIView commitAnimations];
        
        [actIndicator stopAnimating];

        return;
    }
    
    i++;
    self.info2 = [mainViewCtl decryptDo:[encDataList objectAtIndex:i] :password];
    
    i++;
    self.info3 = [mainViewCtl decryptDo:[encDataList objectAtIndex:i] :password];
    i++;
    self.info4 = [mainViewCtl decryptDo:[encDataList objectAtIndex:i] :password];
    i++;
    self.info5 = [mainViewCtl decryptDo:[encDataList objectAtIndex:i] :password];
    i++;
    self.info6 = [mainViewCtl decryptDo:[encDataList objectAtIndex:i] :password];
    
    [self showDecryptEndSign];
}
- (void)showDecryptEndSign{
    [mainViewCtl showMessageLabel:@"Decryption Complete..."];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.2];
    [blackLabel setFrame:CGRectMake(321, 40, 320, 420)];
    [UIView commitAnimations];

    [actIndicator stopAnimating];
    [listView reloadData];
}

- (void)encryptClicked {
    [self clearKeyboard];
    
    self.key = keyTF.text;
    
    if ([self.key length] < 1) {
        keyTF.backgroundColor = [UIColor yellowColor];
        [mainViewCtl showMessageLabel:@"No Key for encryptions!"];
        NSInteger section = 2;
        NSInteger row = 0;
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
        [listView selectRowAtIndexPath:idxPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    } else if ([self.info1 hasPrefix:@"*"]){
        [mainViewCtl showMessageLabel:@"Already Encrypted Status!"];
    } else if ([self.info1 length] < 1){
        [mainViewCtl showMessageLabel:@"No information for encryption"];
    } else {
        [actIndicator startAnimating];
        [mainViewCtl showMessageLabel:@"Encryption Start..."];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.2];
        [blackLabel setFrame:CGRectMake(0, 40, 320, 420)];
        [UIView commitAnimations];
        
        [NSTimer scheduledTimerWithTimeInterval:0.000000001f target:self selector:@selector(showEncryptStartSign) userInfo:NULL repeats:NO];
    }
}
- (void)showEncryptStartSign{
    if ([info1 hasPrefix:@"*"]) {
        [mainViewCtl showMessageLabel:@"Already Encrypted..\n"];
        [actIndicator stopAnimating];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.2];
        [blackLabel setFrame:CGRectMake(321, 40, 320, 420)];
        [UIView commitAnimations];
        return;
    }
    NSString *password = self.key;//@"1234";
    if ([self.info1 length] >= 1) {
        self.encInfo1 = [mainViewCtl encryptDo:self.info1 :password];
    } else
        self.info1 = @" ";

    if ([self.info2 length] >= 1)
    self.encInfo2 = [mainViewCtl encryptDo:self.info2 :password];
    else
        self.info2 = @" ";

    if ([self.info3 length] >= 1)
    self.encInfo3 = [mainViewCtl encryptDo:self.info3 :password];
    else
        self.info3 = @" ";
    
    if ([self.info4 length] >= 1)
    self.encInfo4 = [mainViewCtl encryptDo:self.info4 :password];
    else
        self.info4 = @" ";
    
    if ([self.info5 length] >= 1)
    self.encInfo5 = [mainViewCtl encryptDo:self.info5 :password];
    else
        self.info5 = @" ";

    if ([info6TV.text length] >= 1) {
        //   self.encInfo6 = [mainViewCtl encryptDo:self.info6 :password];
        self.info6 = info6TV.text;
    } else
        self.info6 = @" ";
    
    
    encDataList = [[NSMutableArray alloc] initWithObjects:[mainViewCtl encryptDo:self.info1 :password],[mainViewCtl encryptDo:self.info2 :password],[mainViewCtl encryptDo:self.info3 :password],[mainViewCtl encryptDo:self.info4 :password],[mainViewCtl encryptDo:self.info5 :password],[mainViewCtl encryptDo:self.info6 :password], nil];


    NSString *_sign=@"";
    for (int i=0;i<[self.info1 length];i++)
        _sign = [NSString stringWithFormat:@"%@%@",_sign,@"*"];
    self.info1=_sign;

    _sign = @"";
    for (int i=0;i<[self.info2 length];i++)
        _sign = [NSString stringWithFormat:@"%@%@",_sign,@"*"];
    self.info2=_sign;

    _sign = @"";
    for (int i=0;i<[self.info3 length];i++)
        _sign = [NSString stringWithFormat:@"%@%@",_sign,@"*"];
    self.info3=_sign;

    _sign = @"";
    for (int i=0;i<[self.info4 length];i++)
        _sign = [NSString stringWithFormat:@"%@%@",_sign,@"*"];
    self.info4=_sign;

    _sign = @"";
    for (int i=0;i<[self.info5 length];i++)
        _sign = [NSString stringWithFormat:@"%@%@",_sign,@"*"];
    self.info5=_sign;

    _sign = @"";
    for (int i=0;i<[self.info6 length];i++)
        _sign = [NSString stringWithFormat:@"%@%@",_sign,@"*"];
    self.info6=_sign;

    [self showEncryptEndSign];
}
- (void)showEncryptEndSign{
    [mainViewCtl showMessageLabel:@"Encryption Completed..."];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.2];
    [blackLabel setFrame:CGRectMake(321, 40, 320, 420)];
    [UIView commitAnimations];
    
    [actIndicator stopAnimating];
    [listView reloadData];
}
- (void)encryptStart{
    if ([info1 hasPrefix:@"*"]) {
        [mainViewCtl showMessageLabel:@"Already Encrypted..\n"];
        [actIndicator stopAnimating];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.2];
        [blackLabel setFrame:CGRectMake(321, 40, 320, 420)];
        [UIView commitAnimations];
        return;
    }
    NSString *password = self.key;//@"1234";
    if ([self.info1 length] >= 1) {
        self.encInfo1 = [mainViewCtl encryptDo:self.info1 :password];
    } else
        self.info1 = @" ";
    
    if ([self.info2 length] >= 1) {
      //  self.encInfo2 = [mainViewCtl encryptDo:self.info2 :password];
    } else
        self.info2 = @" ";
    
    if ([self.info3 length] >= 1) {
      //  self.encInfo3 = [mainViewCtl encryptDo:self.info3 :password];
    } else
        self.info3 = @" ";
    
    if ([self.info4 length] >= 1) {
     //   self.encInfo4 = [mainViewCtl encryptDo:self.info4 :password];
    } else
        self.info4 = @" ";
    
    if ([self.info5 length] >= 1) {
     //   self.encInfo5 = [mainViewCtl encryptDo:self.info5 :password];
    } else
        self.info5 = @" ";
    
    if ([info6TV.text length] >= 1) {
     //   self.encInfo6 = [mainViewCtl encryptDo:self.info6 :password];
        self.info6 = info6TV.text;
    } else
        self.info6 = @" ";
    
    encDataList = [[NSMutableArray alloc] initWithObjects:[mainViewCtl encryptDo:self.info1 :password],[mainViewCtl encryptDo:self.info2 :password],[mainViewCtl encryptDo:self.info3 :password],[mainViewCtl encryptDo:self.info4 :password],[mainViewCtl encryptDo:self.info5 :password],[mainViewCtl encryptDo:self.info6 :password], nil];
    
    
    NSString *_sign=@"";
    for (int i=0;i<[self.info1 length];i++)
        _sign = [NSString stringWithFormat:@"%@%@",_sign,@"*"];
    self.info1=_sign;
    
    _sign = @"";
    for (int i=0;i<[self.info2 length];i++)
        _sign = [NSString stringWithFormat:@"%@%@",_sign,@"*"];
    self.info2=_sign;
    
    _sign = @"";
    for (int i=0;i<[self.info3 length];i++)
        _sign = [NSString stringWithFormat:@"%@%@",_sign,@"*"];
    self.info3=_sign;
    
    _sign = @"";
    for (int i=0;i<[self.info4 length];i++)
        _sign = [NSString stringWithFormat:@"%@%@",_sign,@"*"];
    self.info4=_sign;
    
    _sign = @"";
    for (int i=0;i<[self.info5 length];i++)
        _sign = [NSString stringWithFormat:@"%@%@",_sign,@"*"];
    self.info5=_sign;
    
    _sign = @"";
    for (int i=0;i<[self.info6 length];i++)
        _sign = [NSString stringWithFormat:@"%@%@",_sign,@"*"];
    self.info6=_sign;
    
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    NSInteger nrows;
    switch (section) {
        case 0:
            nrows = 2;
            break;
        case 1:
            nrows = 6;
            break;
        case 2:
            nrows = 2;
            break;
        default:
            break;
    }
	return nrows;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //NSLog(@"textViewShouldBeginEditing:textView.text:%@\n",textView.text);
    if ([textView.text hasPrefix:@"*"]) {
        [mainViewCtl showMessageLabel:@"Do not edit the encrypted info!"];
        [textView resignFirstResponder];
        return NO;
    }
    NSInteger section = 1;
    NSInteger row = 5;
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
    [listView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
//    [self scrollInfoTv];

    if ([textView.text hasPrefix:@"*"]) {
        [mainViewCtl showMessageLabel:@"Do not edit the encrypted info!"];
        [textView resignFirstResponder];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [listView setFrame:CGRectMake(0, 40 , 320, 420)];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {   
    if ([[NSCharacterSet newlineCharacterSet] characterIsMember:[text characterAtIndex:[text length]-1]]) {
     
        return YES;
    } else {
        if ([textView.text hasPrefix:@"*"]) {
            [mainViewCtl showMessageLabel:@"Do not edit the encrypted info!"];
            [textView resignFirstResponder];
            return NO;
        }
        
    }
    return YES;
    
}
- (void)scrollInfoTv{
    NSInteger section = 1;
    NSInteger row = 5;
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
    [listView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
    if(sender.returnKeyType == UIReturnKeyNext){
        switch (sender.tag) {
            case 0:
                [descTF becomeFirstResponder];
                break;
            case 1:
                if ([info1TF.text hasPrefix:@"*"]) {
                    [descTF resignFirstResponder];    
                    [mainViewCtl showMessageLabel:@"Do not edit the encrypted info!"];
                } else {
                    [info1TF becomeFirstResponder];
                }
                break;
            case 10:
                [info2TF becomeFirstResponder];
                break;
            case 11:
                [info3TF becomeFirstResponder];
                break;
            case 12:
                [info4TF becomeFirstResponder];
                break;
            case 13:
                [info5TF becomeFirstResponder];
                break;
            case 14:
                [self scrollInfoTv];
                [info6TV becomeFirstResponder];
                break;
            case 15:
                [keyTF becomeFirstResponder];
            case 20:
                [hintTF becomeFirstResponder];
                break;
            default:
                break;
        }
        self.overTapBtn.enabled=YES;
    }else if(sender.returnKeyType == UIReturnKeyDone){
        [sender resignFirstResponder];
        self.overTapBtn.enabled=NO;
        
        NSInteger section = sender.tag/10;
        NSInteger row = sender.tag%10;
        
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
        
        [listView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }else{
        [sender resignFirstResponder];
    }

    return YES;    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.text hasPrefix:@"*"]) {
        [mainViewCtl showMessageLabel:@"Do not edit the encrypted info!"];
        [textField resignFirstResponder];
        return;
    }
    currentField = textField;// temporary store object
    self.overTapBtn.enabled=YES;
    
    int _y,_h;
    if (textField.tag >= 10 && textField.tag < 20) {
        NSInteger _row = textField.tag % 10;
        _y = -50*_row;
        _h = 1200;
        
        NSInteger section = textField.tag/10;
        NSInteger row = textField.tag%10;

        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
        [listView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else if (textField.tag == 20 || textField.tag == 21) {
        _y = -450;
        _y = -475;
        _y = -50;
        _h = 1200;
        _h=420;
        [listView setFrame:CGRectMake(0, _y, 320, _h)];

        NSInteger section = 2;
        NSInteger row = 0;
        
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
        [listView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    if (textField.tag == 20) {
        keyTF.backgroundColor = [UIColor groupTableViewBackgroundColor];//
        
        [self.overTapBtn setFrame:CGRectMake(0, 45, 110, 95)];

    } else {
        [self.overTapBtn setFrame:CGRectMake(0, 45, 110, 200)];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.2];
    [listView setFrame:CGRectMake(0, 40, 320, 420)];
    [UIView commitAnimations];

    _endTFtag = textField.tag;
    
    switch (_endTFtag) {
        case 0:
            self.title = textField.text;
            break;
        case 1:
            self.desc = textField.text;
            break;
        case 10:
            self.info1 = textField.text;
            break;
        case 11:
            self.info2 = textField.text;
            break;
        case 12:
            self.info3 = textField.text;
            break;
        case 13:
            self.info4 = textField.text;
            break;
        case 14:
            self.info5 = textField.text;
            break;
        case 15:
            self.info6 = textField.text;
            break;
        case 20:
            self.key = textField.text;
            break;
        case 21:
            self.hint = textField.text;
            break;
        default:
            break;
    }
    self.overTapBtn.enabled=NO;
}
- (IBAction)overTapBtnClicked:(id)sender{
    [self clearKeyboard];
    overTapBtn.enabled = FALSE;
    [self.overTapBtn setFrame:CGRectMake(6, 46, 105, 352)];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *SetTableIdentifier = @"SetTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SetTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:SetTableIdentifier];
    }

    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];

    CGRect textViewRect = CGRectMake(120, 7, 165, 30);
    CGRect searchRect = CGRectMake(12, 7, 273, 30);

    NSInteger tagIdx = section*10+row;
    
    if (section == 0 && row == 0) { // search keyword
        UILabel *folderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 220, 44)] autorelease];
        folderLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        if (isKorean)
            folderLabel.text = @"Title";
        else
            folderLabel.text = @"Title";
        folderLabel.backgroundColor = [UIColor clearColor];//
        folderLabel.textColor = [UIColor blackColor];
        folderLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:folderLabel];

        titleTF = [[[UITextField alloc] initWithFrame:textViewRect] autorelease];
        titleTF.delegate = self;
        titleTF.font = [UIFont boldSystemFontOfSize:17.0F];//boldSystemFontOfSize
        titleTF.text = self.title;
        titleTF.backgroundColor = [UIColor groupTableViewBackgroundColor];//
        titleTF.textColor = [UIColor blackColor];
        titleTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [titleTF setReturnKeyType:UIReturnKeyNext];
        titleTF.enablesReturnKeyAutomatically=YES;
        titleTF.tag = tagIdx;
        [cell.contentView addSubview:titleTF];
        
        UIButton *regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        regionBtn.tag = tagIdx;
        regionBtn.Frame=searchRect;
        regionBtn.showsTouchWhenHighlighted = TRUE;
        [regionBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        [cell.contentView addSubview:regionBtn];
    } else if (section == 0 && row == 1) {
        UILabel *folderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 220, 44)] autorelease];
        folderLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        if (isKorean)
            folderLabel.text = @"Description";
        else
            folderLabel.text = @"Description";
        folderLabel.backgroundColor = [UIColor clearColor];//
        folderLabel.textColor = [UIColor blackColor];
        folderLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:folderLabel];
        //[folderLabel release];
        
        descTF = [[[UITextField alloc] initWithFrame:textViewRect] autorelease];
        descTF.delegate = self;
        descTF.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        descTF.text = self.desc;
        descTF.backgroundColor = [UIColor groupTableViewBackgroundColor];//
        descTF.textColor = [UIColor blackColor];
        descTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [descTF setReturnKeyType:UIReturnKeyNext];
        descTF.enablesReturnKeyAutomatically=YES;
        descTF.tag = tagIdx;
        [cell.contentView addSubview:descTF];
        
        UIButton *regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        regionBtn.tag = tagIdx;
        regionBtn.Frame=searchRect;
        regionBtn.showsTouchWhenHighlighted = TRUE;
        [regionBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        [cell.contentView addSubview:regionBtn];
    } else if (section == 1 && row == 0) { // CATEGORY
        UILabel *folderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 220, 44)] autorelease];
        folderLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        if (isKorean)
            folderLabel.text = @"Information1";
        else
            folderLabel.text = @"Information1";
        folderLabel.backgroundColor = [UIColor clearColor];//
        folderLabel.textColor = [UIColor blackColor];
        folderLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:folderLabel];
        //[folderLabel release];
        
        info1TF = [[[UITextField alloc] initWithFrame:textViewRect] autorelease];
        info1TF.delegate = self;
        info1TF.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        info1TF.text = self.info1;
        info1TF.backgroundColor = [UIColor groupTableViewBackgroundColor];//
        info1TF.textColor = [UIColor blackColor];
        info1TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [info1TF setReturnKeyType:UIReturnKeyNext];
        info1TF.enablesReturnKeyAutomatically=YES;
        info1TF.tag = tagIdx;
        [cell.contentView addSubview:info1TF];
        
        UIButton *regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        regionBtn.tag = tagIdx;
        regionBtn.Frame=searchRect;
        regionBtn.showsTouchWhenHighlighted = TRUE;
        [regionBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        [cell.contentView addSubview:regionBtn];
    } else if (section == 1 && row == 1) { // DURATION
        UILabel *folderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 220, 44)] autorelease];
        folderLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        if (isKorean)
            folderLabel.text = @"Information2";
        else
            folderLabel.text = @"Information2";
        folderLabel.backgroundColor = [UIColor clearColor];//
        folderLabel.textColor = [UIColor blackColor];
        folderLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:folderLabel];
        //[folderLabel release];
        
        info2TF = [[[UITextField alloc] initWithFrame:textViewRect] autorelease];
        info2TF.delegate = self;
        info2TF.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        info2TF.text = self.info2;
        info2TF.backgroundColor = [UIColor groupTableViewBackgroundColor];//
        info2TF.textColor = [UIColor blackColor];
        info2TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [info2TF setReturnKeyType:UIReturnKeyNext];
        info2TF.enablesReturnKeyAutomatically=YES;
        info2TF.tag = tagIdx;
        [cell.contentView addSubview:info2TF];
        
        UIButton *regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        regionBtn.tag = tagIdx;
        regionBtn.Frame=searchRect;
        regionBtn.showsTouchWhenHighlighted = TRUE;
        [regionBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        [cell.contentView addSubview:regionBtn];
    } else if (section == 1 && row == 2) { // license
        UILabel *folderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 220, 44)] autorelease];
        folderLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        if (isKorean)
            folderLabel.text = @"Information3";
        else
            folderLabel.text = @"Information3";
        folderLabel.backgroundColor = [UIColor clearColor];//
        folderLabel.textColor = [UIColor blackColor];
        folderLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:folderLabel];
        //[folderLabel release];
        
        info3TF = [[[UITextField alloc] initWithFrame:textViewRect] autorelease];
        info3TF.delegate = self;
        info3TF.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        info3TF.text = self.info3;
        info3TF.backgroundColor = [UIColor groupTableViewBackgroundColor];//
        info3TF.textColor = [UIColor blackColor];
        info3TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [info3TF setReturnKeyType:UIReturnKeyNext];
        info3TF.enablesReturnKeyAutomatically=YES;
        info3TF.tag = tagIdx;
        [cell.contentView addSubview:info3TF];
        
        UIButton *regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        regionBtn.tag = tagIdx;
        regionBtn.Frame=searchRect;
        regionBtn.showsTouchWhenHighlighted = TRUE;
        [regionBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        [cell.contentView addSubview:regionBtn];
        
    } else if (section == 1 && row == 3) { // lr
        UILabel *folderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 220, 44)] autorelease];
        folderLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        if (isKorean)
            folderLabel.text = @"Information4";
        else
            folderLabel.text = @"Information4";
        folderLabel.backgroundColor = [UIColor clearColor];//
        folderLabel.textColor = [UIColor blackColor];
        folderLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:folderLabel];
        //[folderLabel release];
        
        info4TF = [[[UITextField alloc] initWithFrame:textViewRect] autorelease];
        info4TF.delegate = self;
        info4TF.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        info4TF.text = self.info4;
        info4TF.backgroundColor = [UIColor groupTableViewBackgroundColor];//
        info4TF.textColor = [UIColor blackColor];
        info4TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [info4TF setReturnKeyType:UIReturnKeyNext];
        info4TF.enablesReturnKeyAutomatically=YES;
        info4TF.tag = tagIdx;
        [cell.contentView addSubview:info4TF];
        
        UIButton *regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        regionBtn.tag = tagIdx;
        regionBtn.Frame=searchRect;
        regionBtn.showsTouchWhenHighlighted = TRUE;
        [regionBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        [cell.contentView addSubview:regionBtn];

    } else if (section == 1 && row == 4) { // lr
        UILabel *folderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 220, 44)] autorelease];
        folderLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        if (isKorean)
            folderLabel.text = @"Information5";
        else
            folderLabel.text = @"Information5";
        folderLabel.backgroundColor = [UIColor clearColor];//
        folderLabel.textColor = [UIColor blackColor];
        folderLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:folderLabel];
        //[folderLabel release];
        
        info5TF = [[[UITextField alloc] initWithFrame:textViewRect] autorelease];
        info5TF.delegate = self;
        info5TF.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        info5TF.text = self.info5;
        info5TF.backgroundColor = [UIColor groupTableViewBackgroundColor];//
        info5TF.textColor = [UIColor blackColor];
        info5TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [info5TF setReturnKeyType:UIReturnKeyNext];
        info5TF.enablesReturnKeyAutomatically=YES;
        info5TF.tag = tagIdx;
        [cell.contentView addSubview:info5TF];
        
        UIButton *regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        regionBtn.tag = tagIdx;
        regionBtn.Frame=searchRect;
        regionBtn.showsTouchWhenHighlighted = TRUE;
        [regionBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        [cell.contentView addSubview:regionBtn];
    } else if (section == 1 && row == 5) { // lr
        UILabel *folderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 220, 44)] autorelease];
        folderLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        if (isKorean)
            folderLabel.text = @"Information6";
        else
            folderLabel.text = @"Information6";
        folderLabel.backgroundColor = [UIColor clearColor];//
        folderLabel.textColor = [UIColor blackColor];
        folderLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:folderLabel];
        CGRect textViewRect = CGRectMake(10, 40, 280, 70);

        info6TV = [[[UITextView alloc] initWithFrame:textViewRect] autorelease];
        info6TV.delegate = self;
        info6TV.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        info6TV.enablesReturnKeyAutomatically = FALSE;
        info6TV.text = self.info6;
        info6TV.backgroundColor = [UIColor groupTableViewBackgroundColor];//
        info6TV.textColor = [UIColor blackColor];
        [info6TV setReturnKeyType:UIReturnKeyNext];//****
        info6TV.enablesReturnKeyAutomatically=YES;
        info6TV.tag = tagIdx;
        [cell.contentView addSubview:info6TV];

        UIButton *regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        regionBtn.tag = tagIdx;
        regionBtn.Frame=searchRect;
        regionBtn.showsTouchWhenHighlighted = TRUE;
        [regionBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        [cell.contentView addSubview:regionBtn];

    } else if (section == 2 && row == 0) {
    
        UILabel *folderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 220, 44)] autorelease];
        folderLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        if (isKorean)
            folderLabel.text = @"Key";
        else
            folderLabel.text = @"Key";
        folderLabel.backgroundColor = [UIColor clearColor];//
        folderLabel.textColor = [UIColor blackColor];
        folderLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:folderLabel];

        keyTF = [[[UITextField alloc] initWithFrame:textViewRect] autorelease];
        keyTF.delegate = self;
        keyTF.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        keyTF.text = self.key;
        keyTF.backgroundColor = [UIColor groupTableViewBackgroundColor];//
        keyTF.textColor = [UIColor blackColor];
        keyTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [keyTF setReturnKeyType:UIReturnKeyNext];//****
        keyTF.enablesReturnKeyAutomatically=YES;
        keyTF.tag = tagIdx;
        [cell.contentView addSubview:keyTF];
        
        UIButton *regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        regionBtn.tag = tagIdx;
        regionBtn.Frame=searchRect;
        regionBtn.showsTouchWhenHighlighted = TRUE;
        [regionBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        [cell.contentView addSubview:regionBtn];
    } else if (section == 2 && row == 1) {
        
        UILabel *folderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 220, 44)] autorelease];
        folderLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        if (isKorean)
            folderLabel.text = @"Hint";
        else
            folderLabel.text = @"Hint";
        folderLabel.backgroundColor = [UIColor clearColor];//
        folderLabel.textColor = [UIColor blackColor];
        folderLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:folderLabel];

        hintTF = [[[UITextField alloc] initWithFrame:textViewRect] autorelease];
        hintTF.delegate = self;
        hintTF.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        hintTF.text = self.hint;
        hintTF.backgroundColor = [UIColor groupTableViewBackgroundColor];//
        hintTF.textColor = [UIColor blackColor];
        hintTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [hintTF setReturnKeyType:UIReturnKeyDone];//****
        hintTF.enablesReturnKeyAutomatically=YES;
        hintTF.tag = tagIdx;
        [cell.contentView addSubview:hintTF];
        
        UIButton *regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        regionBtn.tag = tagIdx;
        regionBtn.Frame=searchRect;
        regionBtn.showsTouchWhenHighlighted = TRUE;
        [regionBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0F];//boldSystemFontOfSize
        [cell.contentView addSubview:regionBtn];
    } 

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SetTableIdentifier = nil; [SetTableIdentifier release];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if (section == 1 && row == 5) {
        return 120;
    } else {
        return 44;
    }
}
#pragma mark -
#pragma mark UITableViewDelegate.
- (IBAction)touchToClose:(id)sender{
    [self clearKeyboard];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView	setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(321, 0, 320, 460)];
    [UIView commitAnimations];

    [mainViewCtl.myViewCtl refreshListView];
    
    self.listView.scrollsToTop = NO;
    mainViewCtl.myViewCtl.listView.scrollsToTop = YES;

    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(setScroll) userInfo:NULL repeats:NO];
}
- (void)setScroll{
    NSInteger section = 0;
    NSInteger row = 0;
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
    [listView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)removeSelfView {
    [self.view removeFromSuperview];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (void)clearKeyboard {
    NSInteger sectionRow;
    if (titleTF.isFirstResponder) {
        [titleTF resignFirstResponder];
        sectionRow = titleTF.tag;
    }
    
    if (descTF.isFirstResponder) {
        [descTF resignFirstResponder];
        sectionRow = descTF.tag;
    }
    if (info1TF.isFirstResponder) {
        [info1TF resignFirstResponder];
        sectionRow = info1TF.tag;
    }
    if (info2TF.isFirstResponder){
        [info2TF resignFirstResponder];
        sectionRow = info2TF.tag;
    }
    if (info3TF.isFirstResponder){
        [info3TF resignFirstResponder];
        sectionRow = info2TF.tag;
    }
    if (info4TF.isFirstResponder) {
        [info4TF resignFirstResponder];
        sectionRow = info4TF.tag;
    }
    if (info5TF.isFirstResponder) {
        [info5TF resignFirstResponder];
        sectionRow = info5TF.tag;
    }
    if (info6TV.isFirstResponder) {
        [info6TV resignFirstResponder];
        sectionRow = info6TV.tag;
    }
    if (keyTF.isFirstResponder) {
        [keyTF resignFirstResponder];
        sectionRow = keyTF.tag;
    }
    if (hintTF.isFirstResponder) {
        [hintTF resignFirstResponder];
        sectionRow = hintTF.tag;
    }
    
    NSInteger section = sectionRow / 10;
    NSInteger row = sectionRow % 10;
    
    if (section >=0 && section <=2 && row >=0){
        
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section] ;
        [listView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}
- (void)resignAnyKeyboard {
    if (titleTF.isFirstResponder) {
        [titleTF resignFirstResponder];
    }
    
    if (descTF.isFirstResponder) {
        [descTF resignFirstResponder];
    }
    if (info1TF.isFirstResponder) {
        [info1TF resignFirstResponder];
    }
    if (info2TF.isFirstResponder){
        [info2TF resignFirstResponder];
    }
    if (info3TF.isFirstResponder){
        [info3TF resignFirstResponder];
    }
    if (info4TF.isFirstResponder) {
        [info4TF resignFirstResponder];
    }
    if (info5TF.isFirstResponder) {
        [info5TF resignFirstResponder];
    }
    if (info6TV.isFirstResponder) {
        [info6TV resignFirstResponder];
    }
    if (keyTF.isFirstResponder) {
        [keyTF resignFirstResponder];
    }
    if (hintTF.isFirstResponder) {
        [hintTF resignFirstResponder];
    }
}

- (IBAction)buttonClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger tagIdx = btn.tag;
    
    NSInteger section = tagIdx/10;
    NSInteger row = tagIdx%10;
    
    if (section == 0 && row == 0) { 
        [titleTF becomeFirstResponder];
    } else if (section == 0 && row == 1) { 
        [descTF becomeFirstResponder];
    } else if (section == 1 && row == 0) { 
        [info1TF becomeFirstResponder];
    } else if (section == 1 && row == 1) { 
        [info2TF becomeFirstResponder];
    } else if (section == 1 && row == 2) {
        [info3TF becomeFirstResponder];
    } else if (section == 1 && row == 3) {
        [info4TF becomeFirstResponder];
    } else if (section == 1 && row == 4) {
        [info5TF becomeFirstResponder];
    } else if (section == 1 && row == 5) {
        [info6TV becomeFirstResponder];
    } else if (section == 2 && row == 0) {
        [keyTF becomeFirstResponder];
    } else if (section == 2 && row == 1) {
        [hintTF becomeFirstResponder];
    }     
}
- (IBAction)resetButtonClicked:(id)sender {
    [self clearKeyboard];
    NSString *_str = @"";
    
    self.title = _str;
    self.desc = _str;
    self.info1 = _str;
    self.info2 = _str;
    self.info3 = _str;
    self.info4 = _str;
    self.info5 = _str;
    self.info6 = _str;
    self.key = _str;
    self.hint = _str;
    
    titleTF.text = self.title;
    descTF.text = self.desc;
    info1TF.text = self.info1;
    info2TF.text = self.info2;
    info3TF.text = self.info3;
    info4TF.text = self.info4;
    info5TF.text = self.info5;
    info6TV.text = self.info6;
    
    keyTF.text = self.key;
    hintTF.text = self.hint;
    
    [listView reloadData];
}
#pragma mark -
#pragma mark button handle
- (void)reloadListView {

    [listView reloadData];
}
- (NSArray *)getCurrentIndexPaths{
    return [listView indexPathsForVisibleRows];
}
#pragma mark -
#pragma mark UIPickerViewDataSource

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        NSString *btntitle = [alertView buttonTitleAtIndex:buttonIndex];
        
        if([btntitle isEqualToString:@"YES"]) {
            [self saveYesSelectDo];
        } else if([btntitle isEqualToString:@"NO"]) {
        }
    }
}
- (void) actIndicatorStart:(NSTimer *) time {
	[actIndicator startAnimating];
}

- (void) actIndicatorStop:(NSTimer *) time {
	[actIndicator stopAnimating];
}

@end
