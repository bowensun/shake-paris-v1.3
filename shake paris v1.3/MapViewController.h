//
//  MapViewController.h
//  shake paris v1.3
//
//  Created by user on 28/03/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Restaurant+Firebase.h"
#import "RestauAnnotation.h"
#import "ShowDetailViewController.h"
@class  MapViewController;
@protocol MapViewControllerDelegate <NSObject>
-(UIImage *) mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{
    ADBannerView *bannerView;
}
@property (nonatomic , strong) NSArray *annotations;
@property (nonatomic , strong) NSMutableArray *restaurants;
@property (nonatomic , strong) CLLocationManager *locationMangager;
@property (nonatomic , strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic , weak) id <MapViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic , weak) RestauAnnotation *restauAnnotation;
@property (nonatomic ,strong)  UIActivityIndicatorView *spinner;
- (IBAction)getCurrentLocation:(id)sender;
- (IBAction)doRefresh:(id)sender;
@end
