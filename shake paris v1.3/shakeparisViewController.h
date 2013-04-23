//
//  shakeparisViewController.h
//  shake paris v1.3
//
//  Created by user on 28/03/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Restaurant.h"
@interface shakeparisViewController : UIViewController

@property (strong, nonatomic) NSArray *restaurants;
@property (weak , nonatomic) Restaurant *restaurant;
@end
