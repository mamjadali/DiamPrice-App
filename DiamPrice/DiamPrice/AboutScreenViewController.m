//
//  AboutScreenViewController.m
//  MyCustomView
//
//  Created by Faheem on 04/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AboutScreenViewController.h"


@implementation AboutScreenViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

-(id) init {
	self=[super init];
	appDelegate = [MJSharedClient sharedInstance];
	return self;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
   
	//[self.navigationController.navigationBar setHidden:NO];
	[webView setBackgroundColor:[UIColor clearColor]];
	[webView setOpaque:NO];

}




-(void)mailIt:(NSString *)sentToEmail emailsSubject:(NSString *)subjectText emailsBody:(NSString *)textOfEmail{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:subjectText];
	[picker setMessageBody:textOfEmail isHTML:YES];
//	NSMutableArray *emails = [[NSMutableArray alloc] init];
//	[emails addObject:sentToEmail];
//	
//	[picker setToRecipients:emails];
//	[emails removeAllObjects];
	//NSString *billEmail = [[NSString alloc] initWithString:[self readObjectFromFile:@"email.txt"]];
	//[emails addObject:billEmail];
//	[picker setCcRecipients:emails];
	
//	[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
	
//	[emails release];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	
	
//		[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
	

}



-(IBAction) tellAFriendButtonPressed {
	NSString *emailID=@"";
	NSString *subject=@"DiamPrice iPhone App (Diamonds appraisal with Rapaport and IDEX pricing)";
	NSString *body=@"Dear friend,<br/><br/>I found an iPhone app that could be of great use to you called DiamPrice.  It allows you to value your diamonds by using prices from The International Diamond Exchange (IDEX), or by using your RapNet to use Rapaport prices.<br/><br/>The app also allows you to track your diamond collection with specifications and picture.<br/><br/><a href=\"http://itunes.apple.com/us/app/diamprice-diamond-pricing/id405191124\">See it in the App Store </a>";
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//	{
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"tellAFriendMail" object:nil];
//	}
//	else
		[self mailIt:emailID emailsSubject:subject emailsBody:body];
}

-(IBAction) backButtonPressed {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
//        [self dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
	}
	else {
		[self.navigationController popViewControllerAnimated:YES];
	}

}

-(IBAction) urlButtonPressed {
	[webView setBackgroundColor:[UIColor whiteColor]];
	[webView setOpaque:YES];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.diamprice.com"]]];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
  
}


@end
