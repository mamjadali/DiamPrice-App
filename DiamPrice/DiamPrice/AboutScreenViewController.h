//
//  AboutScreenViewController.h
//  MyCustomView
//
//  Created by Faheem on 04/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MJSharedClient.h"

@interface AboutScreenViewController : UIViewController<MFMailComposeViewControllerDelegate> {

	MJSharedClient *appDelegate;
	IBOutlet UIWebView *webView;
}

-(IBAction) tellAFriendButtonPressed;
-(IBAction) backButtonPressed ;
-(IBAction) urlButtonPressed;

@end
