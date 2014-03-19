//
//  DPRapnetViewController.m
//  DiamPrice
//
//  Created by Ch Burhan Ahmad on 1/21/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import "DPRapnetViewController.h"
#import "MJSharedClient.h"
#import "MJWebServiceClient.h"
#import "AFNetworking.h"
/*
 Username: 73785
 Password: Watch%Oasis
 */
#define DOCFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
@interface DPRapnetViewController ()

@end

@implementation DPRapnetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *) checkRAPNETLoginWITHEMAIL:(NSString *)user_email PASSWORD:(NSString*)user_password {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Authenticating";
    [self.hud show:YES];
    NSURL *url = [NSURL URLWithString:@"https://technet.rapaport.com/HTTP/Authenticate.aspx"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            user_email, @"username",
                            user_password, @"password",
                            nil];
    [httpClient postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", response);
        if(response.length>=128&&response.length<=512)
        {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:self.userName.text forKey:@"RAPusername"];
            [prefs setObject:self.password.text forKey:@"RAPpassword"];
            [prefs synchronize];
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Login Successful" message:@"RapNet pricing downloaded." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//            [alertView show];
            
//            [[MJWebServiceClient sharedInstance] updateRapaportDataUSINGID:self.userName.text PASSWORD:self.password.text ];
            [self loadRapnetRoundPrices];
            
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Login Error" message:@"Wrong UserName or Password" delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alertView show];
            [MJSharedClient sharedInstance].isidex=YES;
            [MJSharedClient sharedInstance].priceSource=@"IDEX";
            [self dismissViewControllerAnimated:YES completion:Nil];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        [self.hud hide:YES];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Login Error" message:@"Wrong UserName or Password" delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
        [MJSharedClient sharedInstance].isidex=YES;
        [MJSharedClient sharedInstance].priceSource=@"IDEX";
        [self dismissViewControllerAnimated:YES completion:Nil];
   }];
    
   
    
    /*
	NSString *requestString = [NSString stringWithFormat:@"username=%@&password=%@",user_email,user_password];
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	NSData *myRequestData = [ NSData dataWithBytes: [ requestString UTF8String ] length: [ requestString length ] ];
	NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString:@"https://technet.rapaport.com/HTTP/Authenticate.aspx" ] ];
	[ request setHTTPMethod: @"POST" ];
	[ request setHTTPBody: myRequestData ];
	NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	NSString *response=[[NSString alloc]initWithData:returnData encoding:NSASCIIStringEncoding];
	app.networkActivityIndicatorVisible = NO;
    
    return response;
     */
    return nil;
}
-(void)loadRapnetRoundPrices{
    self.hud.labelText = @"Updating Prices";
    [self.hud show:YES];
    NSURL *roundURL = [NSURL URLWithString: @"https://technet.rapaport.com/HTTP/Prices/CSV2_Round.aspx"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:roundURL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.userName.text, @"username",
                            self.password.text, @"password",
                            nil];
    [httpClient postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        [MJWebServiceClient sharedInstance].roundsCSV = responseStr;
        [[MJWebServiceClient sharedInstance].roundsCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:@"LatestRapaportRounds.csv"] atomically:NO encoding:NSASCIIStringEncoding error:nil];
        
        [self loadRapnetPearsData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
       [self.hud hide:YES];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error while updating" message:@"There was an error updating from Rapaport. Using old prices." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
      
        [MJSharedClient sharedInstance].isidex=YES;
        [MJSharedClient sharedInstance].priceSource=@"IDEX";
        
        [self dismissViewControllerAnimated:YES completion:Nil];
    }];
	
    
    /*
	if( roundsCSV == nil || fancyCSV == nil ) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error while updating" message:@"There was an error updating from Rapaport. Using old prices." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
		[self loadRapaportData];
	}
	
	
	
    */
}
-(void)loadRapnetPearsData{
    NSURL *pearsURL = [NSURL URLWithString:@"https://technet.rapaport.com/HTTP/Prices/CSV2_Pear.aspx"];
    AFHTTPClient *httpClient1 = [[AFHTTPClient alloc] initWithBaseURL:pearsURL];
    NSDictionary *params1 = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.userName.text, @"username",
                             self.password.text, @"password",
                             nil];
    [httpClient1 postPath:nil parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        [MJWebServiceClient sharedInstance].fancyCSV = responseStr;
        [[MJWebServiceClient sharedInstance].fancyCSV writeToFile:[DOCFOLDER stringByAppendingPathComponent:@"LatestRapaportFancy.csv"] atomically:NO encoding:NSASCIIStringEncoding error:nil];
        [MJSharedClient sharedInstance].isidex=NO;
        [MJSharedClient sharedInstance].priceSource=@"RAPNET";
        [[MJWebServiceClient sharedInstance] parseRapaportIntoDictionary];
        [self.hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.hud hide:YES];
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error while updating" message:@"There was an error updating from Rapaport. Using old prices." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [MJSharedClient sharedInstance].isidex=YES;
        [MJSharedClient sharedInstance].priceSource=@"IDEX";
		[[MJWebServiceClient sharedInstance] loadRapaportData];
       
        [self dismissViewControllerAnimated:YES completion:Nil];
        
    }];
}
- (IBAction)doneButtonPressed:(id)sender {
    NSString *response=[self checkRAPNETLoginWITHEMAIL:self.userName.text PASSWORD:self.password.text];
    
}
- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
