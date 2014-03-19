//
//  MJChangeCurrencyViewController.m
//  MyJeweler
//
//  Created by Ch Burhan Ahmad on 1/12/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import "MJChangeCurrencyViewController.h"
#import "MJWebServiceClient.h"
#import "MJSharedClient.h"
#import "CustomView.h"

@interface MJChangeCurrencyViewController ()

@end

@implementation MJChangeCurrencyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark -
#pragma mark pickerView delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [[MJWebServiceClient sharedInstance].currencyNames count];
	
}



//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//	return [[MJWebServiceClient sharedInstance].currencyNames objectAtIndex:row];
//}


-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UIView *customView = [[UIView alloc] init];
    CustomView *test = [self.imagesArray objectAtIndex:row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(170, 5, 120, 18)];
    label.text = test.title;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.gif",test.title]]];
    imageView.frame = CGRectMake(130, 2, 30, 24);
    
    [customView addSubview:imageView];
    [customView addSubview:label];
    
    
	return customView;

}


-(void) okButtonPressed {
	int row = [self.pickerView selectedRowInComponent:0];
	NSLog(@"row is %i",row);
	[MJSharedClient sharedInstance].selectedCurrency = [[MJWebServiceClient sharedInstance].currencyNames objectAtIndex:row];
	float multi = 1/([[[MJWebServiceClient sharedInstance].currencyRates objectAtIndex:1] floatValue]/[[[MJWebServiceClient sharedInstance].currencyRates objectAtIndex:row] floatValue]);
	if (row == 1)
		multi = 1;
	
	[MJSharedClient sharedInstance].selectedCurrencyMultiplier = [NSNumber numberWithFloat:multi];
	[MJSharedClient sharedInstance].isManualCurrencyEnabled = NO;
    [[NSUserDefaults standardUserDefaults] setObject:[MJSharedClient sharedInstance].selectedCurrency forKey:@"selectedCurrency"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateViewWithNewCurrency" object:nil];
    [self dismissViewControllerAnimated:YES completion:Nil];

	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
	
	NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    NSLog(@"names %@",[MJWebServiceClient sharedInstance]);
    NSLog(@"names %@",[MJWebServiceClient sharedInstance].currencyNames);
      NSLog(@"names %lu",[[MJWebServiceClient sharedInstance].currencyNames count]);
	for (NSString *name in [MJWebServiceClient sharedInstance].currencyNames) {
		CustomView *oneFlag = [[CustomView alloc] initWithFrame:CGRectZero];
		oneFlag.title = name;
        
		oneFlag.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.gif",name]];
		[viewArray addObject:oneFlag];
		
	}
	self.imagesArray = viewArray;
	
}



- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"names %lu",[[MJWebServiceClient sharedInstance].currencyNames count]);
    NSLog(@"selected currency =%@",[MJSharedClient sharedInstance].selectedCurrency);
    int selectedIndex = [[MJWebServiceClient sharedInstance].currencyNames indexOfObject:[MJSharedClient sharedInstance].selectedCurrency];
	
	[self.pickerView selectRow:selectedIndex inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self okButtonPressed];
}


- (IBAction)cancelButtonPressed:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{[self dismissViewControllerAnimated:YES completion:Nil];
	}
	else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (IBAction)doneButtonPressed:(id)sender {
    [self okButtonPressed];
}


@end
