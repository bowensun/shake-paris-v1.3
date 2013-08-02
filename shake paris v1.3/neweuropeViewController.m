//
//  neweuropeViewController.m
//  shake paris v1.3
//
//  Created by user on 09/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "neweuropeViewController.h"

@interface neweuropeViewController ()

@end

@implementation neweuropeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initWithUrl:(NSString *)urlString
{
    //NSString *encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (![urlString isEqualToString:@""]) {
        self.url = [NSURL URLWithString:urlString];
    }else
    {
        self.url = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.url) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
        [self.neweuropWebView loadRequest:request];
        [self.neweuropWebView setUserInteractionEnabled:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该商家没有战法黄页，请返回" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
	// Do any additional setup after loading the view.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return TRUE;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
