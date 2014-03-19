//
//  MJSharedClient.m
//  MyJeweler
//
//  Created by Ch Burhan Ahmad on 1/12/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import "MJSharedClient.h"
#import "MyJewellerIAPHelper.h"
@implementation MJSharedClient

+(MJSharedClient *) sharedInstance {
    static MJSharedClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MJSharedClient alloc] init];
    });
    
    return _sharedInstance;
}

//- (void) setCurrentGoldPriceValue:(NSNumber *)currentGoldPriceValue1{
//    if ([currentGoldPriceValue1 isEqual:[NSNull null]]) {
//        NSLog(@"current goald value in nil");
//    }
//    self.currentGoldPriceValue=currentGoldPriceValue1 ;;
//}
//
//- (void) setKitcoGoldPrice:(NSNumber *)kitcoGoldPrice1{
//    self.kitcoGoldPrice=kitcoGoldPrice1;
//}
-(id)init{
    if (self=[super init]) {
//        [[SKPaymentQueue defaultQueue] addTransactionObserver:[MyJewellerIAPHelper sharedHelper]];
        /*
        self.myJewel=[[NSMutableArray alloc]init];
        self.currentPriceValue=[[NSNumber alloc]initWithInt:0];
        self.currentGoldPriceValue=[[NSNumber alloc]initWithInt:0];
        
        self.currentDiamondPrice=[[NSNumber alloc]initWithInt:0];
        self.currentDiamondPricePerCarat=[[NSNumber alloc]initWithInt:0];
        self.currentDiamondDiscountPrice=[[NSNumber alloc]initWithInt:0];
        
        self.totalJewelPrice=0;
        self.caratTextFieldValue = @"1 ";
        self.quantityTextFieldValue = @"1 ";
        self.caratFieldValue = @"18 ";
        self.weightFieldValue = @"1 ";
        
        self.isPennyWeightEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"PennyWeightEnabled"];
        self.isManualCurrencyEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"ManualCurrencyDisabled"];
        self.manualCurrencyRate = [[NSUserDefaults standardUserDefaults] floatForKey:@"ManualRate"];
        NSLog(@"manualCurrencyRate is %f", [[NSUserDefaults standardUserDefaults] floatForKey:@"ManualRate"]);
        
        self.isidex=YES;
        self.priceSource=@"IDEX";
        self.isEditJewel=NO;
        self.isEditDiamondFromJewel=NO;
        self.isEditDiamondFromCollection=NO;
        self.isEditGoldFromJewel=NO;
        self.isEditGoldFromCollection=NO;
        self.isEditSilverFromJewel = NO;
        self.isEditSilverFromCollection = NO;
        self.isEditPlatinumFromJewel = NO;
        self.isEditPlatinumFromCollection = NO;
        self.kitcoGoldPrice=[[NSNumber alloc]initWithFloat:00];
        self.webDiamondPrice=[[NSNumber alloc]initWithFloat:35.2565];
        
        
        self.selectedCurrencyMultiplier = [[NSNumber alloc] initWithFloat:1];
        self.diamondDiscount = [[NSNumber alloc] initWithInt:0];
        
        self.selectedSpinnerValues = [[NSMutableArray alloc]init];
        
        // load products from itunes
        if ([MyJewellerIAPHelper sharedHelper].products == nil) {
            
            [[MyJewellerIAPHelper sharedHelper] requestProducts];
        }
        
        //
        
        
        // update metal prices
       
        
        [self loadMyCollection];
        if(self.myCollection==nil)
        {
            NSLog(@"mycollection is nill");
            self.myCollection=[NSMutableArray array];
            self.totalCollectionPrice=[[NSNumber alloc]init];
        }
        NSLog(@"mycollection price are %f",[self.totalCollectionPrice floatValue] );
        
        self.selectedCurrency = self.isManualCurrencyEnabled?@"manual":self.selectedCurrency;
*/
        self.currentPriceValue=[[NSNumber alloc]initWithInt:0];
        self.currentDiamondPrice=[[NSNumber alloc]initWithInt:0];
        self.currentDiamondPricePerCarat=[[NSNumber alloc]initWithInt:0];
        self.currentDiamondDiscountPrice=[[NSNumber alloc]initWithInt:0];
        self.totalJewelPrice=0;
        self.caratTextFieldValue = @"1 ";
        self.isidex=YES;
        self.priceSource=@"IDEX";
        self.isEditDiamondFromCollection=NO;
        self.webDiamondPrice=[[NSNumber alloc]initWithFloat:35.2565];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        if([[def valueForKey:@"currency"] isEqualToString:@"manual"])
        {
            self.selectedCurrency = [def valueForKey:@"mselectedCurrency"];
            self.selectedCurrencyMultiplier = [def valueForKey:@"mselectedCurrencyMultiplier"];
        }
        else if([[def objectForKey:@"currency"] isEqualToString:@"auto"])
        {
            self.selectedCurrency = [def valueForKey:@"selectedCurrency"];
            self.selectedCurrencyMultiplier = [def valueForKey:@"selectedCurrencyMultiplier"];
        }
        [def synchronize];
        self.defaultDiscount = [def objectForKey:@"defaultDiscount"];
        NSLog(@"defaultDiscount is %i", [self.defaultDiscount intValue]);
        self.defaultDiscount = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultDiscount"];
        self.defaultDiscount = [[NSNumber alloc] initWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"discount"] intValue]];
        NSLog(@"defaultDiscount is %i", [self.defaultDiscount intValue]);
        [def synchronize];
        
        NSLog(@"Selected Currency: %@",self.selectedCurrency);
        if(self.selectedCurrency == NULL || [self.selectedCurrency length] == 0)
        {
            self.selectedCurrency = @"USD";
            self.selectedCurrencyMultiplier = [[NSNumber alloc] initWithFloat:1];
        }
        if(self.defaultDiscount == 0)
        {
            self.defaultDiscount = [[NSNumber alloc] initWithInt:0];
        }
        [self loadMyCollection];
        if(self.myCollection==nil)
        {
            self.myCollection=[[NSMutableArray alloc]init];
            self.totalCollectionPrice=[[NSNumber alloc]init];
        }
        [[MJWebServiceClient sharedInstance] loadCurrencyExchange];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[MJWebServiceClient sharedInstance] loadIdexData];
        
        }
        }
    return self;
}
-(void)saveMyCollection {
	
	NSMutableArray *array = [NSMutableArray arrayWithArray:self.myCollection];
	NSMutableData *data = [NSMutableData data];
	NSKeyedArchiver *encode = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectory = [path objectAtIndex:0];
    NSLog(@"docDirectory = %@",docDirectory);
	NSString *file = [docDirectory stringByAppendingPathComponent:@"dc_save.iDK"];
	[encode encodeObject:array forKey:@"dc_save"];
	[encode encodeObject:self.totalCollectionPrice forKey:@"dc_totalprice"];
	NSLog(@"saving price source : %@",self.priceSource);
	[encode encodeObject:self.priceSource forKey:@"pricesource"];
	
	
	[encode finishEncoding];
	
	[data writeToFile:file atomically:YES];
	
}



