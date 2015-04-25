//
//  NewBooksViewController.h
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"

@interface NewBooksViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *InsertSTAT;
@property (weak, nonatomic) IBOutlet UITextField *ISBNTextField;
@property (weak, nonatomic) IBOutlet UITextField *CategoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *NameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PressTextField;
@property (weak, nonatomic) IBOutlet UITextField *YearTextField;
@property (weak, nonatomic) IBOutlet UITextField *AuthorTextField;
@property (weak, nonatomic) IBOutlet UITextField *PriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *AmountTextField;



@end
