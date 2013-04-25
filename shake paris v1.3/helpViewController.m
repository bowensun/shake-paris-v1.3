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
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"UserVersion"];
    NSString* url = @"https://bowenstudio.firebaseio.com/";
    Firebase* dataRef = [[Firebase alloc] initWithUrl:url];
    [dataRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSString *versionFirebase = [[NSString alloc] initWithFormat:@"%@",snapshot.value[@"version"]];
        self.iTunesLink = snapshot.value[@"itunesURL"];
        if (versionFirebase) {
            if ([versionFirebase isEqualToString:app_Version]) {
                [self dialogDismiss];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本检测" message:@"当前版本为最新版本" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                [self dialogDismiss];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新的版本!!" message: @"A new version of app is available to download" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Download", nil];
                [alert show];
            }
        }
        else
        {
            [self dialogDismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message: @"获取数据出错" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
            [alert show];
        }

    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.iTunesLink]];
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
