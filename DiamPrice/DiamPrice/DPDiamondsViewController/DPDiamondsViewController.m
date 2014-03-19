//
//  DPDiamondsViewController.m
//  DiamPrice
//
//  Created by Ch Burhan Ahmad on 1/14/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import "DPDiamondsViewController.h"
#import "MJSharedClient.h"
#import "MJWebServiceClient.h"
@interface DPDiamondsViewController ()
@property (nonatomic ,assign) BOOL isWeightEnabled,isQuantityEnabled,isPoint,tick;
@property (nonatomic ,retain) NSTimer *timer;

@end

@implementation DPDiamondsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)updateViewWithDiscount {
	if (![MJSharedClient sharedInstance].isEditDiamondFromCollection){
		int selectRow = (-1)*[[MJSharedClient sharedInstance].defaultDiscount intValue];
		[self.pickerView selectRow:selectRow+80 inComponent:3 animated:YES];
		discountString= [discountList objectAtIndex:selectRow+80];
		[self refreshPrice];
	}
}
-(void)viewDidAppear:(BOOL)animated {
	self.flagImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.gif",[MJSharedClient sharedInstance].selectedCurrency]];
    
	if([MJSharedClient sharedInstance].isEditDiamondFromCollection)
	{
		[self.saveButton setHidden:NO];
		[self.cancelButton setHidden:NO];
		[self.addToCollectionButton setHidden:YES];
		[self.pickerView selectRow:[cutList indexOfObject:[MJSharedClient sharedInstance].editableDiamond.cut] inComponent:0 animated:YES];
        self.pickerView.tintColor = [UIColor whiteColor];
		cutString=[MJSharedClient sharedInstance].editableDiamond.cut;
		[self.pickerView selectRow:[colorList indexOfObject:[MJSharedClient sharedInstance].editableDiamond.color] inComponent:1 animated:YES];
		colorString=[MJSharedClient sharedInstance].editableDiamond.color;
		[self.pickerView selectRow:[clarityList indexOfObject:[MJSharedClient sharedInstance].editableDiamond.clarity] inComponent:2 animated:YES];
		clarityString=[MJSharedClient sharedInstance].editableDiamond.clarity;
		int selectRow = 80+(-1)*[[MJSharedClient sharedInstance].editableDiamond.discount intValue];
		[self.pickerView selectRow:selectRow inComponent:3 animated:YES];
		discountString= [discountList objectAtIndex:selectRow];
		[self.caratTextField setText:[ NSString stringWithFormat:@"%@ ",[[MJSharedClient sharedInstance].editableDiamond.weight stringValue]]];
        
//		[[NSString alloc] initWithString:[discountList objectAtIndex:[[MJSharedClient sharedInstance].editableDiamond.discount intValue]+80]];
//		[self.quantityTextField setText:[[MJSharedClient sharedInstance].editableDiamond.quantity stringValue]];
	}
	else
	{
		[self.saveButton setHidden:YES];
		[self.cancelButton setHidden:YES];
		[self.addToCollectionButton setHidden:NO];
        
	}
	
	
	[self refreshPrice];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewWithDiscount) name:@"updateViewWithNewDiscount" object:nil];
    self.tick=NO;
	self.isWeightEnabled=NO;
	self.isQuantityEnabled=NO;
    self.isPoint=NO;
    [self setPickerInputValues];
    [self initialZeroPrice];
    
}
-(void)setPickerInputValues{
    cutList = [[NSArray alloc] initWithObjects:@"BR", @"PS", @"PR", @"RAD", @"AC", @"EM", @"MQ", @"BAG", @"HS", @"CU", @"TRI", @"OV", nil];
	colorList = [[NSArray alloc] initWithObjects:@"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M",@"N", nil];
	clarityList = [[NSArray alloc] initWithObjects:@"IF", @"VVS1", @"VVS2", @"VS1", @"VS2", @"SI1", @"SI2",@"SI3", @"I1",@"I2", @"I3", nil];
 	discountList=[[NSMutableArray alloc]init];
	for(int i=80;i>0;i--)
		[discountList addObject:[[NSString stringWithFormat:@"+%d",i] stringByAppendingString:@"%"]];
	[discountList addObject:[[NSString stringWithFormat:@"%d",0] stringByAppendingString:@"%"]];
	for(int i=1;i<=80;i++)
		[discountList addObject:[[NSString stringWithFormat:@"-%d",i] stringByAppendingString:@"%"]];
	self.pickerView.transform=CGAffineTransformMakeScale(1.0, 0.7);
	cutString = [cutList objectAtIndex:0];
	colorString = [colorList objectAtIndex:0];
	clarityString = [clarityList objectAtIndex:0];
	discountString = [discountList objectAtIndex:100];
}

