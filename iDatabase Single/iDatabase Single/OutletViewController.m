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

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
}

- (IBAction)AddNewCard:(id)sender {
    [self performSegueWithIdentifier:@"AddNewCardSegue" sender:(self)];
}

@end
