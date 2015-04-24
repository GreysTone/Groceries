//
//  SettingViewController.m
//  iDatabase Single
//
//  Created by GreysTone on 4/25/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "SettingViewController.h"

extern Database *gtDatabase;

@implementation SettingViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.NotificationSwitch.on = gtDatabase.STAT_NOTIFICATION_OPEN;
    self.AppleWatchSwitch.on = gtDatabase.STAT_WATCH_OPEN;
}

- (void) viewWillDisappear:(BOOL)animated {
    gtDatabase.STAT_NOTIFICATION_OPEN = self.NotificationSwitch.on;
    gtDatabase.STAT_WATCH_OPEN = self.AppleWatchSwitch.on;
}

@end