#pragma mark -
#pragma mark PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 4;
}
- (NSInteger)pickerView: (UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger) component  {
	if( component == 0 ) {
		return [cutList count];
	}
	else if( component == 1 ) {
		return [colorList count];
	}
	else if(component == 2 )  {
		return [clarityList count];
	}
	else  {
		return [discountList count];
	}
	
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	if( component == 0 ) {
		return 80;
	}
	else if(component==1) {
		return 50;
	}
	else if(component==2) {
		return 80;
	}
	else  {
		return 80;
	}
	
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *title;
    if( component == 0 ) {
		title= [cutList objectAtIndex:row];
	}
	else if( component == 1 ) {
		title= [colorList objectAtIndex:row];
	}
	else if( component == 2 ) {
		title= [clarityList objectAtIndex:row];
	}
	else  {
		title= [discountList objectAtIndex:row];
	}
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

- (void)pickerView:(UIPickerView *)aPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if( component == 0 ) {
		cutString= [cutList objectAtIndex:row];
	}
	else if( component == 1 ) {
		colorString= [colorList objectAtIndex:row];
	}
	else if( component == 2 ) {
		clarityString= [clarityList objectAtIndex:row];
	}
	else  {
		discountString= [discountList objectAtIndex:row];
	}
	[self refreshPrice];
}

