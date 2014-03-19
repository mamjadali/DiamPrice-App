//
//  DPCollectionViewCell.h
//  DiamPrice
//
//  Created by Ch Burhan Ahmad on 1/15/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPCollectionViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *cutLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *clarityLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@end
