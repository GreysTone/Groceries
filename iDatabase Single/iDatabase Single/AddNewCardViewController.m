//
//  AddNewCardViewController.m
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "AddNewCardViewController.h"

extern Database *gtDatabase;

@implementation AddNewCardViewController

- (IBAction)SaveNewCard:(id)sender {
    NSLog(@"[SYS]Save Pressed.");
    
    //cId varchar(20), userName varchar(50), userUnit varchar(50), userCategory integer)
    
    NSString *i1 = @"INSERT INTO Card(cId, userName, userUnit, userCategory) VALUES('";
    i1 = [i1 stringByAppendingString:self.CardIdTextField.text];
    i1 = [i1 stringByAppendingString:@"', '"];
    i1 = [i1 stringByAppendingString:self.UserNameTextField.text];
    i1 = [i1 stringByAppendingString:@"', '"];
    i1 = [i1 stringByAppendingString:self.CardUnitTextField.text];
    i1 = [i1 stringByAppendingString:@"', '"];
    i1 = [i1 stringByAppendingFormat:@"%ld", (long)self.CardCategoryTextField.selectedSegmentIndex];
    i1 = [i1 stringByAppendingString:@"')"];
    NSLog(@"%@", i1);
    
    char *errMsg;
    if(sqlite3_exec(gtDatabase->dbPtr, [i1 UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"[SUCC] Insert Card Data");
        
        if([gtDatabase STAT_NOTIFICATION_OPEN]) {
            //[NSNavBarNotificationView notifyWithText:@"Grumpy wizards" andDetail:@"make a toxic brew"];
            NSLog(@"STAT");
            UILocalNotification * notice = [[UILocalNotification alloc] init];
            [notice setAlertBody:@"Add New Card"];
            [notice setFireDate:[NSDate date]];
            
            if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
                [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
            }
            [[UIApplication sharedApplication] scheduleLocalNotification:notice];
            
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Insert" message:@"Insert Successed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Insert" message:@"Insert Failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"[FAIL] %s", errMsg);
    }
    
    [self performSegueWithIdentifier:@"UnWind" sender:(self)];
}

@end
