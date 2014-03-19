//
//  DPRapnetViewController.h
//  DiamPrice
//
//  Created by Ch Burhan Ahmad on 1/21/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface DPRapnetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (nonatomic ,retain) MBProgressHUD *hud;
- (IBAction)doneButtonPressed:(id)sender;

@end
