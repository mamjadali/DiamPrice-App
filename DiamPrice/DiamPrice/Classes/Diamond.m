//
//  Diamond.m
//  My Jeweler
//
//  Created by Faheem on 26/01/10.
//  Copyright 2010 appsplit. All rights reserved.
//

#import "Diamond.h"

//static int counter = -1;

@implementation Diamond

@synthesize name,weight,quantity,price,cut,color,clarity,discount,discountPrice,pricePerCarat,image;

-(id) initwithNAME:(NSString *)nam WEIGHT:(NSNumber *)wet QUANTITY:(NSNumber *)qty PRICE:(NSNumber *)pr CUT:(NSString *)ct COLOR:(NSString *)col CLARITY:(NSString *)clar DISCOUNT:(NSNumber *)dis DISCOUNTPRICE:(NSNumber *)dpr PRICEPERCARAT:(NSNumber *)ppr
{

	self.name=nam;
	self.weight=wet;
	self.quantity=qty;
	self.price=pr;
	self.pricePerCarat=ppr;
	self.discountPrice=dpr;
	self.color=col;
	self.cut=ct;	
	self.clarity=clar;
	self.discount=dis;
    NSString    *randImg = [self returnImageName:ct];
	self.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",randImg]];
//@"default_diamond.png"
	return self;
}
- (NSString *)returnImageName: (NSString *)cutL
{
    if([cutL  isEqualToString: @"BR"])return @"round";
    if([cutL  isEqualToString: @"PS"])return @"pear";
    if([cutL  isEqualToString: @"PR"])return @"princess";
    if([cutL  isEqualToString: @"RAD"])return @"radiant";
    if([cutL  isEqualToString: @"AC"])return @"asscher";
    if([cutL  isEqualToString: @"EM"])return @"emerald";
    if([cutL  isEqualToString: @"MQ"])return @"marquise";
    if([cutL  isEqualToString: @"BAG"])return @"baguette";
    if([cutL  isEqualToString: @"HS"])return @"heart";
    if([cutL  isEqualToString: @"CU"])return @"cushion";
    if([cutL  isEqualToString: @"TRI"])return @"triangle";
    if([cutL  isEqualToString: @"OV"])return @"oval";
    return @"";
}
- (id)initWithCoder:(NSCoder *)decoder
{
    self.name			= [decoder decodeObjectForKey:@"diamond.name"];
    self.weight			= [decoder decodeObjectForKey:@"diamond.weight"];
	self.quantity		= [decoder decodeObjectForKey:@"diamond.quantity"];
    self.price			= [decoder decodeObjectForKey:@"diamond.price"];
	self.pricePerCarat	= [decoder decodeObjectForKey:@"diamond.pricepercarat"];
	self.discountPrice	= [decoder decodeObjectForKey:@"diamond.discountprice"];
	self.color			= [decoder decodeObjectForKey:@"diamond.color"];
	self.cut			= [decoder decodeObjectForKey:@"diamond.cut"];
	self.clarity		= [decoder decodeObjectForKey:@"diamond.clarity"];
	self.discount		= [decoder decodeObjectForKey:@"diamond.discount"];
	NSData *imageData	= [decoder decodeObjectForKey:@"jewel.image"]; 
	if(imageData){
		self.image = [UIImage imageWithData:imageData];
	}
	
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:name			forKey:@"diamond.name"];
	[encoder encodeObject:weight			forKey:@"diamond.weight"];
	[encoder encodeObject:quantity		forKey:@"diamond.quantity"];
	[encoder encodeObject:price			forKey:@"diamond.price"];
	[encoder encodeObject:pricePerCarat	forKey:@"diamond.pricepercarat"];
	[encoder encodeObject:discountPrice	forKey:@"diamond.discountprice"];
	[encoder encodeObject:color			forKey:@"diamond.color"];
	[encoder encodeObject:cut				forKey:@"diamond.cut"];
	[encoder encodeObject:clarity			forKey:@"diamond.clarity"];
	[encoder encodeObject:discount		forKey:@"diamond.discount"];
	NSData *imageData = UIImagePNGRepresentation(image);
	[encoder encodeObject:imageData forKey:@"jewel.image"];
}
@end
