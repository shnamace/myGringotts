//
//  DBUtil.m
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import "Header.h"
#import "DBUtil.h"
#import "SetFileManager.h"

@implementation DBUtil
+ (BOOL)createFavoriteTable {
    BOOL result = TRUE;
    
    sqlite3 *myDB = [self myDBOpen];
    
    NSString *query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %s (idx INTEGER NOT NULL PRIMARY KEY, title TEXT NOT NULL, desc TEXT, aes1 TEXT, aes2 TEXT, aes3 TEXT, aes4 TEXT, aes5 TEXT, aes6 TEXT, regdate TEXT, reminder TEXT, hint TEXT)", TBL_FAVORITE];
    char *errorMsg;
    if (sqlite3_exec(myDB, [query UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"[DEBUG] Create %s Table Fail : %s", TBL_FAVORITE, errorMsg);
        result = FALSE;
    }
    
    query = [NSString stringWithFormat:@"CREATE INDEX IDX_TBL_MY_FAVORITE ON %s (idx)", TBL_FAVORITE];
    if (sqlite3_exec(myDB, [query UTF8String], NULL, NULL, nil) != SQLITE_OK) {
        NSLog(@"[DEBUG] createFavoriteTable, create index fail!!\n");
        //NSLog(@"%@\n",query);
        result = FALSE;
    }
    
    sqlite3_close(myDB);
    myDB = nil;
    
    return result;
}
+ (NSMutableArray *)getFavoriteList{
	sqlite3 *myDB = [self myDBOpen];
	sqlite3_stmt *stmt = nil;
    
    NSMutableArray *favoriteList = [[[NSMutableArray alloc] init] autorelease];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %s ORDER BY idx, title ASC", TBL_FAVORITE];
    
    if (sqlite3_prepare_v2(myDB, [query UTF8String], -1,&stmt, NULL) != SQLITE_OK) {
        NSLog(@"[DEBUG]getFavoriteList SELECT Error...\n");
        favoriteList = nil;
        goto RELEASEPOINT;
    }
    
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];			
        int idx = sqlite3_column_int(stmt, 0);
        char *title = (char *)sqlite3_column_text(stmt, 1);
        char *desc = (char *)sqlite3_column_text(stmt, 2);
        char *aes1 = (char *)sqlite3_column_text(stmt, 3);
        char *aes2 = (char *)sqlite3_column_text(stmt, 4);
        char *aes3 = (char *)sqlite3_column_text(stmt, 5);
        char *aes4 = (char *)sqlite3_column_text(stmt, 6);
        char *aes5 = (char *)sqlite3_column_text(stmt, 7);
        char *aes6 = (char *)sqlite3_column_text(stmt, 8);
        char *regdate = (char *)sqlite3_column_text(stmt, 9);
        char *reminder = (char *)sqlite3_column_text(stmt, 10);
        char *hint = (char *)sqlite3_column_text(stmt, 11);
        
        FavoriteDo *favoriteDo = [[FavoriteDo alloc] init];
        [favoriteDo setIdx:idx];
        [favoriteDo setTitle:[NSString stringWithUTF8String:title]];
        [favoriteDo setDesc:[NSString stringWithUTF8String:desc]];
        [favoriteDo setAes1:[NSString stringWithUTF8String:aes1]];
        [favoriteDo setAes2:[NSString stringWithUTF8String:aes2]];
        [favoriteDo setAes3:[NSString stringWithUTF8String:aes3]];
        [favoriteDo setAes4:[NSString stringWithUTF8String:aes4]];
        [favoriteDo setAes5:[NSString stringWithUTF8String:aes5]];
        [favoriteDo setAes6:[NSString stringWithUTF8String:aes6]];
        [favoriteDo setRegdate:[NSString stringWithUTF8String:regdate]];
        [favoriteDo setReminder:[NSString stringWithUTF8String:reminder]];
        [favoriteDo setHint:[NSString stringWithUTF8String:hint]];
        
       // NSLog(@"getFavoriteList:idx:%d\n",idx);
        
        [favoriteList addObject:favoriteDo];
        favoriteDo = nil; [favoriteDo release];
        [pool release];			
    }
RELEASEPOINT:    
    query = nil; [query release];
    sqlite3_finalize(stmt);
    stmt = nil;
    sqlite3_close(myDB);
    myDB = nil;
    
    return favoriteList;
}

