//
//  DPCollectionViewController.m
//  DiamPrice
//
//  Created by Ch Burhan Ahmad on 1/15/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import "DPCollectionViewController.h"
#import "DPCollectionViewCell.h"
#import "MJSharedClient.h"
#import "MJWebServiceClient.h"
#import "DPDiamondCellHeaderView.h"
#import <MessageUI/MFMailComposeViewController.h>
#define ROOT_FOLDER [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface DPCollectionViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic ,assign)bool isselectedRow;
@property (nonatomic ,retain) MFMailComposeViewController *mailpicker;
@property (nonatomic ,retain)  DPDiamondCellHeaderView *diamondCellHeaderView;
@property (nonatomic , retain)NSMutableArray *diamondArray;

@end

@implementation DPCollectionViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated  {
   	self.isselectedRow=NO;
    [self priceLabelwithVALUE:[[MJSharedClient sharedInstance].totalCollectionPrice floatValue]];
	[self.tableView reloadData];
    [self refreshButtonPressed:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewWithNewCurrency) name:@"updateViewWithNewCurrency" object:nil];
	// Do any additional setup after loading the view.
     [self.tableView registerNib:[UINib nibWithNibName:@"DPCollectionViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    [self.scrollView setContentSize:CGSizeMake(500, 175)];
    self.diamondArray=[[NSMutableArray alloc]init];
    numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setCurrencySymbol:@""];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    
}
-(void)addTargetsToDiamondCellHeaderViewButtons:(id)sender{
    [self.diamondCellHeaderView.weightButton addTarget:self action:@selector(sortDiamond:) forControlEvents:UIControlEventTouchUpInside];
    [self.diamondCellHeaderView.cutButton addTarget:self action:@selector(sortDiamond:) forControlEvents:UIControlEventTouchUpInside];
    [self.diamondCellHeaderView.colButton addTarget:self action:@selector(sortDiamond:) forControlEvents:UIControlEventTouchUpInside];
    [self.diamondCellHeaderView.claButton addTarget:self action:@selector(sortDiamond:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.diamondCellHeaderView.priceButton addTarget:self action:@selector(sortDiamond:) forControlEvents:UIControlEventTouchUpInside];

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
	UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
	//if(section==0&&diamondArray.count>0)
	if(self.diamondArray.count>0)
	{
        if (self.diamondCellHeaderView==Nil) {
            
            
            self.diamondCellHeaderView=[[DPDiamondCellHeaderView alloc]init];
            [self performSelector:@selector(addTargetsToDiamondCellHeaderViewButtons:) withObject:Nil afterDelay:5];
        }
        headerView=self.diamondCellHeaderView.view;
        
	}
    

	return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38.0;
}
-(IBAction)sortDiamond:(id)sender{
    //Sorting Diamonds
    {
        
        UIButton *button = sender;
        NSString *sortingString  ;
        //name,weight,quantity,price,cut,color,clarity,discount,discountPrice,pricePerCarat,image
        if ([button.titleLabel.text isEqualToString:@"Wght"]) {
            sortingString = @"weight";
            if (!sortAssending) {
                [self.diamondCellHeaderView.weightButton setImage:[UIImage imageNamed:@"Wght-top"] forState:UIControlStateNormal];
            }else{
                [self.diamondCellHeaderView.weightButton setImage:[UIImage imageNamed:@"Wght-bottom"] forState:UIControlStateNormal];
            }
            [self.diamondCellHeaderView.priceButton setImage:[UIImage imageNamed:@"Price.png"] forState:UIControlStateNormal];
            
            [self.diamondCellHeaderView.cutButton setImage:[UIImage imageNamed:@"cut.png"] forState:UIControlStateNormal];
            [self.diamondCellHeaderView.colButton setImage:[UIImage imageNamed:@"Col.png"] forState:UIControlStateNormal];
            [self.diamondCellHeaderView.claButton setImage:[UIImage imageNamed:@"Cla.png"] forState:UIControlStateNormal];
            
        }
        else if([button.titleLabel.text isEqualToString:@"Cut"]){
            sortingString = @"cut";
            if (!sortAssending) {
                [self.diamondCellHeaderView.cutButton setImage:[UIImage imageNamed:@"Cut-top"] forState:UIControlStateNormal];
            }else{
                [self.diamondCellHeaderView.cutButton setImage:[UIImage imageNamed:@"Cut-bottom"] forState:UIControlStateNormal];
            }
            [self.diamondCellHeaderView.priceButton setImage:[UIImage imageNamed:@"Price.png"] forState:UIControlStateNormal];
            
            [self.diamondCellHeaderView.weightButton setImage:[UIImage imageNamed:@"wght.png"] forState:UIControlStateNormal];
            [self.diamondCellHeaderView.colButton setImage:[UIImage imageNamed:@"Col.png"] forState:UIControlStateNormal];
            [self.diamondCellHeaderView.claButton setImage:[UIImage imageNamed:@"Cla.png"] forState:UIControlStateNormal];
        }
        else if([button.titleLabel.text isEqualToString:@"Col"]){
            sortingString = @"color";
            if (!sortAssending) {
                [self.diamondCellHeaderView.colButton setImage:[UIImage imageNamed:@"col-top.png"] forState:UIControlStateNormal];
            }else{
                [self.diamondCellHeaderView.colButton setImage:[UIImage imageNamed:@"col-bottom"] forState:UIControlStateNormal];
            }
            [self.diamondCellHeaderView.priceButton setImage:[UIImage imageNamed:@"Price.png"] forState:UIControlStateNormal];
            
            [self.diamondCellHeaderView.cutButton setImage:[UIImage imageNamed:@"cut.png"] forState:UIControlStateNormal];
            [self.diamondCellHeaderView.weightButton setImage:[UIImage imageNamed:@"wght.png"] forState:UIControlStateNormal];
            [self.diamondCellHeaderView.claButton setImage:[UIImage imageNamed:@"Cla.png"] forState:UIControlStateNormal];
        }else if([button.titleLabel.text isEqualToString:@"Cla"]){
            sortingString = @"clarity";
            if (!sortAssending) {
                [self.diamondCellHeaderView.claButton setImage:[UIImage imageNamed:@"Cla-top.png"] forState:UIControlStateNormal];
            }else{
                [self.diamondCellHeaderView.claButton setImage:[UIImage imageNamed:@"Cla-bottom.png"] forState:UIControlStateNormal];
            }
            [self.diamondCellHeaderView.priceButton setImage:[UIImage imageNamed:@"Price.png"] forState:UIControlStateNormal];
            
            [self.diamondCellHeaderView.cutButton setImage:[UIImage imageNamed:@"cut.png"] forState:UIControlStateNormal];
            [self.diamondCellHeaderView.colButton setImage:[UIImage imageNamed:@"Col.png"] forState:UIControlStateNormal];
            
            [self.diamondCellHeaderView.weightButton setImage:[UIImage imageNamed:@"wght.png"] forState:UIControlStateNormal];
        }else if([button.titleLabel.text isEqualToString:@"Qty"]){
            sortingString = @"quantity";
        }else if([button.titleLabel.text isEqualToString:@"Disc"]){
            sortingString = @"discount";
        }else if([button.titleLabel.text isEqualToString:@"Price"]){
            sortingString = @"price";
            NSLog(@"button tag = %ld...button state:%lu",button.tag,button.state);
            
            if (!sortAssending) {
                [self.diamondCellHeaderView.priceButton setImage:[UIImage imageNamed:@"Price-top"] forState:UIControlStateNormal];
            }else{
                [self.diamondCellHeaderView.priceButton setImage:[UIImage imageNamed:@"Price-bottom"] forState:UIControlStateNormal];
            }
            [self.diamondCellHeaderView.weightButton setImage:[UIImage imageNamed:@"wght.png"] forState:UIControlStateNormal];
            
            
            [self.diamondCellHeaderView.cutButton setImage:[UIImage imageNamed:@"cut.png"] forState:UIControlStateNormal];
            [self.diamondCellHeaderView.colButton setImage:[UIImage imageNamed:@"Col.png"] forState:UIControlStateNormal];
            [self.diamondCellHeaderView.claButton setImage:[UIImage imageNamed:@"Cla.png"] forState:UIControlStateNormal];
            
        }
        
        NSLog(@"Button pressed = %@",button.titleLabel.text);
        NSMutableArray *arrayForSort = [[NSMutableArray alloc] init];
        for (NSObject *diam in [MJSharedClient sharedInstance].myCollection) {
            
            if ([diam isKindOfClass:[Diamond class]]) {
                
                Diamond *temp = (Diamond*)diam;
                [arrayForSort addObject:temp];
                NSLog(@"wieght = %@",temp.weight);
            }
        }
        
        NSSortDescriptor *sortDescriptor;
        if (!sortAssending) {
            sortDescriptor =
            [[NSSortDescriptor alloc] initWithKey:sortingString ascending:YES];
            sortAssending = YES;
        }else{
            sortDescriptor =
            [[NSSortDescriptor alloc] initWithKey:sortingString ascending:NO];
            sortAssending = NO;
        }
        
        
        NSArray *sortDescriptors =
        [NSArray arrayWithObject:sortDescriptor];
        
        NSArray *sorted =
        [arrayForSort sortedArrayUsingDescriptors:sortDescriptors];
        
       
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[MJSharedClient sharedInstance].myCollection];
       
        for (NSObject *diam in tempArray) {
            
            if ([diam isKindOfClass:[Diamond class]]) {
                [[MJSharedClient sharedInstance].myCollection removeObject:(Diamond*)diam];
            }
        }
        
       
        for (NSObject *diam in sorted) {
            
            if ([diam isKindOfClass:[Diamond class]]) {
                
                Diamond *temp = (Diamond*)diam;
                [[MJSharedClient sharedInstance].myCollection addObject:temp];
                NSLog(@"wieght = %@",temp.weight);
            }
        }
       
        
        [self.tableView reloadData];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    [self.diamondArray removeAllObjects];
    [self.diamondArray addObjectsFromArray:[[MJSharedClient sharedInstance] myCollection]];
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section{
    return [self.diamondArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DPCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Diamond *diamond=(Diamond *)[self.diamondArray objectAtIndex:indexPath.row];
    [cell.priceLabel setText:[numberFormatter stringFromNumber:diamond.discountPrice]];
    [cell.priceLabel sizeToFit];
    [cell.weightLabel setText:[[NSString stringWithFormat:@"%.2f",[diamond.weight floatValue]] stringByAppendingString:@""]];
    [cell.weightLabel sizeToFit];
    [cell.cutLabel setText:diamond.cut];
    [cell.cutLabel sizeToFit];
    [cell.colorLabel setText:diamond.color];
    [cell.colorLabel sizeToFit];
    [cell.clarityLabel setText:diamond.clarity];
    [cell.clarityLabel sizeToFit];
    cell.image.image= diamond.image;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    imageView.image = [UIImage imageNamed:@"cellBG.png"];
    cell.backgroundView = imageView;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.isselectedRow=YES;
}
-(void)priceLabelwithVALUE:(float)value {
	self.flagImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.gif",[MJSharedClient sharedInstance].selectedCurrency]];
	NSString *priceString=[[NSString alloc]initWithFormat:@"%.2f",value];
	if ([priceString intValue]<1)
		priceString =@"0.00";
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
	
	self.priceLabel.text = labelText;
    [self.priceLabel sizeToFit];
    
}
- (IBAction)emailButtonPressed:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Send Email"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:@"Selected Item", @"Entire Collection", nil];
    if ([self.diamondArray count]>0) {
        [actionSheet showFromTabBar:[self.tabBarController tabBar]];
    }
    
    
}

- (IBAction)refreshButtonPressed:(id)sender {
    
	
	NSObject *object;
	float ppr=0,pr=0,dpr=0;
	
	for (object in [MJSharedClient sharedInstance].myCollection)
		if([object isKindOfClass:[Diamond class]])
		{
			Diamond *diamond=(Diamond *)object;
			
			float weight = [diamond.weight floatValue];
			if([diamond.weight floatValue]<0.18 &&!(![MJSharedClient sharedInstance].isidex &&[diamond.cut isEqualToString:@"BR"]))
			{
				weight=0.18;
			}
			else if([diamond.weight floatValue]<0.01 &&(![MJSharedClient sharedInstance].isidex &&[diamond.cut isEqualToString:@"BR"]))
			{
				weight=0.01;
			}
			else if([diamond.weight floatValue]>10.99&&![MJSharedClient sharedInstance].isidex)
			{
				weight=10.99;
			}
			else if([diamond.weight floatValue]>5.99&&!([diamond.weight floatValue]>=10.00&&[diamond.weight floatValue]<=10.99))
			{
				weight=5.99;
			}
			else if([diamond.weight floatValue]>5.99&&[MJSharedClient sharedInstance].isidex)
			{
				weight=5.99;
			}
			
			
			if([MJSharedClient sharedInstance].isidex)
				ppr=[[MJWebServiceClient sharedInstance] idexPriceForWeight:weight Cut:diamond.cut Color:diamond.color Clarity:diamond.clarity]*[[MJSharedClient sharedInstance].selectedCurrencyMultiplier floatValue];
			else
				ppr=[[MJWebServiceClient sharedInstance] rapaportPriceForWeight:weight Cut:diamond.cut Color:diamond.color Clarity:diamond.clarity]*[[MJSharedClient sharedInstance].selectedCurrencyMultiplier floatValue];
			
			
			pr=ppr*[diamond.quantity intValue]*[diamond.weight floatValue];
			dpr=(pr)+(pr*[diamond.discount floatValue] /100);
			[MJSharedClient sharedInstance].totalCollectionPrice=[NSNumber numberWithFloat:[[MJSharedClient sharedInstance].totalCollectionPrice floatValue]-[diamond.discountPrice floatValue]];
			diamond.price=[NSNumber numberWithFloat:pr];
			diamond.discountPrice=[NSNumber numberWithFloat:dpr];
			[MJSharedClient sharedInstance].totalCollectionPrice=[NSNumber numberWithFloat:[[MJSharedClient sharedInstance].totalCollectionPrice floatValue]+[diamond.discountPrice floatValue]];
		}
	[self.tableView reloadData];
	[self priceLabelwithVALUE:[[MJSharedClient sharedInstance].totalCollectionPrice floatValue]];
}

- (IBAction)infoButtonPressed:(id)sender {
}

- (IBAction)cameraButtonPressed:(id)sender {
    if(self.isselectedRow)
	{
		UIActionSheet *choicesSheet = [[UIActionSheet alloc] initWithTitle:@"Photo Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Use Existing Photo", nil];
		[choicesSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
		[choicesSheet showFromTabBar:[self.tabBarController tabBar]];
		
	}
	else
	{
		UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"No diamond selected" message:@"Please select a diamond to add a picture" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		
	}

}
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	if( buttonIndex != actionSheet.cancelButtonIndex ) {
		if([actionSheet.title isEqualToString:@"Photo Source"]) {
			if(buttonIndex==1)
			{
				[self getPhoto:1];
			}
			else if(buttonIndex==0)
			{
				[self getPhoto:0];
			}
			
		}
		if ([actionSheet.title isEqualToString:@"Send Email"]) {
            if(buttonIndex==1)
			{
				[self sendEmailEntireCollection];
			}
			else if(buttonIndex==0)
			{
				[self sendEmailSelectedItem];
			}
        }
	}
}
-(void) getPhoto:(int)index {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	if(index==1) {
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	[self presentViewController:picker animated:YES completion:Nil ];
	
	
}
-(UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:Nil];
	UIImage *jewelImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if([self.tableView indexPathForSelectedRow].section==0)
	{
		Diamond *diam=[self.diamondArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
		diam.image=[self scale:jewelImage toSize:CGSizeMake(250, 250)];
	}
	[self.tableView reloadData];
	
	
}
-(void) sendEmailSelectedItem{
    if(self.isselectedRow)
    {
        if ([MFMailComposeViewController canSendMail]){
            NSMutableString *messageBody=[NSMutableString stringWithFormat:@""];
            NSString *subjectText=@"";
            self.mailpicker = [[MFMailComposeViewController alloc] init];
            
            if([self.tableView indexPathForSelectedRow].section==0&&self.diamondArray.count>0)
            {
                subjectText=@"Diamond";
                Diamond *diam=(Diamond *)[self.diamondArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
                NSData *dataForPNGFile = UIImageJPEGRepresentation( diam.image, 0.9f);
                [dataForPNGFile writeToFile:[NSString stringWithFormat:@"%@/%@.png",ROOT_FOLDER,diam.name] atomically:YES];
                [self.mailpicker addAttachmentData:dataForPNGFile mimeType:@"image/png" fileName:diam.name];
                [messageBody appendFormat:@"Weight: %@ ct<br/>",diam.weight];
                [messageBody appendFormat:@"Cut: %@<br/>",diam.cut];
                [messageBody appendFormat:@"Color: %@<br/>",diam.color];
                [messageBody appendFormat:@"Clarity: %@<br/>",diam.clarity];
                //[messageBody appendFormat:@"Quantity: %@<br/>",diam.quantity];
                [messageBody appendFormat:@"Price (%@): %@<br/>",[MJSharedClient sharedInstance].selectedCurrency,[numberFormatter stringFromNumber:diam.discountPrice]];
            }
            [self mailIt:@"" emailsSubject:subjectText emailsBody:messageBody];
            
        }
        else{
            
            // Show some error message here
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email configuration error" message:@"Check email configuration settings" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"No item highlighted" message:@"Please select an item to email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        alertView=nil;
        
    }
}
-(void) sendEmailEntireCollection{
    
    if ([MFMailComposeViewController canSendMail]){
        // Create and show composer
        self.mailpicker = [[MFMailComposeViewController alloc] init];
        
        
        
        NSMutableString *messageBody=[NSMutableString stringWithFormat:@""];
        NSString *subjectText=@"";
        NSLog(@"section :%li ",[self.tableView indexPathForSelectedRow].section);
        
        if(self.diamondArray.count>0)
        {
            // Diamond
            subjectText=@"Diamond";
            double totalCost;
            for (Diamond *diam in self.diamondArray){
                
                NSData *dataForPNGFile = UIImageJPEGRepresentation( diam.image, 0.9f);
                [dataForPNGFile writeToFile:[NSString stringWithFormat:@"%@/%@.png",ROOT_FOLDER,diam.name] atomically:YES];
                [self.mailpicker addAttachmentData:dataForPNGFile mimeType:@"image/png" fileName:diam.name];
                [messageBody appendFormat:@"Weight  : %@<br/>",diam.weight];
                [messageBody appendFormat:@"Cut     : %@<br/>",diam.cut];
                [messageBody appendFormat:@"Color   : %@<br/>",diam.color];
                [messageBody appendFormat:@"Clarity : %@<br/>",diam.clarity];
                [messageBody appendFormat:@"Quantity: %@<br/>",diam.quantity];
                [messageBody appendFormat:@"Price (%@): %@<br/><br/>",[MJSharedClient sharedInstance].selectedCurrency,[numberFormatter stringFromNumber:diam.discountPrice]];
                totalCost = totalCost+[diam.discountPrice floatValue];
            }
            [messageBody appendFormat:@"<h6>Total Diamond Price (%@): %.3f <h6/>",[MJSharedClient sharedInstance].selectedCurrency,[[MJSharedClient sharedInstance].totalCollectionPrice floatValue]];
        }
        
        NSLog(@"messagebody html = %@",messageBody);
        [self mailIt:nil emailsSubject:subjectText emailsBody:messageBody];}
    
    else{
        
        // Show some error message here
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email configuration error" message:@"Check email configuration settings" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)mailIt:(NSString *)sentToEmail emailsSubject:(NSString *)subjectText emailsBody:(NSString *)textOfEmail{
	
	self.mailpicker.mailComposeDelegate = self;
	[self.mailpicker setSubject:subjectText];
	[self.mailpicker setMessageBody:textOfEmail isHTML:YES];
	[self presentViewController:self.mailpicker animated:YES completion:Nil ];

	
    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	if( result ==MFMailComposeResultSent ){
		//[appDelegate.customTab.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
		[self dismissViewControllerAnimated:YES completion:Nil];
		
	} else {
        [self dismissViewControllerAnimated:YES completion:Nil];
	}
	
}
- (IBAction)sInfoButtonPressed:(id)sender {
}

- (IBAction)deleteButtonPressed:(id)sender {
    if(self.isselectedRow)
	{
        if([self.tableView indexPathForSelectedRow].section==0&&self.diamondArray.count>0)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete Daimond ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            
			[alert setTag:95];
			[alert show];
            alert = Nil;
		}
		
	}
	else
	{
		UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"No diamond highlighted" message:@"Please select a diamond to delete" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		alertView=nil;
	}
}



- (IBAction)editButtonPressed:(id)sender {
    if(self.isselectedRow)
	{
		if([self.tableView indexPathForSelectedRow].section==0&&self.diamondArray.count>0)
		{
			Diamond *diamond=(Diamond *)[self.diamondArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
			[MJSharedClient sharedInstance].isEditDiamondFromCollection=YES;
			[MJSharedClient sharedInstance].editableDiamond=diamond;
			
			 [self.tabBarController setSelectedIndex:0];
		}
	}
	else
	{
		UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"No diamond highlighted" message:@"Please select a diamond to edit" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		alertView=nil;
	}

}

-(void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
		if( [alertView tag] ==95)
		{
			if([self.tableView indexPathForSelectedRow].section==0)
			{
				Diamond *diamond=(Diamond *)[self.diamondArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
				[MJSharedClient sharedInstance].totalCollectionPrice=[NSNumber numberWithFloat:[[MJSharedClient sharedInstance].totalCollectionPrice floatValue] -[diamond.discountPrice floatValue]];
				[self priceLabelwithVALUE:[[MJSharedClient sharedInstance].totalCollectionPrice floatValue]];
				[[MJSharedClient sharedInstance].myCollection removeObject:diamond];
                	self.isselectedRow=NO;
			}
                [self.tableView reloadData];
		}
		
	}
}
-(void) updateViewWithNewCurrency {
	self.flagImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.gif",[MJSharedClient sharedInstance].selectedCurrency]];
	[self refreshButtonPressed:nil];
    [[MJSharedClient sharedInstance] saveMyCollection];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
