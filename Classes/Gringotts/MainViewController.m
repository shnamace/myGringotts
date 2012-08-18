//
//  MainViewController.m
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import "MainViewController.h"
#import "Header.h"
#import "SetFileManager.h"
#import "MyViewController.h"
#import "RNCryptor.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@implementation MainViewController
@synthesize app;
@synthesize tabBar;
@synthesize myViewCtl;
@synthesize encryptViewCtl;
@synthesize isKorean;
@synthesize messageLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		// Custom initialization
	}
	
	return self;
}
- (NSData *)encryptDo:(NSString *)_str :(NSString *)password{
    NSData *data = [_str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *encrypted = [[RNCryptor AES256Cryptor] encryptData:data password:password error:&error];
    return encrypted;
}
- (NSString *)decryptDo:(NSData *)data :(NSString *)password{
    NSError *error;
    NSData *decrypted = [[RNCryptor AES256Cryptor] decryptData:data password:password error:&error];
    if (decrypted == nil) {
        if (error != nil) {
            return @"HMAC Mismatch";
        }
    }
    NSString* decryptedStr = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    return decryptedStr;
}
- (void)viewDidLoad {
	self.isKorean = FALSE;
	isRetina = FALSE; 	
	[self checkRetinaSupport];
	[super viewDidLoad];
    
    encryptViewCtl = nil;
        
    myViewCtl = [[MyViewController alloc] initWithNibName:@"MyView" bundle:nil ];
    [myViewCtl.view setFrame:CGRectMake(0, 0, 320, 460)];
    [myViewCtl setMainViewCtl:self];
    [self.view addSubview:myViewCtl.view];
    encryptViewCtl = [[EncryptViewController alloc] initWithNibName:@"EncryptView" bundle:nil ];
    [encryptViewCtl.view setFrame:CGRectMake(321, 0, 320, 460)];
    [encryptViewCtl setMainViewCtl:self];
    [self.view addSubview:encryptViewCtl.view];

}
- (IBAction)openEncryptView:(id)sender{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.2];
    [encryptViewCtl.view setFrame:CGRectMake(0, 0, 320, 460)];
    [UIView commitAnimations];
    [encryptViewCtl.blackLabel setFrame:CGRectMake(321, 40, 320, 420)];
    
    myViewCtl.listView.scrollsToTop = YES;
    encryptViewCtl.listView.scrollsToTop = NO;
    
    [encryptViewCtl resetButtonClicked:nil];
    [encryptViewCtl initialDo:nil];
}
- (void)openEncryptViewForUpdate:(FavoriteDo *)fd{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.2];
    [encryptViewCtl.view setFrame:CGRectMake(0, 0, 320, 460)];
    [UIView commitAnimations];
    [encryptViewCtl.blackLabel setFrame:CGRectMake(321, 40, 320, 420)];
    
    myViewCtl.listView.scrollsToTop = YES;
    encryptViewCtl.listView.scrollsToTop = NO;
    
    [encryptViewCtl resetButtonClicked:nil];
    [encryptViewCtl initialDo:fd];
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations ???
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
			[self.view setFrame:CGRectMake(0, 20, 320, 460)];
	} else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight ) {
			[self.view setFrame:CGRectMake(0, 20, 320, 460)];
	} else if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
			[self.view setFrame:CGRectMake(0, 20, 320, 460)]; 
			[self.view bringSubviewToFront:app.view];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.tabBar = nil;
    self.myViewCtl = nil;
    self.encryptViewCtl = nil;
	self.app = nil;  // final test
    self.messageLabel = nil;
}

- (void)dealloc {
	[app release];
    [tabBar release];
    [myViewCtl release];
    [encryptViewCtl release];
    [messageLabel release];
	[super dealloc];		
}

- (void) checkRetinaSupport {
	isRetina =FALSE;
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [UIImage instancesRespondToSelector:@selector(scale)]) {
		BOOL isiPhone = YES;
#if __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
			isiPhone = NO;
		}	
#endif	
        if ([[UIScreen mainScreen] scale] == 2.0 && isiPhone) {
            isRetina = TRUE;
        } else {
            isRetina = FALSE;	
        }
	}
}		

- (void)checkLanguage {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
	NSMutableDictionary *tableDic = (NSMutableDictionary *)[SetFileManager loadSetFile];
	NSString *langSet = [tableDic objectForKey:@"langSet"];
	
	if ([langSet isEqualToString:@"KOR"]) {
		self.isKorean = TRUE;
	}	else {
		self.isKorean = FALSE;
	}
	langSet = nil; [langSet release];
	tableDic = nil; [tableDic release];
	[pool release];	
}	

// implement remote control v3.2.2
- (void)viewDidAppear:(BOOL)animated {
	//NSLog (@"viewDidAppear ... animated : %d\n", animated);
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
	//NSLog (@"viewWillDisappear ...\n");
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
	//NSLog (@"canBecomeFirstResponder ...\n");
	return YES;
}

- (IBAction)touchToAdBanner:(id)sender{
    if (self.isKorean)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/kr/app/id461445109?mt=8"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id461445109?mt=8"]];
}
- (void)showMessageLabel:(NSString *)msg{
    self.messageLabel.backgroundColor = [UIColor darkGrayColor];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.text = msg;
        
    [self.messageLabel setHidden:FALSE];
    [self.view bringSubviewToFront:messageLabel];
    
    showMsgTimer = nil;
    [showMsgTimer invalidate];

    showMsgTimer=[NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideMessageLabe) userInfo:nil repeats:NO];
}
- (void)showMessageLabelLong:(NSString *)msg{
    self.messageLabel.backgroundColor = [UIColor darkGrayColor];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.text = msg;
    
    [self.messageLabel setHidden:FALSE];
    [self.view bringSubviewToFront:messageLabel];
    
    showMsgTimer = nil;
    [showMsgTimer invalidate];
    
    showMsgTimer=[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(hideMessageLabe) userInfo:nil repeats:NO];
}

- (void)hideMessageLabe{
    [self.view sendSubviewToBack:messageLabel];
    [self.messageLabel setHidden:TRUE];
}

@end