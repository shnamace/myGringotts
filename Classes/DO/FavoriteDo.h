//
//  FavoriteDo.h
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import <Foundation/Foundation.h>

@interface FavoriteDo : NSObject <NSMutableCopying> {
	NSInteger idx;
	NSString *title;
	NSString *desc;
	NSString *aes1;
	NSString *aes2;
	NSString *aes3;	
	NSString *aes4;	
	NSString *aes5;
	NSString *aes6;
	NSString *regdate;
	NSString *reminder;
    NSString *hint;
}

@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *aes1;
@property (nonatomic, retain) NSString *aes2;
@property (nonatomic, retain) NSString *aes3;
@property (nonatomic, retain) NSString *aes4;
@property (nonatomic, retain) NSString *aes5;
@property (nonatomic, retain) NSString *aes6;
@property (nonatomic, retain) NSString *regdate;
@property (nonatomic, retain) NSString *reminder;
@property (nonatomic, retain) NSString *hint;

+ (id)getFavoriteDo;

@end
