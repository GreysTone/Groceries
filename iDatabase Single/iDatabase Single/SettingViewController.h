//
//  SettingViewController.h
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"

@interface SettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *NotificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *AppleWatchSwitch;

@end
