//
//  OutletViewController.h
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"

@interface OutletViewController : UIViewController {
    NSString *CheckOnId;
    BOOL FinishedVerifyId;
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UITextField *CardIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *ISBNTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *FunctionSelector;
@property (weak, nonatomic) IBOutlet UITextView *ResultTextField;

@end
