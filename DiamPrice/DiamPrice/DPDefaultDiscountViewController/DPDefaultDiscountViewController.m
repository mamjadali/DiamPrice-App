//
//  DPDefaultDiscountViewController.m
//  DiamPrice
//
//  Created by Ch Burhan Ahmad on 1/21/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import "DPDefaultDiscountViewController.h"
#import "MJSharedClient.h"
@interface DPDefaultDiscountViewController ()
@property (nonatomic, retain) NSMutableArray *values;
@end

@implementation DPDefaultDiscountViewController

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
   
	int selectedIndex = (-1)*[[MJSharedClient sharedInstance].defaultDiscount intValue];
	
	self.values = [[NSMutableArray alloc ]init];
	for(int i=80;i>0;i--)
		[self.values addObject:[NSString stringWithFormat:@"+%d%%",i]];
	
	[self.values addObject:[NSString stringWithFormat:@"%d%%",0]];
	
	for(int i=1;i<=80;i++)
		[self.values addObject:[NSString stringWithFormat:@"-%d%%",i]];
	[self.pickerView reloadComponent:0];
	[self.pickerView selectRow:80+selectedIndex inComponent:0 animated:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.values count];
	
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSLog(@"%@",self.values);
	return [self.values objectAtIndex:row];
}

- (IBAction)doneButtonPressed:(id)sender {
    NSUserDefaults *currencyDef = [NSUserDefaults standardUserDefaults];
    int row = [self.pickerView selectedRowInComponent:0];
    [MJSharedClient sharedInstance].defaultDiscount = [NSNumber numberWithInt:[[self.values objectAtIndex:row] intValue]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateViewWithNewDiscount" object:nil];
    
    NSLog(@"Default discount is %i", [[MJSharedClient sharedInstance].defaultDiscount intValue]);
    
    [currencyDef setValue:[MJSharedClient sharedInstance].defaultDiscount forKey:@"defaultDiscount"];
    [currencyDef synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", [[MJSharedClient sharedInstance].defaultDiscount intValue]] forKey:@"discount"];
    
    NSLog(@"defaultDiscount is %i", [[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultDiscount"] intValue]);
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];

}

@end