#pragma mark -
-(void) refreshPrice {
   	[self updatePickerValues];
	float weight=[self.caratTextField.text floatValue];
	float user_weight=[self.caratTextField.text floatValue];
	
	float qty=1;
	float dis=[discountString floatValue];
	float pr=0,ppr=0;
	if([self.caratTextField.text floatValue]<0.18 &&!(![MJSharedClient sharedInstance].isidex &&[cutString isEqualToString:@"BR"]))
	{
		weight=0.18;
	}
	else if([self.caratTextField.text floatValue]<0.01 &&(![MJSharedClient sharedInstance].isidex &&[cutString isEqualToString:@"BR"]))
	{
		weight=0.01;
	}
	else if([self.caratTextField.text floatValue]>10.99&&![MJSharedClient sharedInstance].isidex)
	{
		weight=10.99;
	}
	else if([self.caratTextField.text floatValue]>5.99&&!([self.caratTextField.text floatValue]>=10.00&&[self.caratTextField.text floatValue]<=10.99))
	{
		weight=5.99;
	}
	else if([self.caratTextField.text floatValue]>5.99&&[MJSharedClient sharedInstance].isidex)
	{
		weight=5.99;
	}
	if([MJSharedClient sharedInstance].isidex)
	{
		ppr=[[MJWebServiceClient sharedInstance] idexPriceForWeight:weight Cut:cutString Color:colorString Clarity:clarityString]*[[MJSharedClient sharedInstance].selectedCurrencyMultiplier floatValue];
		pr=ppr*qty*user_weight;
		NSLog(@"weight is %f is idex %f",weight,pr);
	}
	else {
		ppr=[[MJWebServiceClient sharedInstance] rapaportPriceForWeight:weight Cut:cutString Color:colorString Clarity:clarityString]*[[MJSharedClient sharedInstance].selectedCurrencyMultiplier floatValue];
		pr=ppr*qty*user_weight;
		NSLog(@"is RapNet %f",pr);
	}
	float disprice=(pr)+(pr*dis/100);
	float disppr=(ppr)+(ppr*dis/100);
    // Add manual rate values
    pr = [MJSharedClient sharedInstance].isManualCurrencyEnabled?pr*[MJSharedClient sharedInstance].manualCurrencyRate:pr;
    ppr = [MJSharedClient sharedInstance].isManualCurrencyEnabled?ppr*[MJSharedClient sharedInstance].manualCurrencyRate:ppr;
    disppr = [MJSharedClient sharedInstance].isManualCurrencyEnabled?disppr*[MJSharedClient sharedInstance].manualCurrencyRate:disppr;
    disprice = [MJSharedClient sharedInstance].isManualCurrencyEnabled?disprice*[MJSharedClient sharedInstance].manualCurrencyRate:disprice;
	[MJSharedClient sharedInstance].currentPriceValue=[NSNumber numberWithFloat:pr];
	[MJSharedClient sharedInstance].currentDiamondPrice=[NSNumber numberWithFloat:pr];
	[MJSharedClient sharedInstance].currentDiamondDiscountPrice=[NSNumber numberWithFloat:disprice];
	[MJSharedClient sharedInstance].currentDiamondPricePerCarat=[NSNumber numberWithFloat:ppr];
	[self fillWebViewDigits:self.diamondPriceLabel VALUE:pr];
	[self fillWebViewDigits:self.pricePerCaratLabel VALUE:ppr];
	[self fillWebViewDigits:self.pricePerCaratDiscountLabel VALUE:disppr];
	[self fillWebViewDigits:self.discountPriceLabel VALUE:disprice];
}
-(IBAction) initialZeroPrice {
	self.caratTextField.text=@"1 ";
	self.quantityTextField.text=@"1 ";
	self.isPoint=NO;
	int selectRow = (-1)*[[MJSharedClient sharedInstance].diamondDiscount intValue];
	[self.pickerView selectRow:selectRow+80 inComponent:3 animated:YES];
	[self.pickerView selectRow:0 inComponent:0 animated:YES];
	[self.pickerView selectRow:0 inComponent:1 animated:YES];
	[self.pickerView selectRow:0 inComponent:2 animated:YES];
	cutString= [cutList objectAtIndex:0];
	colorString= [colorList objectAtIndex:0];
	clarityString= [clarityList objectAtIndex:0];
	discountString= [discountList objectAtIndex:selectRow+80];
	[self refreshPrice];
}
-(void)updatePickerValues {
	cutString = [cutList objectAtIndex:[self.pickerView selectedRowInComponent:0]];
	colorString = [colorList objectAtIndex:[self.pickerView selectedRowInComponent:1]];
	clarityString = [clarityList objectAtIndex:[self.pickerView selectedRowInComponent:2]];
	discountString = [discountList objectAtIndex:[self.pickerView selectedRowInComponent:3]];
}

-(void)fillWebViewDigits:(UILabel *)webView VALUE:(float)value {
	NSString *priceString=[[NSString alloc]initWithFormat:@"%.2f",value];
	NSMutableString *labelText = [[NSMutableString alloc] init];
	int firstComma=[priceString length]%3;
	for(int i=0;i<[priceString length];i++)
	{
		if(i==firstComma)
		{
			if(i!=0&&i!=[priceString length]-3)
			{
				labelText = (NSMutableString*)[labelText stringByAppendingString:@","];
			}
			firstComma=firstComma+3;
		}
		char ch=[priceString characterAtIndex:i];
		labelText = (NSMutableString*)[labelText stringByAppendingFormat:@"%c",ch];
	}
	webView.text = labelText;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)caratButtonPressed:(id)sender {
    self.isQuantityEnabled=NO;
	self.isWeightEnabled=YES;
	[self.weightButton setEnabled:NO];
	[self.quantityButton setEnabled:YES];
	[self.timer invalidate];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:(0.5) target:self selector:@selector(tickTack) userInfo:nil repeats:YES];
	[self.quantityTextField setText:[self.quantityTextField.text stringByReplacingOccurrencesOfString:@"|" withString:@" "]];
	[self refreshPrice];
	/*
     AlertPrompt *prompt = [AlertPrompt alloc];
     prompt = [prompt initWithTitle:@"Enter Weight" message:@"Enter Weight" defaultText:caratTextField.text  delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"OK"];
     [prompt setTag:93];
     [prompt show];
     [prompt release];
	 */
    
}
- (IBAction)quantityButtonPressed:(id)sender {
    self.isQuantityEnabled=YES;
	self.isWeightEnabled=NO;
    
	[self.timer invalidate];
	[self.caratTextField setText:[self.caratTextField.text stringByReplacingOccurrencesOfString:@"|" withString:@" "]];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:(0.5) target:self selector:@selector(tickTack) userInfo:nil repeats:YES];
    
	[self.weightButton setEnabled:YES];
	[self.quantityButton setEnabled:NO];
    
	[self refreshPrice];
}

