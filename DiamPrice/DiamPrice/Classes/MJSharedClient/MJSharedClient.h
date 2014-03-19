//
//  MJSharedClient.h
//  MyJeweler
//
//  Created by Ch Burhan Ahmad on 1/12/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJWebServiceClient.h"
#import "Diamond.h"





@interface MJSharedClient : NSObject

+(MJSharedClient *) sharedInstance ;

-(void)saveMyCollection;
-(void)loadMyCollection;
@property (nonatomic, retain) NSMutableArray *myJewel;
@property (nonatomic, retain) NSMutableArray *myCollection;
@property (nonatomic, retain) IBOutlet UITableView *myCollectionTableView;
@property (nonatomic, retain) NSNumber *currentPriceValue,*currentGoldPriceValue,*totalCollectionPrice,*totalJewelPrice,*currentSilverPriceValue, *currentPlataniumPriceValue;
@property (nonatomic, retain) NSNumber *currentDiamondPrice,*currentDiamondPricePerCarat,*currentDiamondDiscountPrice;
@property (nonatomic, retain) NSNumber *kitcoGoldPrice,*webDiamondPrice;
//@property (nonatomic, retain) MJWebServiceClient *webService;
@property (nonatomic, assign) bool isidex,isEditJewel,isEditDiamondFromCollection,isEditSilverFromCollection,isEditGoldFromCollection,isEditPlatinumFromCollection,isEditDiamondFromJewel,isEditGoldFromJewel;
@property (nonatomic, assign) bool isEditSilverFromJewel, isEditPlatinumFromJewel;
@property (nonatomic, retain) Diamond *editableDiamond;
@property (nonatomic, retain) NSString *priceSource;
@property (nonatomic, assign) UINavigationController *nav;
@property (nonatomic, retain) NSString *caratTextFieldValue;
@property (nonatomic, retain) NSString *labourCosts;
@property (nonatomic, retain) NSString *quantityTextFieldValue;
@property (nonatomic, retain) NSString *caratFieldValue;
@property (nonatomic, retain) NSString *weightFieldValue;
@property (nonatomic, retain) NSString *selectedCurrency;
@property (nonatomic, retain) NSNumber *selectedCurrencyMultiplier;
@property (nonatomic, retain) NSNumber *diamondDiscount, *goldDiscount, *silverDiscount, *platinumDiscount ;
@property (nonatomic, retain) NSMutableArray *selectedSpinnerValues;
@property (nonatomic, readwrite) BOOL isPennyWeightEnabled;
@property (nonatomic, readwrite) BOOL isManualCurrencyEnabled;
@property (nonatomic, readwrite) BOOL isRefreshRequired;
@property (nonatomic, readwrite) BOOL isJewelRefreshRequired;
@property (nonatomic, readwrite) float manualCurrencyRate;
@property (nonatomic, retain) NSNumber *defaultDiscount;
@end
