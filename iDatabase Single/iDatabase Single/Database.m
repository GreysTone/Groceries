//
//  Database.m
//  iDatabase
//
//  Created by GreysTone on 4/23/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "Database.h"

@implementation Database

- (int) openDb {
    //Locate Document DirPath in Sandbox
    NSArray *documentArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentArray objectAtIndex:0];
    NSString *databasePath = [documentPath stringByAppendingPathComponent:@"gtDatabase.sqlite"];
    //NSLog(@"DB Path = %@", databasePath);
    
    //Verify Database
    if(sqlite3_open([databasePath UTF8String], &(dbPtr)) == SQLITE_OK) {
        NSLog(@"[SUCC] Open Database");
        NSString *c1 = @"CREATE TABLE IF NOT EXISTS Book(id integer primary key autoincrement, ISBN varchar(20), bookTitle archer(50), pubPress varchar(50), pubYear integer, bookAuthor varchar(50), bookPrice float, onAmount integer, inBank integer)";
        NSString *c2 = @"CREATE TABLE IF NOT EXISTS Card(id integer primary key autoincrement, cId varchar(20), userName varchar(50), userUnit varchar(50), userCategory integer)";
        NSString *c3 = @"CREATE TABLE IF NOT EXISTS Admin(id integer primary key autoincrement, aId varchar(20), passWord varchar(32), adminName varchar(50),  adminContact varchar(20))";
        NSString *c4 = @"CREATE TABLE IF NOT EXISTS Log(id integer primary key autoincrement, cId varchar(20), outDate varchar(50), inDate varchar(50), aId varchar(20))";
        
        char *errMsg;
        if(sqlite3_exec(dbPtr, [c1 UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) NSLog(@"[SUCC] Verify/Create Table - Book");
        else NSLog(@"[FAIL] %s", errMsg);
        if(sqlite3_exec(dbPtr, [c2 UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) NSLog(@"[SUCC] Verify/Create Table - Card");
        else NSLog(@"[FAIL] %s", errMsg);
        if(sqlite3_exec(dbPtr, [c3 UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) NSLog(@"[SUCC] Verify/Create Table - Admin");
        else NSLog(@"[FAIL] %s", errMsg);
        if(sqlite3_exec(dbPtr, [c4 UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) NSLog(@"[SUCC] Verify/Create Table - Log");
        else NSLog(@"[FAIL] %s", errMsg);
    } else {
        NSLog(@"[FAIL] Database Construction");
    }
    
    /*
    //Prepare for Initial Database
    NSString *i1 = @"INSERT INTO Admin(aId, passWord, adminName, adminContact) VALUES(3130000738, 'db_Admin', 'Arthur Song', 'ars@zju.edu.cn')";
    char *errMsg;
    if(sqlite3_exec(dbPtr, [i1 UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) NSLog(@"[SUCC] Insert Initial Admin Data");
    else NSLog(@"[FAIL] %s", errMsg);
    */
    
    return 1;
}

@end

Database *gtDatabase;