//
//  MJSettingsViewController.m
//  MyJeweler
//
//  Created by Ch Burhan Ahmad on 12/25/13.
//  Copyright (c) 2013 MaavraTech. All rights reserved.
//

#import "MJSettingsViewController.h"
#import "MJSharedClient.h"
#import "MJWebServiceClient.h"
@interface MJSettingsViewController ()

@end

@implementation MJSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    [self.changeCurrencyButton setTitle:[MJSharedClient sharedInstance].selectedCurrency forState:UIControlStateNormal];
    [self.defaultDiscountButton setTitle:[[[MJSharedClient sharedInstance].defaultDiscount stringValue] stringByAppendingString:@"%"] forState:UIControlStateNormal];
    
    
    //********************//

    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //    manuallyAddCurrency.text = [def valueForKey:@"mselectedCurrencyMultiplier"];
    if([[def valueForKey:@"currency"] isEqualToString:@"manual"])
    {
        [MJSharedClient sharedInstance].selectedCurrency = [def valueForKey:@"mselectedCurrency"];
        [MJSharedClient sharedInstance].selectedCurrencyMultiplier = [def valueForKey:@"mselectedCurrencyMultiplier"];
        self.manualCurrencyTextField.text = [[def valueForKey:@"mselectedCurrencyMultiplier"] stringValue];
        self.autoButton.selected = NO;
        self.manualButton.selected = YES;
        self.manualCurrencyTextField.hidden = NO;
        self.changeCurrencyButton.hidden = YES;
    }
    else if([[def objectForKey:@"currency"] isEqualToString:@"auto"])
    {
//        [MJSharedClient sharedInstance].selectedCurrency = [def valueForKey:@"selectedCurrency"];
//        [MJSharedClient sharedInstance].selectedCurrencyMultiplier = [def valueForKey:@"selectedCurrencyMultiplier"];
//        NSLog(@"mselectedCurrencyMultiplier: %@",[[def valueForKey:@"mselectedCurrencyMultiplier"] stringValue]);
//        self.manualCurrencyTextField.text = [[def valueForKey:@"mselectedCurrencyMultiplier"] stringValue];
        self.autoButton.selected = YES;
        self.manualButton.selected = NO;
        self.manualCurrencyTextField.hidden = YES;
        self.changeCurrencyButton.hidden = NO;
    }
    else
    {
        self.autoButton.selected = YES;
        self.manualButton.selected = NO;
        self.manualCurrencyTextField.hidden = YES;
        self.changeCurrencyButton.hidden = NO;
    }
    
    [def synchronize];
}
-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if([alertView.title isEqualToString:@"Factory Settings"])
	{
		if(buttonIndex!=[alertView cancelButtonIndex])
		{
			NSLog(@"factory settings");
			[[MJSharedClient sharedInstance].myCollection removeAllObjects];
			[MJSharedClient sharedInstance].totalCollectionPrice=0;
			[MJSharedClient sharedInstance].isidex=YES;
			[MJSharedClient sharedInstance].priceSource=@"IDEX";
			[MJSharedClient sharedInstance].selectedCurrency = @"USD";
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def removeObjectForKey:@"currency"];
            [def removeObjectForKey:@"mselectedCurrency"];
            [def removeObjectForKey:@"mselectedCurrencyMultiplier"];
            [def removeObjectForKey:@"selectedCurrency"];
            [def removeObjectForKey:@"selectedCurrencyMultiplier"];
            [def synchronize];
            
			[MJSharedClient sharedInstance].defaultDiscount = [NSNumber numberWithFloat:0];
			[MJSharedClient sharedInstance].selectedCurrencyMultiplier = [NSNumber numberWithFloat:1];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"updateViewWithNewCurrency" object:nil];
			
			
		}
	}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeCurrencyButtonPressed:(id)sender {
//    [self.manualCurrencyTextField resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setValue:@"auto" forKey:@"currency"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)refreshButtonPressed:(id)sender {
    [[MJWebServiceClient sharedInstance] loadCurrencyExchange];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateViewWithNewCurrency" object:nil];
    [self.manualCurrencyTextField resignFirstResponder];
}

