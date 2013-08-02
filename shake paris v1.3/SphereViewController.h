//
//  SphereViewController.h
//  shake paris v1.3
//
//  Created by user on 13/05/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant+Firebase.h"
#import "restaurantTableViewController.h"


@interface SphereViewController : UIViewController

@property (strong , nonatomic) NSArray *restaurants;
@property (strong , nonatomic) NSMutableArray *types;
@property (strong, nonatomic) NSMutableArray *restaurantsSelected;
@property (weak , nonatomic) NSString *type;
@end
