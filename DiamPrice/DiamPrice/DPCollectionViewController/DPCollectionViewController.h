//
//  DPCollectionViewController.h
//  DiamPrice
//
//  Created by Ch Burhan Ahmad on 1/15/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPCollectionViewController : UIViewController{
    NSNumberFormatter *numberFormatter;
   BOOL sortAssending;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *testImage;
@property (weak, nonatomic) IBOutlet UIImageView *flagImage;

- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;
- (IBAction)infoButtonPressed:(id)sender;
- (IBAction)cameraButtonPressed:(id)sender;
- (IBAction)sInfoButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)editButtonPressed:(id)sender;
-(void)priceLabelwithVALUE:(float)value ;
-(void) updateViewWithNewCurrency;
-(IBAction)sortDiamond:(id)sender;
@end
