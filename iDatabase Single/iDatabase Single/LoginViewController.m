//
//  LoginViewController.m
//  iDatabase Single
//
//  Created by GreysTone on 4/23/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "LoginViewController.h"

extern Database *gtDatabase;
extern NSString *Login_aId;

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *AdminInTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *InjectDefence;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    gtDatabase = [[Database alloc] init];
    [gtDatabase openDb];
    gtDatabase.STAT_NOTIFICATION_OPEN = YES;
    gtDatabase.STAT_WATCH_OPEN = YES;    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) LoginButtonPressed:(id)sender {
    //Debug Using
    //[self performSegueWithIdentifier:@"LoginSegue" sender:self];
    //Inquire Password
    NSString *passWord;     //Store Result
    int dbId = 0;
    NSString *sql = @"SELECT id, passWord FROM Admin WHERE aId = '";
    sql = [sql stringByAppendingString:self.AdminInTextField.text];
    sql = [sql stringByAppendingString:@"'"];
    NSLog(@"%@", sql);
    if (self.InjectDefence.on) {
        NSRange rge = [self.AdminInTextField.text rangeOfString:@"or"];
        if (rge.length>0) {
            NSLog(@"[FAIL] Injection Detected");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Bad Id or Password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        rge = [self.AdminInTextField.text rangeOfString:@"and"];
        if (rge.length>0) {
            NSLog(@"[FAIL] Injection Detected");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Bad Id or Password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }

        rge = [self.AdminInTextField.text rangeOfString:@"not"];
        if (rge.length>0) {
            NSLog(@"[FAIL] Injection Detected");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Bad Id or Password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }

        rge = [self.AdminInTextField.text rangeOfString:@"'"];
        if (rge.length>0) {
            NSLog(@"[FAIL] Injection Detected");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Bad Id or Password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }

    }
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(gtDatabase->dbPtr, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        NSLog(@"[SUCC] Select Data");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            dbId = sqlite3_column_int(statement, 0);
            passWord = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            NSLog(@"%d: %@", dbId, passWord);
            break;          //First Record
        }
    }
    else {
        NSLog(@"[FAIL] Select Error.");
    }
    sqlite3_finalize(statement);
    
    //Triger Segue
    if ([self.PasswordTextField.text isEqualToString:passWord]) {
        NSLog(@"[SUCC] Login & Triger <LoginSegue>");
        gtDatabase.LoginId = dbId;
        Login_aId = self.AdminInTextField.text;
        
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
    else {
        NSLog(@"[FAIL] Bad id or password");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Bad Id or Password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
*/

@end
