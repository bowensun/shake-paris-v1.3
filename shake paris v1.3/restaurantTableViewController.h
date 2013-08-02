//
//  restaurantTableViewController.h
//  shake paris v1.3
//
//  Created by user on 10/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant+Firebase.h"
#import "ShowDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>

@interface restaurantTableViewController : UITableViewController<CLLocationManagerDelegate, MKMapViewDelegate>
@property (nonatomic ,strong) NSString *viewMode;
@property (nonatomic, strong) NSArray *restaurants;
@property (nonatomic, strong) LocalRestaurant *restaurant;
@property (nonatomic, strong) CLLocationManager *localManager;
@property (nonatomic,assign) NSInteger items;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonChangerMode;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic,strong) NSNumber *sdkVersion;
@property (nonatomic ,strong) NSString *flag;
-(void) initWithRestaurantsSelected:(NSMutableArray *)restaurantsSelected WithType:(NSString *)type;
- (IBAction)changerMode:(id)sender;
@end
