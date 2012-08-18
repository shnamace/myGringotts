//
//  FavoriteDo.m
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import "FavoriteDo.h"

@implementation FavoriteDo

@synthesize idx;
@synthesize title;
@synthesize desc;
@synthesize aes1;
@synthesize aes2;
@synthesize aes3;
@synthesize aes4;
@synthesize aes5;
@synthesize aes6;
@synthesize regdate;
@synthesize reminder;
@synthesize hint;
+ (id)getFavoriteDo {
	FavoriteDo *favoriteDo = [[[FavoriteDo alloc] init] autorelease];
	return favoriteDo;
}

- (void) dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark NSMutableCopying

- (id) mutableCopyWithZone:(NSZone *)zone {
	FavoriteDo *favoriteDo = [FavoriteDo getFavoriteDo];
	favoriteDo.idx = idx;
	favoriteDo.title = [NSString stringWithString:title];
	favoriteDo.desc = [NSString stringWithString:desc];
	favoriteDo.aes1 = [NSString stringWithString:aes1];
	favoriteDo.aes2 = [NSString stringWithString:aes2];
	favoriteDo.aes3 = [NSString stringWithString:aes3];
	favoriteDo.aes4 = [NSString stringWithString:aes4];
	favoriteDo.aes5 = [NSString stringWithString:aes5];
	favoriteDo.aes6 = [NSString stringWithString:aes6];
	favoriteDo.regdate = [NSString stringWithString:regdate];
	favoriteDo.reminder = [NSString stringWithString:reminder];
	favoriteDo.hint = [NSString stringWithString:hint];
    
	
	[favoriteDo retain];
	return favoriteDo;
}

@end