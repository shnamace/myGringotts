//
//  MyViewController.m
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import "MyViewController.h"
#import "MyCommonTableViewCell.h"
#import "MainViewController.h"
#import "Header.h"
#import "FavoriteDo.h"
#import "DBUtil.h"
#import "SetFileManager.h"
@implementation MyViewController

@synthesize listView;
@synthesize myList;

@synthesize editBtn;
@synthesize deleteAllBtn;

@synthesize titleImageView;
@synthesize introLabel;
@synthesize introBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		// Custom initialization
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [self checkRetinaSupport];
    
	[self titleBtnEnable];
	
	actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[actIndicator setFrame:CGRectMake(297, 10, 20, 20)];
	[self.view addSubview:actIndicator];

    [introLabel setHidden:TRUE];
    [introBtn setHidden:TRUE];
    
	[super viewDidLoad];
    
    [actIndicator startAnimating];
    [self refreshListView];
    [actIndicator stopAnimating];
}
- (void)refreshListView {
    myList = [[NSMutableArray alloc] initWithArray:[DBUtil getFavoriteList]];
	[listView reloadData];
    
    if ([myList count] < 1) {
        [introLabel setHidden:FALSE];
        [introBtn setHidden:FALSE];
    } else {
        [introLabel setHidden:TRUE];
        [introBtn setHidden:TRUE];
    }
    
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	
	self.editBtn =nil;
	self.deleteAllBtn = nil;
	
	actIndicator = nil;
	
	self.myList = nil;
    
    self.titleImageView = nil;
    
    self.introLabel = nil;
    self.introBtn = nil;
}

- (void)dealloc {
	[listView release];
	[editBtn release];
	[deleteAllBtn release];

	[actIndicator release];
	
	[myList release];
    [titleImageView release];
    [introLabel release];
    [introBtn release];
	[super dealloc];
}

#pragma mark -
#pragma mark UITableViewDataSource.
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = (indexPath.row%2)?[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cell2.png"]]:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cell1.png"]];
    cell.backgroundColor = [UIColor clearColor];
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return ([myList count] > 0 ) ? [myList count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CommonTableIdentifier = @"MyCommonTableIdentifier";
	
	MyCommonTableViewCell *cell = (MyCommonTableViewCell *)[tableView
															dequeueReusableCellWithIdentifier:CommonTableIdentifier];
	
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyCommonTableViewCell" owner:self options:nil];
		
		for (id oneObject in nib)
			if ([oneObject isKindOfClass:[MyCommonTableViewCell class]])
				cell = (MyCommonTableViewCell *)oneObject;
		nib = nil; [nib release];
	}
	
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
	NSInteger row = [indexPath row];
	FavoriteDo *favoriteDo = (FavoriteDo *)[myList objectAtIndex:row];

    cell.title.text = favoriteDo.title;
    cell.desc.text = favoriteDo.desc;
    cell.regdate.text = favoriteDo.regdate;
    cell.seq.text = [NSString stringWithFormat:@"%d / %d",row+1, [myList count]];
    cell.nextBtn.tag = row;
    [cell.nextBtn addTarget:self action:@selector(touchToNext:) forControlEvents:UIControlEventTouchUpInside];

	CommonTableIdentifier = nil; [CommonTableIdentifier release];
	favoriteDo = nil; [favoriteDo release];
	[pool release];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

	return cell;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
	NSUInteger sRow = [sourceIndexPath row];
	NSUInteger dRow = [destinationIndexPath row];
	
	NSMutableArray *sourceMusicDos = [NSMutableArray arrayWithArray:myList];
    
	FavoriteDo *smusicDo = [myList objectAtIndex:sRow];
	FavoriteDo *dmusicDo = [myList objectAtIndex:dRow];
	
	[sourceMusicDos removeObjectAtIndex:sRow];
	[sourceMusicDos insertObject:smusicDo atIndex:dRow];
	
	myList = nil; [myList release];
	myList = [[NSMutableArray alloc] initWithArray:sourceMusicDos];
	
	sourceMusicDos = nil; [sourceMusicDos release];
	smusicDo = nil; [smusicDo release];
	dmusicDo = nil; [dmusicDo release];
	[pool release];	
    
}

#pragma mark -
#pragma mark UITableViewDelegate.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	    
    FavoriteDo *favoriteDo = (FavoriteDo *)[myList objectAtIndex:row];
    [mainViewCtl openEncryptViewForUpdate:favoriteDo];
    favoriteDo = nil; [favoriteDo release];   // 8.11 airplane mode에서 플레이 지원을 위한 코드	
}

