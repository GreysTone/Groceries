//
//  AddNewCardViewController.h
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"

@interface AddNewCardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *CardIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *UserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *CardUnitTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *CardCategoryTextField;

@end
