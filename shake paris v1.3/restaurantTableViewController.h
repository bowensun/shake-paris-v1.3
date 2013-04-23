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

@interface restaurantTableViewController : UITableViewController<CLLocationManagerDelegate, MKMapViewDelegate, ADBannerViewDelegate>
{
    ADBannerView *bannerView;
}
@property (nonatomic ,strong) NSString *viewMode;
@property (nonatomic, strong) NSArray *restaurants;
@property (nonatomic, weak) Restaurant *restaurant;
@property (nonatomic, strong) CLLocationManager *localManager;
@property (nonatomic,assign) NSInteger items;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonChangerMode;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
- (IBAction)changerMode:(id)sender;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@end
