//
//  MyCommonTableViewCell.h
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import <UIKit/UIKit.h>

@interface MyCommonTableViewCell : UITableViewCell {
	UILabel *title;
	UILabel *desc;
    UILabel *regdate;
	UILabel *seq;
    UIButton *nextBtn;
}

@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *desc;
@property (nonatomic, retain) IBOutlet UILabel *regdate;
@property (nonatomic, retain) IBOutlet UILabel *seq;
@property (nonatomic, retain) IBOutlet UIButton *nextBtn;
@end
