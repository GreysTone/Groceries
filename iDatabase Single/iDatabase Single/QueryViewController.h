//
//  QueryViewController.h
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"

@interface QueryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *QuerySettingSingle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *QuerySettingRange;
@property (weak, nonatomic) IBOutlet UITextField *SingleQueryTextField;
@property (weak, nonatomic) IBOutlet UITextField *RangeQueryBeginTextField;
@property (weak, nonatomic) IBOutlet UITextField *RangeQueryEndTextField;

@property (weak, nonatomic) IBOutlet UITextView *QueryResultMultiTextField;

@end
