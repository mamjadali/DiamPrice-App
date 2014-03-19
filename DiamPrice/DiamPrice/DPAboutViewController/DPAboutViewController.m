//
//  DPAboutViewController.m
//  DiamPrice
//
//  Created by Ch Burhan Ahmad on 1/21/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import "DPAboutViewController.h"

@interface DPAboutViewController ()

@end

@implementation DPAboutViewController

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
    NSString *html=@"What is the collection screen?<br/>The collection screen is where you can store previously priced diamonds, add a picture to each diamond or send emails with your diamond information.<br/><br/>How do i add a picture?<br/>Tap on a diamond to highlight it then tap on the camera.<br/><br/>How do i email a diamond?<br/>Tap on a diamond to highlight it then tap on the Email button.<br/><br/>How do i make changes to an item?<br/>Tap on a diamond to highlight it then tap on edit.  You will then be redirected to the diamond screen where you can make all of your changes, when done editing tap on save.<br/><br/>For more information please visit www.appsplit.com or email us at support@appsplit.com<br/>";
    [self.webView setBackgroundColor:[UIColor clearColor]];
	[self.webView setOpaque:NO];
	
	
	NSString *newhtml=[NSString stringWithFormat:@"<span style=\"color:white\">%@</span>",html];
	[self.webView loadHTMLString:newhtml baseURL:nil];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
