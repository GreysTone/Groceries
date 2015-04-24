//
//  Database.h
//  iDatabase
//
//  Created by GreysTone on 4/23/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject {
    @public sqlite3 *dbPtr;
}

@property int LoginId;
@property BOOL STAT_WATCH_OPEN;
@property BOOL STAT_NOTIFICATION_OPEN;

- (int) openDb;

@end