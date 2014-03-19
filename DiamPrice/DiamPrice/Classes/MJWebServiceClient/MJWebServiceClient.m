//
//  MJWebServiceClient.m
//  MyJeweler
//
//  Created by Ch Burhan Ahmad on 12/29/13.
//  Copyright (c) 2013 MaavraTech. All rights reserved.
//

#import "MJWebServiceClient.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "XMLDictionary.h"
#import "MJSharedClient.h"
#define DOCFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation MJWebServiceClient
@synthesize currencyRates,currencyNames;
- (void)getCSVAsynch {
    NSString *unescaped = @"http://download.finance.yahoo.com/d/quotes.csv?s=^GSPC,^IXIC,^dji,^GSPC,^BVSP,^GSPTSE,^FTSE,^GDAXI,^FCHI,^STOXX50E,^AEX,^IBEX,^SSMI,^N225,^AXJO,^HSI,^NSEI&f=sl1d1t1c1ohgv&e=.csv";
    NSURL *url = [NSURL URLWithString:[unescaped stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"CSV: %@", [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Things go boom. %@", [error localizedDescription]);
    }];
    [operation start];
}
-(id) init {
	self = [super init];
	colorsList = [[NSArray alloc] initWithObjects: @"D",
			  @"E",
			  @"F",
			  @"G",
			  @"H",
			  @"I",
			  @"J",
			  @"K",
			  @"L",
			  @"M",
			  @"N",
			  nil];
	
	clarityList = [[NSArray alloc] initWithObjects: @"IF",
			   @"VVS1",
			   @"VVS2",
			   @"VS1",
			   @"VS2",
			   @"SI1",
			   @"SI2",
			   @"SI3",
			   @"I1",
			   @"I2",
			   @"I3",
			   nil];
	
	noLocalFlag = NO;
	noInternetFlag = NO;
    errorOccuredDuringParsing = NO;
	return self;
}
+(MJWebServiceClient *) sharedInstance {
    static MJWebServiceClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MJWebServiceClient alloc] init];
    });
    
    return _sharedInstance;
}
-(void) loadCurrencyExchange {
	NSLog(@"    entering %s",__PRETTY_FUNCTION__);
	NSUInteger day = [self currentDayFromStartOfYear];
	if (currencyFile!=nil)
		
	currencyFile = [[NSString alloc] initWithContentsOfFile:[DOCFOLDER stringByAppendingPathComponent:@"CurrencyFile.xml"] encoding:NSUTF8StringEncoding error:Nil];
	NSLog(@"    entering CUR %@",currencyFile);
    
	NSString *dateFile = [NSString stringWithContentsOfFile:[DOCFOLDER stringByAppendingPathComponent:@"CurrencyFileLastDate.txt"] encoding:NSASCIIStringEncoding error:nil];
	
	if (currencyFile==nil) {
		noLocalCurrency = YES;
		[self updateCurrency];
		return;
	}
	noLocalCurrency = NO;
	
	if ([dateFile intValue]!=day)
		[self updateCurrency];
	else {
		[self parseCurrency];
	}
	
}
- (void) updateCurrency {
    
   
    NSString *urlString = @"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"xml: %@", [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding]);
        currencyFile = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
       
        
   
        if( currencyFile == nil && noLocalCurrency == YES) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Cannot update currency" message:@"You need to connect to the Internet to download currency exchange values. Please rerun the application when you have access to the internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            
        }
        else if (currencyFile == nil && noLocalCurrency == NO){
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Cannot update currency" message:@"Using old currency exchange values." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            currencyFile = [[NSString alloc] initWithContentsOfFile:[DOCFOLDER stringByAppendingPathComponent:@"CurrencyFile.xml"] encoding:NSUTF8StringEncoding error:Nil];
            
            [self parseCurrency];
        }
        else {
            NSUInteger day = [self currentDayFromStartOfYear];
            [currencyFile writeToFile:[DOCFOLDER stringByAppendingPathComponent:@"CurrencyFile.xml"] atomically:NO encoding:NSASCIIStringEncoding error:nil];
            NSString *dateFile = [NSString stringWithFormat:@"%lu",(unsigned long)day];
            [dateFile writeToFile:[DOCFOLDER stringByAppendingPathComponent:@"CurrencyFileLastDate.txt"] atomically:NO encoding:NSASCIIStringEncoding error:nil];
            
            [self parseCurrency];
        }

        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Things go boom. %@", [error localizedDescription]);
    }];
    [operation start];
	    
    
}
- (void) parseCurrency {
	NSMutableArray *names = [[NSMutableArray alloc] init];
	NSMutableArray *rates = [[NSMutableArray alloc] init];
	[names addObject:@"EUR"];
    [rates addObject:@"1.0"];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:currencyFile];
