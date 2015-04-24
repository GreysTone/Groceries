//
//  AddNewCardViewController.m
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "AddNewCardViewController.h"

@implementation AddNewCardViewController

- (IBAction)SaveNewCard:(id)sender {
    NSLog(@"[SYS]Save Pressed.");
    [self performSegueWithIdentifier:@"UnWind" sender:(self)];
}

@end
