//
//  neweuropeViewController.h
//  shake paris v1.3
//
//  Created by user on 09/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface neweuropeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *neweuropWebView;
@property (weak , nonatomic) NSURL *url;
-(void)initWithUrl:(NSString *)urlString;
@end
