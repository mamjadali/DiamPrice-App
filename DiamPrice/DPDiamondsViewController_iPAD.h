//
//  DPDiamondsViewController_iPAD.h
//  DiamPrice
//
//  Created by Amjad on 3/7/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import "DPDiamondsViewController.h"

@interface DPDiamondsViewController_iPAD : DPDiamondsViewController<UIPopoverControllerDelegate>
{
    NSNumberFormatter *numberFormatter;
    BOOL sortAssending;
    UIPopoverController *popOverShapes;
    UIPopoverController *popOverAbout, *popOverSetting;
	BOOL popOverIsActive;
	IBOutlet UIButton *refreshButton,*deleteButton,*cameraButton,*shapesButton,*aboutButton,*mailButton,*editButton,*settingButton,*aboutButton2,*shapesButton2;

}

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;
- (IBAction)cameraButtonPressed:(id)sender;
- (IBAction)sInfoButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)editButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;

-(void)priceLabelwithVALUE:(float)value ;
-(void) updateViewWithNewCurrency;
-(IBAction)sortDiamond:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *calculatorView;
@property (weak, nonatomic) IBOutlet UIView *addToCollectView;
@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UIView *calTableView;

@end
