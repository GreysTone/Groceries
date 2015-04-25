//
//  QueryViewController.m
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "QueryViewController.h"

extern Database *gtDatabase;

@implementation QueryViewController

- (IBAction)Query:(id)sender {
    
    NSString *FirstQueryContent = self.SingleQueryTextField.text;
    BOOL FirstEmpty = [self.SingleQueryTextField.text isEqualToString:@""];
    NSString *SecondQueryBeginContent = self.RangeQueryBeginTextField.text;
    BOOL SecondBeginEmpty = [self.RangeQueryBeginTextField.text isEqualToString:@""];
    NSString *SecondQueryEndContent = self.RangeQueryEndTextField.text;
    BOOL SecondEndEmpty = [self.RangeQueryEndTextField.text isEqualToString:@""];
    
    //Inquire Result
    NSString *sql;
    
    if(FirstEmpty && SecondBeginEmpty && SecondEndEmpty) {
        sql = @"SELECT * FROM Book";
    }
    if(FirstEmpty && SecondBeginEmpty && !SecondEndEmpty) {
        if (self.QuerySettingRange.selectedSegmentIndex == 0) {
            sql = @"SELECT * FROM Book WHERE (pubYear < ";
            sql = [sql stringByAppendingString:SecondQueryEndContent];
            sql = [sql stringByAppendingString:@")"];
        }
        
        if (self.QuerySettingRange.selectedSegmentIndex == 1) {
            sql = @"SELECT * FROM Book WHERE ( bookPrice < ";
            sql = [sql stringByAppendingString:SecondQueryEndContent];
            sql = [sql stringByAppendingString:@")"];
        }
    }
    if(FirstEmpty && !SecondBeginEmpty && SecondEndEmpty) {
        if (self.QuerySettingRange.selectedSegmentIndex == 0) {
            sql = @"SELECT * FROM Book WHERE (pubYear > ";
            sql = [sql stringByAppendingString:SecondQueryBeginContent];
            sql = [sql stringByAppendingString:@")"];
        }
        
        if (self.QuerySettingRange.selectedSegmentIndex == 1) {
            sql = @"SELECT * FROM Book WHERE ( bookPrice > ";
            sql = [sql stringByAppendingString:SecondQueryBeginContent];
            sql = [sql stringByAppendingString:@")"];
        }
    }
    if(FirstEmpty && !SecondBeginEmpty && !SecondEndEmpty) {
        if (self.QuerySettingRange.selectedSegmentIndex == 0) {
            sql = @"SELECT * FROM Book WHERE (pubYear > ";
            sql = [sql stringByAppendingString:SecondQueryBeginContent];
            sql = [sql stringByAppendingString:@" and pubYear < "];
            sql = [sql stringByAppendingString:SecondQueryEndContent];
            sql = [sql stringByAppendingString:@")"];
        }
        
        if (self.QuerySettingRange.selectedSegmentIndex == 1) {
            sql = @"SELECT * FROM Book WHERE (bookPrice > ";
            sql = [sql stringByAppendingString:SecondQueryBeginContent];
            sql = [sql stringByAppendingString:@" and bookPrice < "];
            sql = [sql stringByAppendingString:SecondQueryEndContent];
            sql = [sql stringByAppendingString:@")"];
        }
    }
    if(!FirstEmpty && SecondBeginEmpty && SecondEndEmpty) {
        sql = @"SELECT * FROM Book WHERE (";
        
        if (self.QuerySettingSingle.selectedSegmentIndex == 0) {sql = [sql stringByAppendingString:@"bookAuthor = '"];}
        if (self.QuerySettingSingle.selectedSegmentIndex == 1) {sql = [sql stringByAppendingString:@"bookCate = '"];}
        if (self.QuerySettingSingle.selectedSegmentIndex == 2) {sql = [sql stringByAppendingString:@"bookTitle = '"];}
        if (self.QuerySettingSingle.selectedSegmentIndex == 3) {sql = [sql stringByAppendingString:@"pubPress = '"];}
        sql = [sql stringByAppendingString:FirstQueryContent];
        sql = [sql stringByAppendingString:@"')"];
    }
    if(!FirstEmpty && SecondBeginEmpty && !SecondEndEmpty) {
        sql = @"SELECT * FROM Book WHERE (";
        if (self.QuerySettingSingle.selectedSegmentIndex == 0) {sql = [sql stringByAppendingString:@"bookAuthor = '"];}
        if (self.QuerySettingSingle.selectedSegmentIndex == 1) {sql = [sql stringByAppendingString:@"bookCate = '"];}
        if (self.QuerySettingSingle.selectedSegmentIndex == 2) {sql = [sql stringByAppendingString:@"bookTitle = '"];}
        if (self.QuerySettingSingle.selectedSegmentIndex == 3) {sql = [sql stringByAppendingString:@"pubPress = '"];}
        sql = [sql stringByAppendingString:FirstQueryContent];
        sql = [sql stringByAppendingString:@"' and "];
        if (self.QuerySettingRange.selectedSegmentIndex == 0) {sql = [sql stringByAppendingString:@"pubYear < "];}
        if (self.QuerySettingRange.selectedSegmentIndex == 1) {sql = [sql stringByAppendingString:@"bookPrice < "];}
        sql = [sql stringByAppendingString:SecondQueryEndContent];
        sql = [sql stringByAppendingString:@")"];
    }
    if(!FirstEmpty && !SecondBeginEmpty && SecondEndEmpty) {
        sql = @"SELECT * FROM Book WHERE (";
        if (self.QuerySettingSingle.selectedSegmentIndex == 0) {sql = [sql stringByAppendingString:@"bookAuthor = '"];}
        if (self.QuerySettingSingle.selectedSegmentIndex == 1) {sql = [sql stringByAppendingString:@"bookCate = '"];}
        if (self.QuerySettingSingle.selectedSegmentIndex == 2) {sql = [sql stringByAppendingString:@"bookTitle = '"];}
        if (self.QuerySettingSingle.selectedSegmentIndex == 3) {sql = [sql stringByAppendingString:@"pubPress = '"];}
        sql = [sql stringByAppendingString:FirstQueryContent];
        sql = [sql stringByAppendingString:@"' and "];
        if (self.QuerySettingRange.selectedSegmentIndex == 0) {sql = [sql stringByAppendingString:@"pubYear > "];}
        if (self.QuerySettingRange.selectedSegmentIndex == 1) {sql = [sql stringByAppendingString:@"bookPrice > "];}
        sql = [sql stringByAppendingString:SecondQueryBeginContent];
        sql = [sql stringByAppendingString:@")"];

    }
    if(!FirstEmpty && !SecondBeginEmpty && !SecondEndEmpty) {
        sql = @"SELECT * FROM Book WHERE (";
        if (self.QuerySettingSingle.selectedSegmentIndex == 0) {sql = [sql stringByAppendingString:@"bookAuthor = '"];}
        if (self.QuerySettingSingle.selectedSegmentIndex == 1) {sql = [sql stringByAppendingString:@"bookCate = '"];}
        if (self.QuerySettingSingle.selectedSegmentIndex == 2) {sql = [sql stringByAppendingString:@"bookTitle = '"];}
        if (self.QuerySettingSingle.selectedSegmentIndex == 3) {sql = [sql stringByAppendingString:@"pubPress = '"];}
        sql = [sql stringByAppendingString:FirstQueryContent];
        sql = [sql stringByAppendingString:@"' and "];
        if (self.QuerySettingRange.selectedSegmentIndex == 0) {sql = [sql stringByAppendingString:@"pubYear > "];}
        if (self.QuerySettingRange.selectedSegmentIndex == 1) {sql = [sql stringByAppendingString:@"bookPrice > "];}
        sql = [sql stringByAppendingString:SecondQueryBeginContent];
        sql = [sql stringByAppendingString:@" and "];
        if (self.QuerySettingRange.selectedSegmentIndex == 0) {sql = [sql stringByAppendingString:@"pubYear < "];}
        if (self.QuerySettingRange.selectedSegmentIndex == 1) {sql = [sql stringByAppendingString:@"bookPrice < "];}
        sql = [sql stringByAppendingString:SecondQueryEndContent];
        sql = [sql stringByAppendingString:@")"];
    }
    
    NSLog(@"%@", sql);
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(gtDatabase->dbPtr, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        self.QueryResultMultiTextField.text = @"";
        self.QueryResultMultiTextField.text = [self.QueryResultMultiTextField.text stringByAppendingString:@"[SUCC] Select Data\n\n"];
        NSLog(@"[SUCC] Select Data");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int dbId = sqlite3_column_int(statement, 0);
            NSString *isbn = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            NSString *bookCate = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            NSString *bookTitle = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            NSString *press = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            int pubYear = sqlite3_column_int(statement, 5);
            NSString *author = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            NSString *priceStr = [[NSString alloc] initWithFormat:@"%s", sqlite3_column_text(statement, 7)];
            float price = [priceStr floatValue];
            int onAmount = sqlite3_column_int(statement, 8);
            int inBank = sqlite3_column_int(statement, 9);
            NSString *inStr = [[NSString alloc] initWithFormat:@"%d\t|",dbId];
            inStr = [inStr stringByAppendingFormat:@">%@\t|", isbn];
            inStr = [inStr stringByAppendingFormat:@"#%@\n\t|", bookCate];
            inStr = [inStr stringByAppendingFormat:@"<%@>\n\t|", bookTitle];
            inStr = [inStr stringByAppendingFormat:@"+%@\n\t|", press];
            inStr = [inStr stringByAppendingFormat:@"+%d\n\t|", pubYear];
            inStr = [inStr stringByAppendingFormat:@"Au:%@\n\t|", author];
            inStr = [inStr stringByAppendingFormat:@"Price:%.2f\n\t|", price];
            inStr = [inStr stringByAppendingFormat:@"All:%d\n\t|", onAmount];
            inStr = [inStr stringByAppendingFormat:@"Bank:%d\n\n", inBank];
            self.QueryResultMultiTextField.text = [self.QueryResultMultiTextField.text stringByAppendingString:inStr];
        }
    }
    else {
        self.QueryResultMultiTextField.text = [self.QueryResultMultiTextField.text stringByAppendingString:@"[FAIL] Select Error\n"];
        NSLog(@"[FAIL] Select Error");
    }
    sqlite3_finalize(statement);

    
}

@end
