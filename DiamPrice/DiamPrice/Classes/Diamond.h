//
//  Diamond.h
//  My Jeweler
//
//  Created by Faheem on 26/01/10.
//  Copyright 2010 appsplit. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Diamond : NSObject<NSCoding> {
	NSString *name;
	NSNumber *quantity;
	NSNumber *weight;
	NSNumber *price;
	NSNumber *pricePerCarat;
	NSNumber *discount;
	NSNumber *discountPrice;
	NSString *cut;
	NSString *clarity;
	NSString *color;
	UIImage *image;
}

-(id) initwithNAME:(NSString *)nam WEIGHT:(NSNumber *)wet QUANTITY:(NSNumber *)qty PRICE:(NSNumber *)pr CUT:(NSString *)ct COLOR:(NSString *)col CLARITY:(NSString *)clar DISCOUNT:(NSNumber *)dis DISCOUNTPRICE:(NSNumber *)dpr PRICEPERCARAT:(NSNumber *)ppr;

@property (nonatomic,retain) NSString *name,*cut,*clarity,*color;
@property (nonatomic,retain) NSNumber *price,*quantity,*weight,*discount,*discountPrice,*pricePerCarat;
@property (nonatomic,retain) UIImage *image;

- (NSString *)returnImageName: (NSString *)cutL;

@end
