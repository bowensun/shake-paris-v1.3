//
//  helpViewController.h
//  shake paris v1.3
//
//  Created by user on 24/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface helpViewController : UIViewController
- (IBAction)checkVersion:(id)sender;
- (IBAction)customersReviews:(id)sender;
@property (strong , nonatomic) UIAlertView *baseAlert;
@property (strong, nonatomic) NSTimer *timer;
@end
