//
//  DPShapesViewController.m
//  DiamPrice
//
//  Created by Ch Burhan Ahmad on 1/21/14.
//  Copyright (c) 2014 MaavraTech. All rights reserved.
//

#import "DPShapesViewController.h"

@interface DPShapesViewController ()

@end

@implementation DPShapesViewController

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

- (IBAction)backButonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
