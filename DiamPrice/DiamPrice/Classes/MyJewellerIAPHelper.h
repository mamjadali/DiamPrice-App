//
//  MyJewellerIAPHelper.h
//  MyJeweller
//
//  Created by Imran Raheem on 10/16/11.
//  Copyright 2011 AppSplit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAPHelper.h"

#define PRODUCT_ID_PENNYWEIGHT              @"com.appsplit.myjeweler.pennyweight"
#define PRODUCT_ID_SILVER_PLATINUM          @"com.appsplit.myjeweler.silverplatinum"


@interface MyJewellerIAPHelper : IAPHelper {

}

+ (MyJewellerIAPHelper *) sharedHelper;

@end