- (IBAction)touchToNext:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSInteger row = btn.tag;
    FavoriteDo *favoriteDo = (FavoriteDo *)[myList objectAtIndex:row];
    [mainViewCtl openEncryptViewForUpdate:favoriteDo];
    favoriteDo = nil; [favoriteDo release];   // 8.11 airplane mode에서 플레이 지원을 위한 코드	
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];

    if (myList == nil){
        return;
    }
    
    FavoriteDo *favoriteDo = (FavoriteDo *)[myList objectAtIndex:row];
    if (![DBUtil deleteFavorite:favoriteDo]) {
        return;
    }
    
    for (int i=1;i<=6;i++){
        NSString *fileName = [NSString stringWithFormat:@"%@%d",favoriteDo.aes1,i];
        if (![SetFileManager removeEncFileOnMyLibEncPath:fileName]){
            NSLog(@"[DEBUG]commitEditingStyle:removeEncFileOnMyLibEncPath Error!!\n");
        }
    }
    
	[myList removeObjectAtIndex:row];
	
	[listView reloadData];
    
    if ( [myList count] < 1) {
        [introLabel setHidden:FALSE];
        [introBtn setHidden:FALSE];
    } else {
        [introLabel setHidden:TRUE];
        [introBtn setHidden:TRUE];
    }
}

#pragma mark -
#pragma mark button handle
- (void)editToListSave {
	if ([myList count] != 0){
		[self.listView setEditing:!self.listView.editing animated:YES];
		if (!listView.editing) {
			
			[actIndicator startAnimating];
			[self.editBtn setEnabled:FALSE];
			[deleteAllBtn setEnabled:FALSE];
			
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(editListSaveTimer1:) userInfo:NULL repeats:NO];
            
			
		}
	} else {
		if(!listView.editing && [myList count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No information to Edit. Please try again after add information " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
            [alert release];
            return;
		}
		
	}
	
}
- (void) editListSaveTimer1:(NSTimer *)_timer{
    if (![DBUtil deleteAllFavorite]) {
        NSLog(@"[DEBUG]editListSaveTimer1 deleteAllFavorite Error\n");
        
    }
    
	for (int i=0;i<[myList count];i++) {
        FavoriteDo *favoriteDo = [myList objectAtIndex:i];
        if (![DBUtil insertFavorite:favoriteDo]) {
            NSLog(@"[DEBUG]editListSaveTimer1 insertFavorite Error\n");   
        }
        favoriteDo = nil; [favoriteDo release];
        
	} // for
	[self.listView reloadData];
	
	[actIndicator stopAnimating];
	
	[self.editBtn setEnabled:TRUE];
	[deleteAllBtn setEnabled:TRUE];
}


- (IBAction)editToList:(id)sender {
	[self editToListSave];
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
	NSBundle *_bundle = [NSBundle mainBundle];
	NSString *imageFileName;
	if (self.listView.editing && [myList count] != 0) {
		
		imageFileName = [_bundle pathForResource:@"btn_done" ofType:@"png"];
	} else {
		
		imageFileName = [_bundle pathForResource:@"btn_edit" ofType:@"png"];
		[self.listView setEditing:FALSE];
	}
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageFileName];
	[editBtn setImage:image forState:0];
	
	_bundle = nil; [_bundle release];
	imageFileName = nil; [imageFileName release];
	[pool release];	
}



- (IBAction)touchToClose:(id)sender {
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(321, 0, 320, 460)];
    [UIView commitAnimations];	
}

-(void) titleBtnEnable {
	[deleteAllBtn setEnabled:TRUE];
	[editBtn	setEnabled:TRUE];
}	

- (IBAction)deleteMyList:(id)sender {
	if([myList count] <= 0) {
		if (!self.listView.editing) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No information to delete." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
            [alert release];
            return;
		}	
	} else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Delete all ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        alert = nil;
        [alert release];
        return;
	}	
	
}


- (void) actIndicatorStop:(NSTimer *) time {
	[actIndicator stopAnimating];
}

#pragma mark -
#pragma mark NSTimer method
- (void) setBtnVisible {
    [listView setFrame:CGRectMake(0, 40, 320, 420)];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(refreshListView) userInfo:nil repeats:NO];
}

- (void) checkRetinaSupport {
	isRetina = FALSE;
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
		isKorean = TRUE;
	}	else {
		isKorean = FALSE;
	}
	tableDic = nil;
	[tableDic release];
	[pool release];	
}	


#pragma mark -
#pragma mark Search Bar Delegate Method
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0)
	{
	}
	else
	{
        if (![DBUtil deleteAllFavorite]){
            NSLog(@"[DEBUG][DBUtil deleteAllFavorite] Error!!\n");
        }
        if (![SetFileManager removeAllEncFileOnMyLibEncPath]){
            NSLog(@"[SetFileManager removeAllEncFileOnMyLibEncPath] Error!!\n");
        }
        [self refreshListView];
        [actIndicator stopAnimating];
	}
    
}
@end