//
//  DPSettingsViewController_iPAD.h
//  DiamPrice
//
//  Created by Amjad on 3/17/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import "MJSettingsViewController.h"

@interface DPSettingsViewController_iPAD : MJSettingsViewController<UIPopoverControllerDelegate>{
    UIPopoverController *popOverAbout;

}
@property (weak, nonatomic) IBOutlet UIButton *settingButtonPressed;

@end
