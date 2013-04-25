 //
//  MapViewController.m
//  shake paris v1.3
//
//  Created by user on 28/03/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "MapViewController.h"
#import <Firebase/Firebase.h>
#import <CoreData/CoreData.h>
#import "ShowDetailViewController.h"


@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize annotations= _annotations;
@synthesize restaurants = _restaurants;
@synthesize locationMangager = _locationMangager;

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
}

-(void)loadDataFromDataDocument:(NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Restaurant"];
        //request.sortDescriptors  = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = nil;
        NSError *error = nil ;
        self.restaurants = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:request error:&error]];
        NSLog(@"%d****************************************", [self.restaurants count]);
        for (Restaurant *msgData in self.restaurants) {
            NSLog(@"name:%@  address:%@" ,msgData.name , msgData.address);
        }
        self.annotations = [self mapAnnotations];
        NSLog(@"%d in setManagedObjectContext",[self.annotations count]);
        [self updateMapView];
        NSLog(@"%d in the array",[self.restaurants count]);
        NSLog(@"loadDataFormDataDocument did!");
        if (![self.restaurants count]) {
            NSLog(@"准备重新读取数据");
            [self refresh];
        }
    }else{
        self.restaurants = nil;
        NSLog(@"dont have document");
    }
}
-(void) useDocument
{
    NSURL *url = [[[NSFileManager defaultManager ] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        //create file
       [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
           if (success) {
               self.managedObjectContext = document.managedObjectContext;
                NSLog(@"Creating file success ");
               [self refresh];
           }else
           {
               NSLog(@"Creating file error");
           }
       }];
    }else if (document.documentState == UIDocumentStateClosed){
        //open file
        [document openWithCompletionHandler:^(BOOL success) {
            self.managedObjectContext = document.managedObjectContext;
            [self loadDataFromDataDocument:self.managedObjectContext];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"test" message:@"load message" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
            [alert show];
        }];
    }else{
        //try to use it
        self.managedObjectContext = document.managedObjectContext;
        [self loadDataFromDataDocument:self.managedObjectContext];
    }
}

-(void) saveToDocument:(NSMutableArray *)restauArray
{
    for (NSDictionary *restaurant in restauArray) {
        [Restaurant restaurantWithFirebaseInfo:restaurant inManagedObjectContext:self.managedObjectContext];
    }
    NSLog(@"Save to document success");
    [self loadDataFromDataDocument:self.managedObjectContext];
}

/*

-(void) refresh
{
    if (!self.restaurants) {
        self.restaurants = [[NSMutableArray alloc] init];
    }
    NSMutableArray *restautArray = self.restaurants;
    [self.restaurants removeAllObjects];
    
    Firebase *listRef = [[Firebase alloc] initWithUrl:@"https://shakeparis.firebaseio.com/"];
    
    [listRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"download success");
        [self.spinner stopAnimating];
        self.navigationItem.rightBarButtonItem = self.refreshButton;
        if (![self.restaurants count]) {
            self.restaurants = restautArray;
        }
        [self saveToDocument:self.restaurants];
    }];
    [listRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *msgData = snapshot.value;
        
        if (![self.restaurants containsObject:msgData]) {
            [self.restaurants addObject:msgData];
            NSLog(@"contain!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        }else
            NSLog(@"name:%@  address:%@  latitude:%@  longitude:%@",msgData[@"name"],msgData[@"address"],msgData[@"latitude"],msgData[@"longitude"]);
        
        NSLog(@"%d----------------------------", [self.restaurants count]);
        
    }];

}
*/
//测试本地文件
-(void) refresh
{
    if (!self.restaurants) {
        self.restaurants = [[NSMutableArray alloc] init];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shakeparis-export" ofType:@"json"];
    NSData *jdata = [[NSData alloc] initWithContentsOfFile:path];
    NSLog(@"long of the jdata = %d",[jdata length]);
    NSError *e = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jdata options:kNilOptions error:&e];
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@",e);
    }else{
        for (Restaurant *item in jsonArray) {
            NSLog(@"Item: %@",item);
            [self.restaurants addObject:item];
        }
    }
    [self saveToDocument:self.restaurants];
    
}

