//
//  NewBooksViewController.m
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "NewBooksViewController.h"

extern Database *gtDatabase;

@implementation NewBooksViewController

- (IBAction)AddNewBook:(id)sender {
    NSString *insert = @"INSERT INTO Book(ISBN, bookCate, bookTitle, pubPress, pubYear, bookAuthor, bookPrice, onAmount, inBank) VALUES('";
    insert = [insert stringByAppendingString:self.ISBNTextField.text];
    insert = [insert stringByAppendingString:@"','"];
    insert = [insert stringByAppendingString:self.CategoryTextField.text];
    insert = [insert stringByAppendingString:@"','"];
    insert = [insert stringByAppendingString:self.NameTextField.text];
    insert = [insert stringByAppendingString:@"','"];
    insert = [insert stringByAppendingString:self.PressTextField.text];
    insert = [insert stringByAppendingString:@"','"];
    insert = [insert stringByAppendingString:self.YearTextField.text];
    insert = [insert stringByAppendingString:@"','"];
    insert = [insert stringByAppendingString:self.AuthorTextField.text];
    insert = [insert stringByAppendingString:@"',"];
    insert = [insert stringByAppendingFormat:@"%f",[self.PriceTextField.text floatValue]];
    insert = [insert stringByAppendingString:@",'"];
    insert = [insert stringByAppendingString:self.AmountTextField.text];
    insert = [insert stringByAppendingString:@"','"];
    insert = [insert stringByAppendingString:self.AmountTextField.text];
    insert = [insert stringByAppendingString:@"')"];
    NSLog(@"%@", insert);
    
    char *errMsg;
    if(sqlite3_exec(gtDatabase->dbPtr, [insert UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"[SUCC] Insert One Book");
        self.InsertSTAT.text = @"SUCCESS";
    }
    else {
        NSLog(@"[FAIL] %s", errMsg);
        self.InsertSTAT.text = [NSString stringWithUTF8String:errMsg];
    }

//    Book(id integer primary key autoincrement, ISBN varchar(20), bookCate varchar(20), bookTitle varchar(50), pubPress varchar(50), pubYear integer, bookAuthor varchar(50), bookPrice float, onAmount integer, inBank integer)"
    
}

- (IBAction)ShowAllBook:(id)sender {
    [self performSegueWithIdentifier:@"ShowAllBookSegue" sender:(self)];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
}

@end
