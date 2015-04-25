//
//  OutletViewController.m
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "OutletViewController.h"

extern Database *gtDatabase;
extern NSString *Login_aId;

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
        self.ResultTextField.text = [self.ResultTextField.text stringByAppendingString:@"[SUCC] Select Data\n\n"];
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
            inStr = [inStr stringByAppendingFormat:@">>%@\n\t|", outDate];
            inStr = [inStr stringByAppendingFormat:@"<<%@\n\t|", inDate];
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
                    if (inBankCount >= 1) { // Can Out
                        //Update
                        NSString *insert = @"INSERT INTO Log(cId, ISBN, outDate, inDate, aId) VALUES('";
                        insert = [insert stringByAppendingString:self.CardIdTextField.text];
                        insert = [insert stringByAppendingString:@"','"];
                        insert = [insert stringByAppendingString:self.ISBNTextField.text];
                        insert = [insert stringByAppendingString:@"','"];
                        //Generate with current Date
                        NSDate *dat=[NSDate date];
                        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSUInteger unitFlags=NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
                        NSDateComponents * dateComp= [cal components:unitFlags fromDate:dat];
                        NSLog(@"%ld%ld%ld", (long)[dateComp year], (long)[dateComp month], (long)[dateComp day]);
                        NSString *outDate = @"";
                        outDate = [outDate stringByAppendingFormat:@"%04ld", (long)[dateComp year]];
                        outDate = [outDate stringByAppendingFormat:@"%02ld", (long)[dateComp month]];
                        outDate = [outDate stringByAppendingFormat:@"%02ld", (long)[dateComp day]];
                        NSString *inDate = outDate;
                        insert = [insert stringByAppendingString:outDate];
                        insert = [insert stringByAppendingString:@"','"];
                        insert = [insert stringByAppendingString:inDate];
                        insert = [insert stringByAppendingString:@"','"];
                        insert = [insert stringByAppendingString:Login_aId];
                        insert = [insert stringByAppendingString:@"')"];
                        NSLog(@"prepInsert %@", insert);
                        
                        NSString *update = @"UPDATE Book SET inBank = ";
                        update = [update stringByAppendingFormat:@"%d ", inBankCount-1];
                        update = [update stringByAppendingString:@"WHERE ISBN = '"];
                        update = [update stringByAppendingString:self.ISBNTextField.text];
                        update = [update stringByAppendingString:@"'"];
                        NSLog(@"prepUpdate %@", update);
                        
                        char *errMsg;
                        if(sqlite3_exec(gtDatabase->dbPtr, [insert UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
                            NSLog(@"[SUCC] Insert INTO Log");
                        }
                        else {
                            NSLog(@"[FAIL] Insert INTO Log");
                            NSLog(@"%s", errMsg);
                        }
                        if(sqlite3_exec(gtDatabase->dbPtr, [update UTF8String], NULL, NULL, &errMsg) == SQLITE_OK)  {
                            NSLog(@"[SUCC] Update INTO Book");
                        }
                        else {
                            NSLog(@"[FAIL] Update INTO Book");
                            NSLog(@"%s", errMsg);
                        }
                    }
                    else {   // Nearest Return
                        NSString *back = @"SELECT inDate FROM Log WHERE ISBN = '";
                        back = [back stringByAppendingString:self.ISBNTextField.text];
                        back = [back stringByAppendingString:@"' ORDER BY inDate ASC"];
                        NSLog(@"%@", back);
                        sqlite3_stmt *back_stmt;
                        if (sqlite3_prepare_v2(gtDatabase->dbPtr, [back UTF8String], -1, &back_stmt, nil) == SQLITE_OK) {
                            NSLog(@"[SUCC] Checking on Recently Return");
                            while (sqlite3_step(back_stmt) == SQLITE_ROW) {
                                self.ResultTextField.text = @"Recently Return:";
                                NSString *inDate = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(back_stmt, 0) encoding:NSUTF8StringEncoding];
                                self.ResultTextField.text = [self.ResultTextField.text stringByAppendingString:inDate];
                                NSString *alertMSG = @"The bank is empty, and nearest return is on ";
                                alertMSG = [alertMSG stringByAppendingString:inDate];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not available" message:alertMSG delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                                [alert show];
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
                NSLog(@"[FAIL] Checking on Table:Book");
            }
            sqlite3_finalize(statement);
            

            [self CheckIdButton:self];  //ReDisplay
        }
        if (self.FunctionSelector.selectedSegmentIndex == 1) {  //In
            //Verify the Log
            NSString *sql = @"SELECT id FROM Log WHERE ISBN = '";
            sql = [sql stringByAppendingString:self.ISBNTextField.text];
            sql = [sql stringByAppendingString:@"' and cId = '"];
            sql = [sql stringByAppendingString:self.CardIdTextField.text];
            sql = [sql stringByAppendingString:@"'"];
            NSLog(@"%@", sql);
            sqlite3_stmt *statement;
            
            bool STAT_IN_UPDATE_PROCESS = false;
            
            if (sqlite3_prepare_v2(gtDatabase->dbPtr, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
                NSLog(@"[SUCC] Checking on Table:Log[RET]");
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    int listId = sqlite3_column_int(statement, 0);
                    STAT_IN_UPDATE_PROCESS = true;
                    NSString *delete = @"DELETE FROM Log WHERE id = ";
                    delete = [delete stringByAppendingFormat:@"%d",listId];
                    
                    //Get inBankCount
                    int inBankCount = 1;
                    NSString *inBanksql = @"SELECT id, inBank FROM Book WHERE ISBN = '";
                    inBanksql = [inBanksql stringByAppendingString:self.ISBNTextField.text];
                    inBanksql = [inBanksql stringByAppendingString:@"'"];
                    NSLog(@"%@", inBanksql);
                    sqlite3_stmt *inBank_stmt;
                    
                    if (sqlite3_prepare_v2(gtDatabase->dbPtr, [inBanksql UTF8String], -1, &inBank_stmt, nil) == SQLITE_OK) {
                        NSLog(@"[SUCC] Searching inBankCount on Table:Book");
                        while (sqlite3_step(inBank_stmt) == SQLITE_ROW) {
                            inBankCount = sqlite3_column_int(statement, 1);
                            NSLog(@"[RET READ]%d", inBankCount);
                            break;
                        }
                    }else {
                        NSLog(@"[FAIL] Searching inBankCount on Table:Book");
                    }
                    sqlite3_finalize(inBank_stmt);
                    
                    NSString *update = @"UPDATE Book SET inBank = ";
                    update = [update stringByAppendingFormat:@"%d ", inBankCount+1];
                    update = [update stringByAppendingString:@"WHERE ISBN = '"];
                    update = [update stringByAppendingString:self.ISBNTextField.text];
                    update = [update stringByAppendingString:@"'"];
                    NSLog(@"prepUpdate %@", update);
                    
                    char *errMsg;
                    if(sqlite3_exec(gtDatabase->dbPtr, [delete UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
                        NSLog(@"[SUCC] Delete From Log");
                    }
                    else {
                        NSLog(@"[FAIL] Delete From Log");
                        NSLog(@"%s", errMsg);
                    }
                    if(sqlite3_exec(gtDatabase->dbPtr, [update UTF8String], NULL, NULL, &errMsg) == SQLITE_OK)  {
                        NSLog(@"[SUCC] Update INTO Book");
                    }
                    else {
                        NSLog(@"[FAIL] Update INTO Book");
                        NSLog(@"%s", errMsg);
                    }
                    break;
                }
                if (!STAT_IN_UPDATE_PROCESS) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not available" message:@"No such ISBN" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];

                }
            }
            else {
                NSLog(@"[FAIL] Checking on Table:Log[RET]");
            }
            sqlite3_finalize(statement);
            
            
            [self CheckIdButton:self];  //ReDisplay
        }
    }
}


@end