/*
-(void)restaurantWithFireBase
{
    if (!self.restaurants) {
        self.restaurants = [[NSMutableArray alloc] init];
    }
    
    Firebase *listRef = [[Firebase alloc] initWithUrl:@"https://shakeparis.firebaseio.com/"];
    
    [listRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"qqqqqqqqqqqqqqqqqqqqqqqqqq");
        self.annotations = [self mapAnnotations];
    }];
    [listRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *msgData = snapshot.value;
        NSLog(@"name:%@  address:%@  latitude:%@  longitude:%@",msgData[@"name"],msgData[@"address"],msgData[@"latitude"],msgData[@"longitude"]);
        //[self.restaurants addObject:msgData];
        NSLog(@"%d----------------------------", [self.restaurants count]);

    }];
    
}
*/




-(void)currentLocation
{
    self.locationMangager = [[CLLocationManager alloc] init];
    self.locationMangager.delegate = self;
    self.locationMangager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationMangager.distanceFilter = 100.0f;
    [self.locationMangager startUpdatingLocation];
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta = 0.07;
    theSpan.longitudeDelta = 0.07;
    MKCoordinateRegion theRegion;
    theRegion.center = [[self.locationMangager location] coordinate];
    theRegion.span = theSpan;
    [self.mapView setRegion:theRegion];
    self.mapView.showsUserLocation = YES;
    [self updateMapView];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    MKCoordinateRegion theRegion;
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta = 0.1;
    theSpan.longitudeDelta = 0.1;
    theRegion.center = [[locations lastObject] coordinate];
    theRegion.span = theSpan;
    [self.mapView setRegion:theRegion];
}
/*
-(void)initRestaurantsArray
{
    NSString *str = @"[{\"name\":\"nameTest1\",\"address\":\"addressTest1\",\"longitude\": \"2.2124123\",\"latitude\":\"48.8344123131\"},{\"name\":\"nameTest2\",\"address\":\"addressTest2\",\"longitude\": \"2.5324123\",\"latitude\":\"48.8644123131\"}]";
    NSError *e = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&e];
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@",e);
    }else{
        for (NSDictionary *item in jsonArray) {
            NSLog(@"Item: %@",item);
        }
    }
    self.restaurants = jsonArray;
}
 */

-(NSArray *)mapAnnotations
{
    //[self initRestaurantsArray];
    NSMutableArray *annotations = [NSMutableArray array];
    for (Restaurant *restaurant in self.restaurants) {
        [annotations addObject:[RestauAnnotation annotationForRestaurant:restaurant]];
    }
    return annotations;
}
-(void)setRestaurants:(NSMutableArray *)restaurants
{
    _restaurants = restaurants;
    [Restaurant setRestaurants:restaurants];
    [self updateMapView];
}

-(void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

-(void)updateMapView
{
    if (self.mapView.annotations) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    if (self.annotations) {
        [self.mapView addAnnotations: self.annotations];
        NSLog(@"%d in array annotations",[self.annotations count]);
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.managedObjectContext) {
        [self useDocument];
    }
    self.mapView.delegate = self;
    self.spinner= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self currentLocation];
     //NSLog(@"%d----------------------------", [self.restaurants count]);
	
    // Do any additional setup after loading the view.
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RestauAnnotation class]]) {
        MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
        if (!aView) {
            aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
            aView.canShowCallout = YES;
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [detailButton addTarget:self action:@selector(showDetailView) forControlEvents:UIControlEventTouchUpInside];
            aView.rightCalloutAccessoryView = detailButton;
            aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            
        }
        aView.annotation = annotation;
        if ([aView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)(aView.leftCalloutAccessoryView);
            imageView.image = nil;
        }
        return aView;
    }else{
        return nil;
    }

}

-(void)showDetailView
{
    [self performSegueWithIdentifier:@"ShowDetail" sender:self];
}
 /*

- (void ) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{   
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImage class]]) {
        
        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
        if ([view.annotation respondsToSelector:@selector(thumbnail)]) {
            imageView.image = [view.annotation performSelector:@selector(thumbnail)];
        }
        
    }
}
 */
- (void ) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    self.restauAnnotation = view.annotation;    NSLog(@"In mapView didselect %@ %@",self.restauAnnotation.title,self.restauAnnotation.restaurant.information);

    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
        if ([view.annotation respondsToSelector:@selector(thumbnail)]) {
            dispatch_queue_t downloadQueue = dispatch_queue_create("Image downloader", NULL);
            dispatch_async(downloadQueue, ^{
                UIImage *image = [[UIImage alloc] init];
                image = [view.annotation performSelector:@selector(thumbnail)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                });
                
            });            
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCurrentLocation:(id)sender {
    [self currentLocation];
}

- (IBAction)doRefresh:(id)sender {
    
    [self.spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    [self refresh];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        [segue.destinationViewController initWithRestaurant:self.restauAnnotation.restaurant];
    }
}
@end