//    NSLog(@"dictionary: %@", [[xmlDoc childNodes] objectForKey:0]);
    NSString *foo = [xmlDoc valueForKeyPath:@"Cube.@innerXML"];
//    NSLog(@"dictionary: %@", foo);
    xmlDoc = [NSDictionary dictionaryWithXMLString:foo];
    NSArray *temp = [xmlDoc objectForKey:@"Cube"];
//    NSLog(@"dictionary: %@", [temp objectAtIndex:0]);
    for (NSDictionary *tmpDict in temp) {
        [names addObject:[tmpDict objectForKey:@"_currency"]];
        [rates addObject:[tmpDict objectForKey:@"_rate"]];
        NSLog(@"Currency = %@ Rate = %@",[tmpDict objectForKey:@"_currency"],[tmpDict objectForKey:@"_rate"]);
    }
    
//	[names addObjectsFromArray:[currencyFile componentsMatchedByRegex:@"currency='(.[A-z]+)'" capture:1]];
	
	
	NSLog(@"%@", currencyFile);
//	[rates addObjectsFromArray:[currencyFile componentsMatchedByRegex:@"rate='(.[0-9.]+)'" capture:1]];
	NSLog(@"names %@",names);
    if ([names count]>0) {
        self.currencyNames = names;
    }
     if ([rates count]>0) {
         self.currencyRates = rates;
     }
	
	NSLog(@"names %@",self.currencyNames);
	
		
    if (![MJSharedClient sharedInstance].selectedCurrency) {
        [MJSharedClient sharedInstance].selectedCurrency = @"USD";
       
    }
	NSUInteger index = [self.currencyNames indexOfObject:[MJSharedClient sharedInstance].selectedCurrency];
	NSLog(@"cur name %@",[MJSharedClient sharedInstance].selectedCurrency);
	NSLog(@"index %lu",(unsigned long)index);
	
	if (index<[self.currencyRates count])
	{
		float multi = 1/([[self.currencyRates objectAtIndex:1] floatValue]/[[self.currencyRates objectAtIndex:index] floatValue]);
		if (index == 1)
			multi = 1;
		
		[MJSharedClient sharedInstance].selectedCurrencyMultiplier = [NSNumber numberWithFloat:multi];
        
		NSLog(@"multi %f",multi);
		NSLog(@"multi %@",[MJSharedClient sharedInstance].selectedCurrencyMultiplier);
	}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateViewWithNewCurrency" object:nil];
}
-(void) loadIdexData {
	
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"M"];
	NSInteger todayMonth = [[dateFormat stringFromDate:[NSDate date]] intValue];
	[dateFormat setDateFormat:@"YYYY"];
    NSLog(@"todayMonth %li", (long)todayMonth);
	NSString *todayYear = [dateFormat stringFromDate:[NSDate date]];
	NSLog(@"todayYear %@", todayYear);
	NSArray *monthList = [NSArray arrayWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July", @"August",@"September",@"October",@"November",@"December",nil];
	
    
    if (errorOccuredDuringParsing)
    {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDirectory = [path objectAtIndex:0];
        NSString *file = [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexRounds_%@%@.csv",[monthList objectAtIndex:todayMonth-1],todayYear]];
        NSLog(@"file: %@",file);
        if([manager fileExistsAtPath:file]) {
            if ([manager isDeletableFileAtPath:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexRounds_%@%@.csv",[monthList objectAtIndex:todayMonth-1],todayYear]]])
            {
                NSLog(@"file located and deleteable, %@",file);
                if ([manager removeItemAtPath:file error:nil])
                    NSLog(@"delete item was successful");
            }
        }
        //        NSLog(@"DOCFOLDER: %@",DOCFOLDER);
        
        todayMonth -= 1;
        errorOccuredDuringParsing = NO;
    }
    @try
    {
        if(todayMonth == 1)
        {
            int todayYearInt = [todayYear intValue];
            todayYearInt -= 1;
            todayYear = [NSString stringWithFormat:@"%i", todayYearInt];
            
            roundsCSV = [[NSString alloc] initWithContentsOfFile:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexRounds_%@%@.csv", [monthList objectAtIndex:todayMonth+10],todayYear]] encoding:NSUTF8StringEncoding error:Nil];
            fancyCSV = [[NSString alloc] initWithContentsOfFile:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexFancy%@%@.csv", [monthList objectAtIndex:todayMonth+10],todayYear]] encoding:NSUTF8StringEncoding error:Nil];
        }
        else
        {
            roundsCSV = [[NSString alloc] initWithContentsOfFile:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexRounds_%@%@.csv", [monthList objectAtIndex:todayMonth-2],todayYear]] encoding:NSUTF8StringEncoding error:Nil];
            NSLog(@"File used: %@",[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexRounds_%@%@.csv", [monthList objectAtIndex:todayMonth-2],todayYear]]);
            fancyCSV = [[NSString alloc] initWithContentsOfFile:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexFancy%@%@.csv", [monthList objectAtIndex:todayMonth-2],todayYear]] encoding:NSUTF8StringEncoding error:Nil];
        }
    }
    @catch (NSException *e) {
        roundsCSV = nil;
        fancyCSV = nil;
    }
	
	if( roundsCSV == nil || fancyCSV == nil ) {
		if( noInternetFlag ) {
			//UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Cannot find price list" message:@"You need to connect to the internet atleast once to download the price list. Please rerun the application when you have access to the internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [av show]; [av release];
		}
		else {
			noLocalFlag = YES;
			//UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Need to update" message:@"You need to connect to the internet atleast once to download the price list. The application will now download the price list from the internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [av show]; [av release];
			[self updateIdexData];
		}
	}
	else {
		[self parseIdexIntoDictionary];
	}
	noInternetFlag = NO;
	noLocalFlag = NO;
}
-(void) updateIdexData {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"M"];
	NSInteger todayMonth = [[dateFormat stringFromDate:[NSDate date]] intValue];
	[dateFormat setDateFormat:@"YYYY"];
	NSString *todayYear = [dateFormat stringFromDate:[NSDate date]];
	
	NSArray *monthList = [NSArray arrayWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July", @"August",@"September",@"October",@"November",@"December",nil];

	if( roundsCSV == nil || fancyCSV == nil ) {
        if (roundsCSV == nil) {
            NSString *urlStrinForRoundsCSV;
            @try
            {
                if(todayMonth == 1)
                {
                    int todayYearInt = [todayYear intValue];
                    todayYearInt -= 1;
                    todayYear = [NSString stringWithFormat:@"%i", todayYearInt];
                    
                    urlStrinForRoundsCSV=[NSString stringWithFormat:@"http://www.idexonline.com/DRB/Rounds_DRB_%@%@.csv", [monthList objectAtIndex:todayMonth+10],todayYear];
                    
                }
                else
                {
                    urlStrinForRoundsCSV = [NSString stringWithFormat:@"http://www.idexonline.com/DRB/Rounds_DRB_%@%@.csv", [monthList objectAtIndex:todayMonth-2],todayYear];
                   
                }
               
                NSURL *url = [NSURL URLWithString:urlStrinForRoundsCSV];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"CSV: %@", [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding]);
                    roundsCSV = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
                    [self writeCSVFile];
                    [self parseIdexIntoDictionary];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Things go boom. %@", [error localizedDescription]);
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Cannot find price list" message:@"You need to connect to the internet atleast once to download the price list. Please rerun the application when you have access to the internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }];
                [operation start];
            }
            @catch (NSException *e) {
                
            }
        }
        if (fancyCSV==nil) {
             NSString *urlStrinForFancyCSV;
            @try
            {
                int todayYearInt = [todayYear intValue];
                todayYearInt -= 1;
                todayYear = [NSString stringWithFormat:@"%i", todayYearInt];
                
                if(todayMonth == 1)
                {
                    urlStrinForFancyCSV = [NSString stringWithFormat:@"http://www.idexonline.com/DRB/Fancy_Cuts_DRB_%@%@.csv", [monthList objectAtIndex:todayMonth+10],todayYear];
                }
                else
                {
                    urlStrinForFancyCSV = [NSString stringWithFormat:@"http://www.idexonline.com/DRB/Fancy_Cuts_DRB_%@%@.csv", [monthList objectAtIndex:todayMonth-2],todayYear];
                }
                NSURL *url = [NSURL URLWithString:urlStrinForFancyCSV];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"CSV: %@", [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding]);
                    fancyCSV = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
                    [self writeCSVFile];
                    [self parseIdexIntoDictionary];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Things go boom. %@", [error localizedDescription]);
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Cannot find price list" message:@"You need to connect to the internet atleast once to download the price list. Please rerun the application when you have access to the internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }];
                [operation start];

            }
            @catch (NSException *e) {
                
            }
        }
        
//        *******************
//		if( noLocalFlag ) {
//			UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Cannot find price list" message:@"You need to connect to the internet atleast once to download the price list. Please rerun the application when you have access to the internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [av show];
//            
//		}
//		else {
//			noInternetFlag = YES;
//			
//		}
	}
	else {
        
        @try
        {
            if(todayMonth == 1)
            {
                int todayYearInt = [todayYear intValue];
                todayYearInt -= 1;
                todayYear = [NSString stringWithFormat:@"%i", todayYearInt];
                
                [roundsCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexRounds_%@%@.csv", [monthList objectAtIndex:todayMonth+10],todayYear]] atomically:NO encoding:NSASCIIStringEncoding error:nil];
                [fancyCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexFancy%@%@.csv", [monthList objectAtIndex:todayMonth+10],todayYear]] atomically:NO encoding:NSASCIIStringEncoding error:nil];
            }
            else
            {
                [roundsCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexRounds_%@%@.csv", [monthList objectAtIndex:todayMonth-2],todayYear]] atomically:NO encoding:NSASCIIStringEncoding error:nil];
                [fancyCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexFancy%@%@.csv", [monthList objectAtIndex:todayMonth-2],todayYear]] atomically:NO encoding:NSASCIIStringEncoding error:nil];
            }
        }
        @catch (NSException *e) {
            
        }
		
		[self parseIdexIntoDictionary];
	}
	noInternetFlag = NO;
	noLocalFlag = NO;
}
-(void)writeCSVFile{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"M"];
	NSInteger todayMonth = [[dateFormat stringFromDate:[NSDate date]] intValue];
	[dateFormat setDateFormat:@"YYYY"];
	NSString *todayYear = [dateFormat stringFromDate:[NSDate date]];
	
	NSArray *monthList = [NSArray arrayWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July", @"August",@"September",@"October",@"November",@"December",nil];

    @try
    {
        if(todayMonth == 1)
        {
            int todayYearInt = [todayYear intValue];
            todayYearInt -= 1;
            todayYear = [NSString stringWithFormat:@"%i", todayYearInt];
            
            
            
            [roundsCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexRounds_%@%@.csv", [monthList objectAtIndex:todayMonth+10],todayYear]] atomically:NO encoding:NSASCIIStringEncoding error:nil];
            [fancyCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexFancy%@%@.csv", [monthList objectAtIndex:todayMonth+10],todayYear]] atomically:NO encoding:NSASCIIStringEncoding error:nil];
        }
        else
        {
            
            
            [roundsCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexRounds_%@%@.csv", [monthList objectAtIndex:todayMonth-2],todayYear]] atomically:NO encoding:NSASCIIStringEncoding error:nil];
            [fancyCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"LatestIdexFancy%@%@.csv", [monthList objectAtIndex:todayMonth-2],todayYear]] atomically:NO encoding:NSASCIIStringEncoding error:nil];
        }
        
    }
    @catch (NSException *e) {
        
    }
    
    if (roundsCSV !=nil && fancyCSV !=nil) {
        [self parseIdexIntoDictionary];
        noInternetFlag = NO;
        noLocalFlag = NO;
        [self loadIdexData];
        return;
    }
}
-(void) parseIdexIntoDictionary {//Traversing CVS to get metal price
    @try {
        {
           
            
            idexRounds = [[NSMutableDictionary alloc] init];
            
            NSMutableDictionary *colorValues;
            NSMutableDictionary *clarityValues;
            CGPoint thisWeight;
            
            NSArray *csvLines = [roundsCSV componentsSeparatedByString:@"\n"];
            if (csvLines!=nil) {

                for(int i=0, count=0;i<16;i++) {
                for(int j=0;j<13;j++,count++) {
                    NSString *line = [csvLines objectAtIndex:count];
                    if( j == 0 ) {
                        colorValues = [[NSMutableDictionary alloc] init];
                        NSArray *ranges = [[line substringWithRange:NSMakeRange([line rangeOfString:@"("].location+1, 9)] componentsSeparatedByString:@"-"];
                        thisWeight = CGPointMake([[ranges objectAtIndex:0] floatValue], [[ranges objectAtIndex:1] floatValue]);
                    }
                    else if( j == 1) {
                        continue;
                    }
                    else {
                        NSArray *csvComponents = [line componentsSeparatedByString:@","];
                        clarityValues = [[NSMutableDictionary alloc] init];
                        for (int k = 0; k < [clarityList count]; k++) {
                            [clarityValues setObject:[csvComponents objectAtIndex:(k+1)] forKey:[clarityList objectAtIndex:k]];
                        }
                        [colorValues setObject:clarityValues forKey:[colorsList objectAtIndex:j-2]];
                       
                    }
                }
                [idexRounds setObject:colorValues forKey:[NSValue valueWithCGPoint:thisWeight]];
                
            }
            }
        }
        {
            
            idexFancy = [[NSMutableDictionary alloc] init];
            
            NSMutableDictionary *colorValues;
            NSMutableDictionary *clarityValues;
            CGPoint thisWeight;
            
            NSArray *csvLines = [fancyCSV componentsSeparatedByString:@"\n"];
            if (fancyCSV!=nil) {
                
            
                for(int i=0, count=0;i<16;i++) {
                for(int j=0;j<13;j++,count++) {
                    NSString *line = [csvLines objectAtIndex:count];
                    if( j == 0 ) {
                        colorValues = [[NSMutableDictionary alloc] init];
                        NSArray *ranges = [[line substringWithRange:NSMakeRange([line rangeOfString:@"("].location+1, 9)] componentsSeparatedByString:@"-"];
                        thisWeight = CGPointMake([[ranges objectAtIndex:0] floatValue], [[ranges objectAtIndex:1] floatValue]);
                    }
                    else if( j == 1) {
                        continue;
                    }
                    else {
                        NSArray *csvComponents = [line componentsSeparatedByString:@","];
                        clarityValues = [[NSMutableDictionary alloc] init];
                        for (int k = 0; k < [clarityList count]; k++) {
                            [clarityValues setObject:[csvComponents objectAtIndex:(k+1)] forKey:[clarityList objectAtIndex:k]];
                        }
                        [colorValues setObject:clarityValues forKey:[colorsList objectAtIndex:j-2]];
                        
                    }
                }
                [idexFancy setObject:colorValues forKey:[NSValue valueWithCGPoint:thisWeight]];
               
            }
            }
        }
        {
            NSArray *csvLines = [kitcoList componentsSeparatedByString:@"\n"];
            if (csvLines!=nil) {

                for(NSString * str in csvLines) {
                NSArray *values = [str componentsSeparatedByString:@","];
                NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
                if ([values count]>=2) {
                    if ([[values objectAtIndex:0] isEqual:_kGold]) {
                        
                        self.kitcoGoldPrice=[values objectAtIndex:2];
                    }
                    [ud setValue:[values objectAtIndex:2] forKey:[values objectAtIndex:0]];
                    NSLog(@"values: %@...%@", [values objectAtIndex:0], [values objectAtIndex:2]);
                }
                
            }
            }
        }
        
    }
    @catch (NSException *e)
    {
        errorOccuredDuringParsing = YES;
        [self loadIdexData];
        [self updateIdexData];
    }
}
-(float) idexPriceForWeight:(float)weight Cut:(NSString*)cut Color:(NSString*)color Clarity:(NSString*)clarity {
	NSDictionary *thisDictionary;
	
	
	if( [cut isEqualToString:@"BR"] ) {
        //	NSLog(@"Round : %@ %@ %@ %f",cut,color,clarity,weight);
		thisDictionary = idexRounds;
        //	NSLog(@"Round : %@", thisDictionary);
        
	}
	else {
		//NSLog(@"Fancy : %@ %@ %@ %f",cut,color,clarity,weight);
		thisDictionary = idexFancy;
	}
	
	for (NSValue *weightKey in thisDictionary) {
		CGPoint thisWeight;
		[weightKey getValue:&thisWeight];
		if( weight >= thisWeight.x && weight <= thisWeight.y ) {
			NSMutableDictionary *colorValues;
			NSMutableDictionary *clarityValues;
			colorValues = [thisDictionary objectForKey:weightKey];
			clarityValues = [colorValues objectForKey:color];
            //	NSLog(@"Ans: %@", [clarityValues objectForKey:clarity]);
			return [[clarityValues objectForKey:clarity] floatValue];
		}
	}
	
	//NSLog(@"not found");
	return -1;
}
-(void) loadRapaportData {
	if (roundsCSV!=nil)
	
	
	roundsCSV = [[NSString alloc] initWithContentsOfFile:[DOCFOLDER stringByAppendingPathComponent:@"LatestRapaportRounds.csv"] encoding:NSUTF8StringEncoding error:Nil];
    fancyCSV = [[NSString alloc] initWithContentsOfFile:[DOCFOLDER stringByAppendingPathComponent:@"LatestRapaportFancy.csv"] encoding:NSUTF8StringEncoding error:Nil];
	
    
	[self parseRapaportIntoDictionary];
}
-(void) updateRapaportDataUSINGIDOFROUND:(NSString*)round_file PEARFILE:(NSString*)pear_file {
	
	NSURL *roundURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://diamprice.com/hash/%@.csv",round_file]];
	NSURL *pearsURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://diamprice.com/hash/%@.csv",[pear_file stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
	
   
    NSURLRequest *request = [NSURLRequest requestWithURL:roundURL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"CSV: %@", [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding]);
        roundsCSV = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
        if( roundsCSV == nil ) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error while updating" message:@"There was an error updating from Rapaport. Using old prices." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [self loadRapaportData];
        }
        [roundsCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:@"LatestRapaportRounds.csv"] atomically:NO encoding:NSASCIIStringEncoding error:nil];
        [self parseRapaportIntoDictionary];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Things go boom. %@", [error localizedDescription]);
    }];
    [operation start];

    NSURLRequest *requestf = [NSURLRequest requestWithURL:pearsURL];
    AFHTTPRequestOperation *operationf = [[AFHTTPRequestOperation alloc] initWithRequest:requestf];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operationf, id responseObject) {
        NSLog(@"CSV: %@", [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding]);
        fancyCSV = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
        if( fancyCSV == nil ) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error while updating" message:@"There was an error updating from Rapaport. Using old prices." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [self loadRapaportData];
        }
        [fancyCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:@"LatestRapaportFancy.csv"] atomically:NO encoding:NSASCIIStringEncoding error:nil];
        [self parseRapaportIntoDictionary];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Things go boom. %@", [error localizedDescription]);
    }];
    [operationf start];
    
	
	
	
	
    
	
}
-(void) updateRapaportDataUSINGID:(NSString*)user_name PASSWORD:(NSString*)user_password{
    
	NSString *roundURL = @"https://technet.rapaport.com/HTTP/Prices/CSV2_Round.aspx";
	NSString *pearsURL = @"https://technet.rapaport.com/HTTP/Prices/CSV2_Pear.aspx";
	NSString *requestString = [NSString stringWithFormat:@"username=%@&password=%@",user_name,user_password];
    
    NSURL *url = [NSURL URLWithString:@"https://technet.rapaport.com/HTTP/Prices/CSV2_Round.aspx"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            user_name, @"username",
                            user_password, @"password",
                            nil];
    [httpClient postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
    }];
    
    
    
   
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	NSData *myRequestData = [ NSData dataWithBytes: [ requestString UTF8String ] length: [ requestString length ] ];

	
	NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString:roundURL ]];
	
	
	[request setHTTPMethod: @"POST" ];
	[request setHTTPBody: myRequestData ];
	NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	NSString *response=[[NSString alloc]initWithData:returnData encoding:NSASCIIStringEncoding];
    

	
	roundsCSV =[[NSString alloc]initWithString:response];
    
	request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString:pearsURL ]];
	[request setHTTPMethod: @"POST" ];
	[request setHTTPBody: myRequestData ];
	returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	response=[[NSString alloc]initWithData:returnData encoding:NSASCIIStringEncoding];
	
	fancyCSV = [[NSString alloc] initWithString:response];
	
	app.networkActivityIndicatorVisible=NO;
	
	if( roundsCSV == nil || fancyCSV == nil ) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error while updating" message:@"There was an error updating from Rapaport. Using old prices." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
		[self loadRapaportData];
	}
	
	[roundsCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:@"LatestRapaportRounds.csv"] atomically:NO encoding:NSASCIIStringEncoding error:nil];
	[fancyCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:@"LatestRapaportFancy.csv"] atomically:NO encoding:NSASCIIStringEncoding error:nil];
	
	[self parseRapaportIntoDictionary];
    
}
-(void) parseRapaportIntoDictionary {
	{
	
		
		rapaportRounds = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *weightValues;
		NSArray *csvLines = [roundsCSV componentsSeparatedByString:@"\n"];
		
		for(int i=0;i<[csvLines count]-1;i++) {
			NSString *line = [csvLines objectAtIndex:i];
			
			NSArray *csvComponents = [line componentsSeparatedByString:@","];
			NSString *thisKey = [[NSString alloc] initWithFormat:@"%@,%@", [csvComponents objectAtIndex:1], [csvComponents objectAtIndex:2]];
			CGPoint thisWeight = CGPointMake([[csvComponents objectAtIndex:3] floatValue], [[csvComponents objectAtIndex:4] floatValue]);
			
			weightValues = [rapaportRounds objectForKey:thisKey];
			if( !weightValues ) {
                //	NSLog(@"!weightValues");
				weightValues = [[NSMutableDictionary alloc] init];
			}
			
			[weightValues setObject:[csvComponents objectAtIndex:5] forKey:[NSValue valueWithCGPoint:thisWeight]];
			//NSLog(@"setObject %@, %@",[csvComponents objectAtIndex:5],[NSValue valueWithCGPoint:thisWeight]);
            
			[rapaportRounds setObject:weightValues forKey:thisKey];
            

		}
	}
	{
		
		rapaportFancy = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *weightValues;
		
		NSArray *csvLines = [fancyCSV componentsSeparatedByString:@"\n"];
		
		for(int i=0;i<[csvLines count]-1;i++) {
			NSString *line = [csvLines objectAtIndex:i];
            
			NSArray *csvComponents = [line componentsSeparatedByString:@","];
			NSString *thisKey = [[NSString alloc] initWithFormat:@"%@,%@", [csvComponents objectAtIndex:1], [csvComponents objectAtIndex:2]];
			CGPoint thisWeight = CGPointMake([[csvComponents objectAtIndex:3] floatValue], [[csvComponents objectAtIndex:4] floatValue]);
            
			weightValues = [rapaportFancy objectForKey:thisKey];
			if( !weightValues ) {
				weightValues = [[NSMutableDictionary alloc] init];
			}
            
			[weightValues setObject:[csvComponents objectAtIndex:5] forKey:[NSValue valueWithCGPoint:thisWeight]];
			[rapaportFancy setObject:weightValues forKey:thisKey];
		}
	}	
}
-(float) rapaportPriceForWeight:(float)weight Cut:(NSString*)cut Color:(NSString*)color Clarity:(NSString*)clarity {
	
	NSDictionary *thisDictionary;
	if( [cut isEqualToString:@"BR"] ) {
		thisDictionary = rapaportRounds;
	}
	else {
		thisDictionary = rapaportFancy;
	}
	if ([color isEqualToString:@"N"]) {
		color = @"M";
	}
	NSString *thisKey = [[NSString alloc] initWithFormat:@"%@,%@", clarity, color];
	NSDictionary *weightValues = [thisDictionary objectForKey:thisKey];

	if( !weightValues) {
		//NSLog(@"not found");
		return -1;
	}
    
	for (NSValue *weightKey in weightValues) {
		CGPoint thisWeight;
		[weightKey getValue:&thisWeight];
		if( weight >= thisWeight.x && weight <= thisWeight.y ) {
            //	NSLog(@"Ans: %@", [weightValues objectForKey:weightKey]);
			return [[weightValues objectForKey:weightKey] floatValue];
		}
	}
    
	//NSLog(@"not found");
	return -1;
}
#pragma mark -
#pragma mark Utils
-(NSUInteger)currentDayFromStartOfYear{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"Dyyyy"];
	NSUInteger dayOfYear = [[formatter stringFromDate:[NSDate date]] intValue];
	return dayOfYear;
}
@end
