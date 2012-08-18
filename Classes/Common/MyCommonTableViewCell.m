//
//  MyCommonTableViewCell.m
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import "MyCommonTableViewCell.h"

@implementation MyCommonTableViewCell

@synthesize title;
@synthesize desc;
@synthesize regdate;
@synthesize seq;
@synthesize nextBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// Initialization code
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}

- (void)dealloc {
	[title release];
	[desc release];
	[regdate release];
	[seq release];
    [nextBtn release];
    
	[super dealloc];
}

	
@end
