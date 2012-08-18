//
//  DBUtil.h
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"
#import "FavoriteDo.h"
#import "Header.h"

@interface DBUtil : NSObject {

}
+ (BOOL)createFavoriteTable;
+ (NSMutableArray *)getFavoriteList;
+ (BOOL)updateFavorite:(FavoriteDo *)favoriteDo;
+ (BOOL)deleteFavorite:(FavoriteDo *)favoriteDo;
+ (BOOL)insertFavorite: (FavoriteDo *)favoriteDo;
+ (BOOL)deleteAllFavorite;

+ (sqlite3 *) myDBOpen;
+ (NSString *)getCurrentDate;
+ (NSString *)getFilePrefix;
@end
