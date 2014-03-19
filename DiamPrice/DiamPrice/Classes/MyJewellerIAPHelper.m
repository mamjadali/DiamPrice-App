//
//  MyJewellerIAPHelper.h
//  MyJeweller
//
//  Created by Imran Raheem on 10/16/11.
//  Copyright 2011 AppSplit. All rights reserved.
//

#import "MyJewellerIAPHelper.h"

@implementation MyJewellerIAPHelper

static MyJewellerIAPHelper * _sharedHelper;

+ (MyJewellerIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[MyJewellerIAPHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init {
    
    NSSet *productIdentifiers = [NSSet setWithObjects:
        PRODUCT_ID_PENNYWEIGHT,
        PRODUCT_ID_SILVER_PLATINUM,
        nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {                
        
    }
    return self;
    
}

@end
