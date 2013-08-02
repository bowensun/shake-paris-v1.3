//
//  helpViewController.m
//  shake paris v1.3
//
//  Created by user on 24/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "helpViewController.h"
#import <Firebase/Firebase.h>


@interface helpViewController ()

@end


@implementation helpViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)checkVersion:(id)sender {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(dialogDismiss) userInfo:nil repeats:YES];
    [self dialogShow];
    [self onCheckVersion];
}

-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSString *URL =@"http://itunes.apple.com/lookup?id=641363963";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (jsonData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSArray *infoArray = [dic objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            
            NSLog(@"current version :%@\n last version %@",appVersion,lastVersion);
            if (lastVersion) {
                if (![lastVersion isEqualToString:appVersion]) {
                    [self dialogDismiss];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新的版本!!" message: @"A new version of app is available to download" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Download", nil];
                    [alert show];
                }else{
                    [self dialogDismiss];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本检测" message:@"当前版本为最新版本" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }else
            {
                [self dialogDismiss];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message: @"获取数据出错,请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
                [alert show];
            }
            
        }
    }
    else
    {
        [self dialogDismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message: @"获取数据出错,请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
        [alert show];
    }

}
- (IBAction)customersReviews:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/chi-zai-ba-li/id641363963?ls=1&mt=8"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/chi-zai-ba-li/id641363963?ls=1&mt=8"]];
    }
}

//显示加载中对话框
- (void)dialogShow {
    self.baseAlert = [[UIAlertView alloc] initWithTitle:@"Loading" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [self.baseAlert show];
    
    //Create and add the activity indicator
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.center = CGPointMake(self.baseAlert.bounds.origin.x + self.baseAlert.bounds.size.width/2, self.baseAlert.bounds.origin.y +self.baseAlert.bounds.size.height/2);
    [aiv startAnimating];
    [self.baseAlert addSubview:aiv];
    
    //Auto dismiss after 3 seconds
    //[self performSelector:@selector(dialogDismiss) withObject:nil afterDelay:3.0f];
}
//取消对话框显示
- (void) dialogDismiss {
    [self.baseAlert dismissWithClickedButtonIndex:0 animated:NO];
    [self.timer invalidate];
    self.timer = nil;
}


@end