-(void)loadMyCollection {
	NSFileManager *manager = [NSFileManager defaultManager];
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectory = [path objectAtIndex:0];
	NSString *file = [docDirectory stringByAppendingPathComponent:@"dc_save.iDK"];
	NSMutableArray *array;
    
	if([manager fileExistsAtPath:file]) {
		NSLog(@"file located and reading");
		NSMutableData *data;
		NSKeyedUnarchiver *decode;
		data = [NSData dataWithContentsOfFile:file];
		decode = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		array = [decode decodeObjectForKey:@"dc_save"];
		NSNumber *price=[NSNumber alloc];
		price=[decode decodeObjectForKey:@"dc_totalprice"];
		self.totalCollectionPrice=[[NSNumber alloc] initWithFloat:[price floatValue]];
		self.myCollection = [[NSMutableArray alloc]init];
		for (NSObject *item in array) {
			[self.myCollection addObject:item];
		}
		if([decode decodeObjectForKey:@"pricesource"]!=nil)
			self.priceSource=[[NSString alloc]initWithString: [decode decodeObjectForKey:@"pricesource"]];
		else
			self.priceSource=@"IDEX";
		
		if([self.priceSource isEqualToString:@"RAPAPORT"])
			self.priceSource=@"IDEX";
        
		NSLog(@"load price source : %@",self.priceSource);
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        if([[def objectForKey:@"currency"] isEqualToString:@"manual"])
        {
            self.selectedCurrency = [def valueForKey:@"mselectedCurrency"];
            self.selectedCurrencyMultiplier = [def valueForKey:@"mselectedCurrencyMultiplier"];
        }
        else if([[def objectForKey:@"currency"] isEqualToString:@"auto"])
        {
            self.selectedCurrency = [def valueForKey:@"selectedCurrency"];
            self.selectedCurrencyMultiplier = [def valueForKey:@"selectedCurrencyMultiplier"];
        }
        
		self.defaultDiscount = [[NSNumber alloc] initWithInt:[[decode decodeObjectForKey:@"defaultDiscount"]intValue]];
        self.defaultDiscount = [[NSNumber alloc] initWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"discount"] intValue]];
        
		if([self.priceSource isEqualToString:@"IDEX"])
            self.isidex=YES;
		else
		{
			self.isidex=NO;
			[[MJWebServiceClient sharedInstance] loadRapaportData];
		}
		[decode finishDecoding];
	} else {
		NSLog(@"file not found, save something to create the file");
	}
}
@end