+ (BOOL)updateFavorite:(FavoriteDo *)favoriteDo{
    BOOL result = TRUE;
	sqlite3 *myDB = [self myDBOpen];
	//sqlite3_stmt *stmt = nil;

    //NSLog(@"updateFavorite:%d,%@,%@,%@\n",favoriteDo.idx,favoriteDo.title,favoriteDo.desc,favoriteDo.aes1);
    
    NSString *query = [NSString stringWithFormat:@"UPDATE %s SET title = '%@', desc = '%@', aes1 = '%@', aes2 = '%@', aes3 = '%@', aes4 = '%@', aes5 = '%@', aes6 = '%@', regdate = '%@', reminder = '%@', hint = '%@' WHERE idx = %d", TBL_FAVORITE, favoriteDo.title, favoriteDo.desc, favoriteDo.aes1,favoriteDo.aes2,favoriteDo.aes3,favoriteDo.aes4,favoriteDo.aes5,favoriteDo.aes6,favoriteDo.regdate,favoriteDo.reminder,favoriteDo.hint,favoriteDo.idx ];
    
    if (sqlite3_exec(myDB, [query UTF8String], NULL, NULL, nil) != SQLITE_OK) {
        NSLog(@"[DEBUG] updateFavorite, fail!!\n");
        //NSLog(@"%@\n",query);
        result = FALSE;
    }
    
    sqlite3_close(myDB);
    myDB = nil;
    
    return result;
}
+ (BOOL)deleteFavorite:(FavoriteDo *)favoriteDo{
    BOOL result = TRUE;
	sqlite3 *myDB = [self myDBOpen];
	sqlite3_stmt *stmt = nil;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
    
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %s WHERE idx = %d", TBL_FAVORITE, favoriteDo.idx ];
    if (sqlite3_prepare_v2(myDB, [query UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
        NSLog(@"[DEBUG] deleteFavorite Delete Fail!!\n");
        //NSLog(@"%@\n",query);
        result = FALSE;
        goto RELEASEPOINT;
    }
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        //NSLog(@"[DEBUG] [MyViewController] Delete Fail");
    }
    
RELEASEPOINT:
    sqlite3_finalize(stmt);
    stmt = nil;
    sqlite3_close(myDB);
    myDB = nil;
    [pool release];
    return result;
}

+ (BOOL)insertFavorite: (FavoriteDo *)favoriteDo{
    BOOL result = TRUE;
	sqlite3 *myDB = [self myDBOpen];
	sqlite3_stmt *stmt = nil;
    
	NSInteger rowCount = 0;
	NSString *query = [NSString stringWithFormat:@"SELECT max(idx) FROM %s", TBL_FAVORITE];
	if (sqlite3_prepare_v2(myDB, [query UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
		NSLog(@"[DEBUG] addMyYouTubeVideo Query Fail : %@", query);
        result = FALSE;
        goto RELEASEPOINT;
	}
    
	if (sqlite3_step(stmt) == SQLITE_ROW) {
		rowCount = sqlite3_column_int(stmt, 0);
	} else {
        rowCount = 0;
    }
    sqlite3_finalize(stmt);
    stmt = nil;
	sqlite3_reset(stmt);
    
    query = [NSString stringWithFormat:@"INSERT INTO %s VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", TBL_FAVORITE];
    
    if (sqlite3_prepare_v2(myDB, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, rowCount+1);
        sqlite3_bind_text(stmt, 2, [favoriteDo.title UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [favoriteDo.desc UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [favoriteDo.aes1 UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [favoriteDo.aes2 UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 6, [favoriteDo.aes3 UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [favoriteDo.aes4 UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [favoriteDo.aes5 UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 9, [favoriteDo.aes6 UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 10, [favoriteDo.regdate UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 11, [favoriteDo.reminder UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 12, [favoriteDo.hint UTF8String], -1, NULL);
    }
    
    //NSLog(@"insertFavorite:rowCount:%d\n",rowCount);
    
	if (sqlite3_step(stmt) != SQLITE_DONE) {
        NSLog(@"[DEBUG]insertFavorite Insert Into Error!!\n");
        result = FALSE;
	}
RELEASEPOINT:
	sqlite3_finalize(stmt);
	stmt = nil;
	sqlite3_close(myDB);
	myDB = nil;
    query = nil; [query release];
    
	return TRUE;
    
}

+ (BOOL)deleteAllFavorite{
    BOOL result = TRUE;
	sqlite3 *myDB = [self myDBOpen];
	sqlite3_stmt *stmt = nil;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
    
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %s", TBL_FAVORITE];
    
    if (sqlite3_prepare_v2(myDB, [query UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
        NSLog(@"[DEBUG] deleteAllFavorite Delete Fail!!\n");
        result = FALSE;
        goto RELEASEPOINT;
    }
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        //NSLog(@"[DEBUG] [MyViewController] Delete Fail");
    }
    
RELEASEPOINT:
    sqlite3_finalize(stmt);
    stmt = nil;
    sqlite3_close(myDB);
    myDB = nil;
    [pool release];
    return result;
}

+ (sqlite3 *) myDBOpen {
	sqlite3 *DB;
	
	NSString *dataFilePath = [[NSString alloc] initWithFormat:@"%@/%s", [SetFileManager getMyDBPath ],DATABASE_FILE_NAME];

	if (sqlite3_open([dataFilePath UTF8String], &DB) != SQLITE_OK) {
		sqlite3_close(DB);
		NSLog(@"[DEBUG]myDBOpen open error! ");
		return nil;
	}
	
	dataFilePath = nil; [dataFilePath release];
	
	return DB;
}
+ (NSString *)getFilePrefix{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp =
    [gregorian components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:today];
    
    NSString *formatDate = [NSString stringWithFormat:@"%d%02d%02d%02d%02d%02d", comp.year, comp.month, comp.day, comp.hour, comp.minute, comp.second];
//    NSString *formatDate = [NSString stringWithFormat:@"%d.%02d.%02d %02d:%02d:%02d", comp.year, comp.month, comp.day, comp.hour, comp.minute, comp.second];
    return  formatDate;
    
}
+ (NSString *)getCurrentDate{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp =
    [gregorian components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:today];
        
    NSString *formatDate = [NSString stringWithFormat:@"%d.%02d.%02d %02d:%02d:%02d", comp.year, comp.month, comp.day, comp.hour, comp.minute, comp.second];
    return  formatDate;
    
}
@end
