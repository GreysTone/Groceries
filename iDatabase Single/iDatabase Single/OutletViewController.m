//
//  OutletViewController.m
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "OutletViewController.h"

extern Database *gtDatabase;

@implementation OutletViewController

- (void) viewDidLoad {
    CheckOnId = [[NSString alloc] init];
    FinishedVerifyId = false;
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
}

- (IBAction)AddNewCard:(id)sender {
    [self performSegueWithIdentifier:@"AddNewCardSegue" sender:(self)];
}

- (IBAction)CardIdTextFieldChange:(id)sender {
    FinishedVerifyId = false;
}

- (IBAction)CheckIdButton:(id)sender {

    NSString *sql = @"SELECT * FROM Log WHERE cId = '";
    sql = [sql stringByAppendingString:self.CardIdTextField.text];
    sql = [sql stringByAppendingString:@"'"];
    NSLog(@"%@", sql);
    
    sqlite3_stmt *statement;
    self.ResultTextField.text = @"";
    if (sqlite3_prepare_v2(gtDatabase->dbPtr, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        self.ResultTextField.text = [self.ResultTextField.text stringByAppendingString:@"[SUCC] Select Data"];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int dbId = sqlite3_column_int(statement, 0);
            NSString *cId = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            NSString *ISBN = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            NSString *outDate = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            NSString *inDate = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            NSString *aID = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            NSString *inStr = [[NSString alloc] initWithFormat:@"%d\t|",dbId];
            inStr = [inStr stringByAppendingFormat:@"#%@\t|", cId];
            inStr = [inStr stringByAppendingFormat:@":%@\n\t|", ISBN];
            inStr = [inStr stringByAppendingFormat:@">%@\n\t|", outDate];
            inStr = [inStr stringByAppendingFormat:@"<%@>\n\t|", inDate];
            inStr = [inStr stringByAppendingFormat:@"Admin:%@\n\n", aID];
            self.ResultTextField.text = [self.ResultTextField.text stringByAppendingString:inStr];
        }
        FinishedVerifyId = true;
        CheckOnId = self.CardIdTextField.text;
    }
    else {
        self.ResultTextField.text = [self.ResultTextField.text stringByAppendingString:@"[FAIL] Select Error"];
    }
    sqlite3_finalize(statement);

}

- (IBAction)ExecuteButton:(id)sender {
    if (FinishedVerifyId) {
        if (self.FunctionSelector.selectedSegmentIndex == 0) {  //Out
            //Verify the Bank
            NSString *sql = @"SELECT inBank FROM Book WHERE ISBN = '";
            sql = [sql stringByAppendingString:self.ISBNTextField.text];
            sql = [sql stringByAppendingString:@"'"];
            NSLog(@"%@", sql);
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(gtDatabase->dbPtr, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
                NSLog(@"[SUCC] Checking on Table:Book");
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    int inBankCount = sqlite3_column_int(statement, 0);
                    if (inBankCount > 1) { // Can Out
                        //Update
                        NSString *insert = @"INSERT INTO Log(cId, iSBN, outDate, inDate, aId) VALUES(";
                        //
                        insert = gtDatabase;
                        insert = insert stringByAppendingString:@")";
                        NSLog(@"prepInsert %@", insert);
                        
                        NSString *update = @"UPDATE Book SET inBank = ";
                        update = [update stringByAppendingFormat:@"%d ", inBankCount-1];
                        update = [update stringByAppendingString:@"WHERE ISBN = '"];
                        update = [update stringByAppendingString:self.ISBNTextField.text];
                        update = [update stringByAppendingString:@"'"];
                        NSLog(@"prepUpdate %@", update);
                    }
                    else {   // Nearest Return
                        NSString *back = @"SELECT inDate FROM Log WHERE ISBN = '";
                        back = [back stringByAppendingString:self.ISBNTextField.text];
                        back = [back stringByAppendingString:@"' ORDERBY inDate ASC"];
                        sqlite3_stmt *back_stmt;
                        if (sqlite3_prepare_v2(gtDatabase->dbPtr, [sql UTF8String], -1, &back_stmt, nil) == SQLITE_OK) {
                            NSLog(@"[SUCC] Checking on Recently Return");
                            while (sqlite3_step(back_stmt) == SQLITE_ROW) {
                                self.ResultTextField.text = @"Recently Return:";
                                NSString *inDate = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(back_stmt, 0) encoding:NSUTF8StringEncoding];
                                self.ResultTextField.text = [self.ResultTextField.text stringByAppendingString:inDate];
                                break;
                            }
                        }
                        else {
                            NSLog(@"[FAIL] Checking on Recently Return");
                        }
                        sqlite3_finalize(back_stmt);
                    }
                    break;
                }
            }
            else {
                NSLog(@"[FAIL] Checking on Table:Book")
            }
            sqlite3_finalize(statement);
            

            [self CheckIdButton:self];  //Display
        }
        if (self.FunctionSelector.selectedSegmentIndex == 1) {  //In
            
        }
    }
}


@end