- (IBAction)numberButtonPressed:(id)sender {
    if(self.isWeightEnabled)
	{
        [self.caratTextField setText:[self.caratTextField.text stringByReplacingOccurrencesOfString:@"|" withString:@""]];
        [self.caratTextField setText:[self.caratTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
		self.isQuantityEnabled = NO;
		if([sender tag]==11 && !self.isPoint)
		{
			[self.caratTextField setText:[NSString stringWithFormat:@"%@.",self.caratTextField.text]];
			self.isPoint=YES;
		}
		else if([sender tag]==0&&[self.caratTextField.text isEqualToString:@"0"])
			;
		else if([self.caratTextField.text isEqualToString:@"0"]&&[sender tag]!=12)
			[self.caratTextField setText:[NSString stringWithFormat:@"%ld",[sender tag]]];
		else if([sender tag]!=11&&[sender tag]!=12)
			[self.caratTextField setText:[NSString stringWithFormat:@"%@%ld",self.caratTextField.text,[sender tag]]];
		else if([sender tag]==12&&![self.caratTextField.text isEqualToString:@""])
        {
            if([self.caratTextField.text characterAtIndex:[self.caratTextField.text length]-1]=='.')
                self.isPoint=NO;
            [self.caratTextField setText:[NSString stringWithFormat:@"%@",[self.caratTextField.text substringToIndex:[self.caratTextField.text length]-1]]];
        }
		[self.caratTextField setText:[self.caratTextField.text stringByAppendingString:@" "]];
		
	}
	else if(self.isQuantityEnabled)
	{
		self.isWeightEnabled=NO;
		[self.quantityTextField setText:[self.quantityTextField.text stringByReplacingOccurrencesOfString:@"|" withString:@""]];
		[self.quantityTextField setText:[self.quantityTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
		if([sender tag]==0&&[self.quantityTextField.text isEqualToString:@"0"])
			;
		else if([self.quantityTextField.text isEqualToString:@"0"]&&[sender tag]!=12)
			[self.quantityTextField setText:[NSString stringWithFormat:@"%ld",[sender tag]]];
		else if([sender tag]!=11&&[sender tag]!=12)
			[self.quantityTextField setText:[NSString stringWithFormat:@"%@%ld",self.quantityTextField.text,[sender tag]]];
		else if([sender tag]==12&&![self.quantityTextField.text isEqualToString:@""])
		{
			NSLog(@"quantity text : %@",self.quantityTextField.text);
			[self.quantityTextField setText:[NSString stringWithFormat:@"%@",[self.quantityTextField.text substringToIndex:[self.quantityTextField.text length]-1]]];
		}
		[self.quantityTextField setText:[self.quantityTextField.text stringByAppendingString:@" "]];
	}
	
	[self refreshPrice];
}
-(void) tickTack
{
	if(self.isWeightEnabled)
	{
		if(!self.tick)
		{
			[self.caratTextField setText:[NSString stringWithFormat:@"%@|",[self.caratTextField.text substringToIndex:[self.caratTextField.text length]-1]]];
			self.tick=YES;
		}
		else
		{
			[self.caratTextField setText:[NSString stringWithFormat:@"%@ ",[self.caratTextField.text substringToIndex:[self.caratTextField.text length]-1]]];
			self.tick=NO;
		}
	}
	else if(self.isQuantityEnabled)
	{
		if(!self.tick)
		{
			[self.quantityTextField setText:[NSString stringWithFormat:@"%@|",[self.quantityTextField.text substringToIndex:[self.quantityTextField.text length]-1]]];
			self.tick=YES;
		}
		else
		{
			[self.quantityTextField setText:[NSString stringWithFormat:@"%@ ",[self.quantityTextField.text substringToIndex:[self.quantityTextField.text length]-1]]];
			self.tick=NO;
		}
		
	}
}

- (IBAction)addToCollectionButtonPressed:(id)sender {
    if(self.isWeightEnabled)
		[self.timer invalidate];
	self.isWeightEnabled=NO;
	[self.caratTextField setText:[self.caratTextField.text stringByReplacingOccurrencesOfString:@"|" withString:@" "]];
	[self.weightButton setEnabled:YES];
	[self.quantityButton setEnabled:NO];
    if ([self.caratTextField.text floatValue]>0) {
        [self refreshPrice];
        
        NSLog(@"diammmm");
        
        Diamond *dmn=[[Diamond alloc]initwithNAME:@"Diamond" WEIGHT:[NSNumber numberWithFloat:[self.caratTextField.text floatValue]] QUANTITY:[NSNumber numberWithInt:1] PRICE:[MJSharedClient sharedInstance].currentDiamondPrice CUT:cutString COLOR:colorString CLARITY:clarityString DISCOUNT:[NSNumber numberWithFloat:[discountString floatValue]] DISCOUNTPRICE:[MJSharedClient sharedInstance].currentDiamondDiscountPrice PRICEPERCARAT:[MJSharedClient sharedInstance].currentDiamondPricePerCarat];
        
        [[MJSharedClient sharedInstance].myCollection addObject:dmn];
        
        
        
        [MJSharedClient sharedInstance].totalCollectionPrice=[NSNumber numberWithFloat:[[MJSharedClient sharedInstance].currentDiamondDiscountPrice floatValue]  + [[MJSharedClient sharedInstance].totalCollectionPrice floatValue]];
        [self.tabBarController setSelectedIndex:1];
        [self initialZeroPrice];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Please Add Weight" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    if([MJSharedClient sharedInstance].isEditDiamondFromCollection)
	{
        
        if ([self.caratTextField.text floatValue]>0) {

            [MJSharedClient sharedInstance].totalCollectionPrice=[NSNumber numberWithFloat:[[MJSharedClient sharedInstance].totalCollectionPrice floatValue] -[[MJSharedClient sharedInstance].editableDiamond.discountPrice floatValue]];
            Diamond *dmn=[[Diamond alloc]initwithNAME:@"Diamond" WEIGHT:[NSNumber numberWithFloat:[self.caratTextField.text floatValue]] QUANTITY:[NSNumber numberWithInt:1] PRICE:[MJSharedClient sharedInstance].currentDiamondPrice CUT:cutString COLOR:colorString CLARITY:clarityString DISCOUNT:[NSNumber numberWithFloat:[discountString floatValue]] DISCOUNTPRICE:[MJSharedClient sharedInstance].currentDiamondDiscountPrice PRICEPERCARAT:[MJSharedClient sharedInstance].currentDiamondPricePerCarat];
            dmn.image = [MJSharedClient sharedInstance].editableDiamond.image;
            [[MJSharedClient sharedInstance].myCollection removeObject:[MJSharedClient sharedInstance].editableDiamond];
            [[MJSharedClient sharedInstance].myCollection addObject:dmn];
            [MJSharedClient sharedInstance].totalCollectionPrice=[NSNumber numberWithFloat:[[MJSharedClient sharedInstance].currentDiamondDiscountPrice floatValue]  + [[MJSharedClient sharedInstance].totalCollectionPrice floatValue]];
            [self.tabBarController setSelectedIndex:1];
            [self.saveButton setHidden:YES];
            [self.cancelButton setHidden:YES];
            [MJSharedClient sharedInstance].isEditDiamondFromCollection=NO;
            [self initialZeroPrice];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Please Add Weight" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            
        }
        
	}

}
- (IBAction)shapesButtonPressed:(id)sender {
    
}
- (IBAction)infoButtonPressed:(id)sender {
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.saveButton setHidden:YES];
	[self.cancelButton setHidden:YES];
    [self.tabBarController setSelectedIndex:1];
	[MJSharedClient sharedInstance].isEditDiamondFromCollection=NO;
	[self initialZeroPrice];


}

@end
