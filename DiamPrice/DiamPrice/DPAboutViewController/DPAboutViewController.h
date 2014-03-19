//
//  DPAboutViewController.h
//  DiamPrice
//
//  Created by Ch Burhan Ahmad on 1/21/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPAboutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)backButtonPressed:(id)sender;
@end
