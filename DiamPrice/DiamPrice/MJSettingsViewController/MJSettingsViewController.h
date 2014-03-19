//
//  MJSettingsViewController.h
//  MyJeweler
//
//  Created by Ch Burhan Ahmad on 12/25/13.
//  Copyright (c) 2013 MaavraTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *changeCurrencyButton;
- (IBAction)changeCurrencyButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *manualCurrencyTextField;
- (IBAction)refreshButtonPressed:(id)sender;
- (IBAction)autoButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *manualButton;
@property (weak, nonatomic) IBOutlet UIButton *autoButton;
- (IBAction)discountLabelPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rapnetButton;
@property (weak, nonatomic) IBOutlet UIButton *idexButton;
- (IBAction)idexBUttonPressed:(id)sender;
- (IBAction)aboutButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *defaultDiscountButton;

- (IBAction)clearAllDataButtonPressed:(id)sender;

- (IBAction)manualButtonPressed:(id)sender;
@end
