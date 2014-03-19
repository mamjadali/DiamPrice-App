//
//  DPDiamondsViewController.h
//  DiamPrice
//
//  Created by Ch Burhan Ahmad on 1/14/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPDiamondsViewController : UIViewController{
NSArray *cutList,*colorList,*clarityList;
NSString *cutString,*colorString,*clarityString,*discountString;
NSMutableArray *discountList;
}
- (IBAction)numberButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *addToCollectionButton;
- (IBAction)addToCollectionButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *flagImage;

@property (weak, nonatomic) IBOutlet UILabel *pricePerCaratDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *diamondPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *pricePerCaratLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *caratTextField;
@property (weak, nonatomic) IBOutlet UILabel *quantityTextField;
@property (weak, nonatomic) IBOutlet UIButton *weightButton;

@property (weak, nonatomic) IBOutlet UIButton *quantityButton;
- (IBAction)quantityButtonPressed:(id)sender;
- (IBAction)caratButtonPressed:(id)sender;

-(void) refreshPrice;

@end
