//
//  HomePageViewController.m
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "HomePageViewController.h"

extern Database *gtDatabase;

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Update UI
    NSString *adminName;
    NSString *sql = @"SELECT adminName FROM Admin WHERE id = '";
    sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%d", [gtDatabase LoginId]]];
    sql = [sql stringByAppendingString:@"'"];
    NSLog(@"%@", sql);
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(gtDatabase->dbPtr, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        NSLog(@"[SUCC] Select Data");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            adminName = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            break;          //First Record
        }
    }
    else {
        NSLog(@"[FAIL] Select Error.");
    }
    sqlite3_finalize(statement);
    self.AdminNameLabel.adjustsFontSizeToFitWidth = YES;
    self.AdminNameLabel.text = adminName;
    
}

- (IBAction)LougoutButtonPressed:(id)sender {
    NSLog(@"Logout");
    [self performSegueWithIdentifier:@"LogoutSegue" sender:(self)];
}

@end
