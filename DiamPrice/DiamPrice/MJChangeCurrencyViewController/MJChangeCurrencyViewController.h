//
//  MJChangeCurrencyViewController.h
//  MyJeweler
//
//  Created by Ch Burhan Ahmad on 1/12/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJChangeCurrencyViewController : UIViewController
@property (nonatomic, retain) NSArray *imagesArray;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)cancelButtonPressed:(id)sender;

- (IBAction)doneButtonPressed:(id)sender;



@end
