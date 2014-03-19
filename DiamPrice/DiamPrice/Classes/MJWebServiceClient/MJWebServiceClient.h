//
//  MJWebServiceClient.h
//  MyJeweler
//
//  Created by Ch Burhan Ahmad on 12/29/13.
//  Copyright (c) 2013 MaavraTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJWebServiceClient : NSObject
{
    NSString * kitcoList;
	NSString *roundsCSV, *fancyCSV;
	NSArray *colorsList, *clarityList;
    
	NSMutableDictionary *idexRounds, *idexFancy, *rapaportRounds, *rapaportFancy;
	NSString *currencyFile;
	NSArray *currencyNames;
	NSArray *currencyRates;
	BOOL noLocalFlag;
	BOOL noInternetFlag;
	BOOL noLocalCurrency;
    BOOL errorOccuredDuringParsing;
    
}
@property (nonatomic,retain) NSArray *currencyNames;
@property (nonatomic,retain) NSArray *currencyRates;
@property (nonatomic ,retain)NSString *roundsCSV, *fancyCSV;
@property (nonatomic, retain) NSNumber *kitcoGoldPrice,*webDiamondPrice;

+(MJWebServiceClient *) sharedInstance;
- (void)getCSVAsynch;
-(void) loadIdexData;
-(void) updateIdexData;
-(void) parseIdexIntoDictionary;
-(float) idexPriceForWeight:(float)weight Cut:(NSString*)cut Color:(NSString*)color Clarity:(NSString*)clarity;
- (void) updatePrices;

-(void) loadRapaportData;
-(void) updateRapaportDataUSINGIDOFROUND:(NSString*)round_file PEARFILE:(NSString*)pear_file;
-(void) parseRapaportIntoDictionary;
-(float) rapaportPriceForWeight:(float)weight Cut:(NSString*)cut Color:(NSString*)color Clarity:(NSString*)clarity;
-(void) updateRapaportDataUSINGID:(NSString*)user_name PASSWORD:(NSString*)user_password;
-(void)updateCurrency;
-(void)parseCurrency;
-(void)loadCurrencyExchange;
-(NSUInteger)currentDayFromStartOfYear;

@end