- (IBAction)autoButtonPressed:(id)sender {
    self.changeCurrencyButton.hidden = NO;
    self.manualCurrencyTextField.hidden = YES;
    self.autoButton.selected = YES;
    self.manualButton.selected = NO;
    [self.manualCurrencyTextField resignFirstResponder];

    
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        NSLog(@"%f", [[def valueForKey:@"selectedCurrencyMultiplier"] floatValue]);
        
        if([def valueForKey:@"selectedCurrencyMultiplier"])
        {
            [MJSharedClient sharedInstance].selectedCurrency = [def valueForKey:@"selectedCurrency"];
            [MJSharedClient sharedInstance].selectedCurrencyMultiplier = [def valueForKey:@"selectedCurrencyMultiplier"];
        }
        else if([[MJSharedClient sharedInstance].selectedCurrency length] == 0 || ([[MJSharedClient sharedInstance].selectedCurrency isEqualToString:@"manual"]))
        {
            [def setValue:@"USD" forKey:@"selectedCurrency"];
            [def setValue:[NSNumber numberWithInt:1] forKey:@"selectedCurrencyMultiplier"];
            
            [MJSharedClient sharedInstance].selectedCurrency = [def valueForKey:@"selectedCurrency"];
            [MJSharedClient sharedInstance].selectedCurrencyMultiplier = [def valueForKey:@"selectedCurrencyMultiplier"];
        }
        
        [def setObject:@"auto" forKey:@"currency"];
        [def synchronize];
        NSLog(@"selectedCurrency: %@ && multiplier:%@", [MJSharedClient sharedInstance].selectedCurrency, [MJSharedClient sharedInstance].selectedCurrencyMultiplier);

    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateViewWithNewCurrency" object:nil];
    [def synchronize];
}
- (IBAction)discountLabelPressed:(id)sender {
    [self.manualCurrencyTextField resignFirstResponder];
}

- (IBAction)idexBUttonPressed:(id)sender {
    [self.manualCurrencyTextField resignFirstResponder];
}

- (IBAction)aboutButtonPressed:(id)sender {
    [self.manualCurrencyTextField resignFirstResponder];
}

- (IBAction)clearAllDataButtonPressed:(id)sender {
    [self.manualCurrencyTextField resignFirstResponder];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Factory Settings" message:@"Are you sure you want to clear all data and reset all settings." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
	[alertView show];
}

- (void) addCurrencyManually
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    
    if([self.manualCurrencyTextField.text length] == 0)
    {
        [def setValue:@"manual" forKey:@"currency"];
        [def setValue:[NSNumber numberWithInt:0] forKey:@"mselectedCurrencyMultiplier"];
        [MJSharedClient sharedInstance].selectedCurrency = @"manual";
        [MJSharedClient sharedInstance].selectedCurrencyMultiplier = 0;
        return;
    }
    
    float multi = [self.manualCurrencyTextField.text floatValue];
    [MJSharedClient sharedInstance].selectedCurrencyMultiplier = [NSNumber numberWithFloat:multi];
    
    [def setValue:[MJSharedClient sharedInstance].selectedCurrencyMultiplier forKey:@"mselectedCurrencyMultiplier"];
    [def synchronize];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateViewWithNewCurrency" object:nil];
    self.manualCurrencyTextField.text = [[MJSharedClient sharedInstance].selectedCurrencyMultiplier stringValue];
}
- (IBAction)manualButtonPressed:(id)sender {
    self.changeCurrencyButton.hidden = YES;
    self.manualCurrencyTextField.hidden = NO;
    self.autoButton.selected = NO;
    self.manualButton.selected = YES;

        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setValue:@"manual" forKey:@"currency"];
        [def synchronize];
        
        [self addCurrencyManually];
        
        if((![MJSharedClient sharedInstance].selectedCurrency) && ([MJSharedClient sharedInstance].selectedCurrencyMultiplier != 0))
        {
            [def setValue:[MJSharedClient sharedInstance].selectedCurrency forKey:@"mselectedCurrency"];
            [def setValue:[MJSharedClient sharedInstance].selectedCurrencyMultiplier forKey:@"mselectedCurrencyMultiplier"];
        }
        [MJSharedClient sharedInstance].selectedCurrency = @"manual";
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateViewWithNewCurrency" object:nil];
        
        NSLog(@"mselectedCurrency: %@ && mmultiplier:%@", [MJSharedClient sharedInstance].selectedCurrency, [MJSharedClient sharedInstance].selectedCurrencyMultiplier);
 
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateViewWithNewCurrency" object:nil];
    [def synchronize];

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
//    self.manualCurrencyTextField.text = [[MJSharedClient sharedInstance].selectedCurrencyMultiplier stringValue];
    [self addCurrencyManually];
}
@end
