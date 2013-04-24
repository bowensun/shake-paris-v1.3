//
//  helpDetailViewController.m
//  shake paris v1.3
//
//  Created by user on 24/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "helpDetailViewController.h"

@interface helpDetailViewController ()

@end

@implementation helpDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initWithInfoString:(NSString *)string
{
    self.infoString = string;
    NSLog(@"%@",self.infoString);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.helpTextView.text = self.infoString;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
