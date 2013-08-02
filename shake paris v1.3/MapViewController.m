 //
//  MapViewController.m
//  shake paris v1.3
//
//  Created by user on 28/03/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "MapViewController.h"
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

/*
-(void)loadDataFromDataDocument:(NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext) {
        NSLog(@"准备从文件中读取数据");
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Restaurant"];
        request.sortDescriptors  = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = nil;
        NSError *error = nil ;
        self.restaurants = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:request error:&error]];

        self.annotations = [self mapAnnotations];
        //NSLog(@"%d in setManagedObjectContext",[self.annotations count]);
        //NSLog(@"%d in the array",[self.restaurants count]);
        //NSLog(@"loadDataFormDataDocument did!");
    }else{
        NSLog(@"mangedObjectContext出错，读取文件失败");
        self.restaurants = nil;
        //NSLog(@"dont have document");
    }
}

-(void)useToSaveDocument
{
    NSURL *url = [[[NSFileManager defaultManager ] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        //create file
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
                [self saveToDocument:self.restaurants];
                //NSLog(@"Creating file success ");
            }else
            {
                NSLog(@"Creating file error");
            }
        }];
    }else
    {
        self.managedObjectContext = document.managedObjectContext;
        [self saveToDocument:self.restaurants];
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
                //NSLog(@"Creating file success ");
               [self refreshLocalData];
           }else
           {
               //NSLog(@"Creating file error");
           }
       }];
    }else if (document.documentState == UIDocumentStateClosed){
        //open file
        [document openWithCompletionHandler:^(BOOL success) {
            self.managedObjectContext = document.managedObjectContext;
            [self loadDataFromDataDocument:self.managedObjectContext];
        }];
    }else{
        //try to use it
        self.managedObjectContext = document.managedObjectContext;
        [self loadDataFromDataDocument:self.managedObjectContext];
    }
}

-(void) saveToDocument:(NSMutableArray *)restauArray
{
    if (!restauArray||[restauArray count] == 0) {
        NSLog(@"error in saveToDocument");
    }else{
        [self.managedObjectContext deletedObjects];
        NSLog(@"删除全部数据");
        for (NSDictionary *restaurant in restauArray) {
            [Restaurant restaurantWithFirebaseInfo:restaurant inManagedObjectContext:self.managedObjectContext];
        }
        NSLog(@"数据存储完毕");
        //NSLog(@"Save to document success");
        [self loadDataFromDataDocument:self.managedObjectContext];
    }

}


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

//测试本地文件

-(void) refreshLocalData
{
    if (!self.restaurants) {
        self.restaurants = [[NSMutableArray alloc] init];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shakeparis-export" ofType:@"json"];
    NSData *jdata = [[NSData alloc] initWithContentsOfFile:path];
    //NSLog(@"long of the jdata = %d",[jdata length]);
    NSError *e = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jdata options:kNilOptions error:&e];
    if (!jsonArray) {
        //NSLog(@"Error parsing JSON: %@",e);
    }else{
        for (Restaurant *item in jsonArray) {
            //NSLog(@"Item: %@",item);
            [self.restaurants addObject:item];
        }
    }
    [self useToSaveDocument];
}
-(void) refresh
{
    NSError *error;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/64140421/shakeparis-export.json"]];
    NSData *reponse = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSLog(@"%@",reponse);
    //NSLog(@"long of the jdata = %d",[jdata length]);
    if (!reponse) {
         NSLog(@"调用本地文件");
        [self useDocument];
    }else
    {
        self.restaurants = [NSJSONSerialization JSONObjectWithData:reponse options:kNilOptions error:&error];
        NSLog(@"%d---",[self.restaurants count]);
        if (!self.restaurants)
        {
            //NSLog(@"Error parsing JSON: %@",e);
            //加载的不成功调用本地文件
            NSLog(@"调用本地文件");
            [self useDocument];
        }else
        {
            //for (Restaurant *item in jsonArray) {
                //NSLog(@"Item: %d",[jsonArray count]);
                //[self.restaurants addObject:item];
            NSLog(@"数据下载完毕，准备存入文档");
            //[self saveToDocument:self.restaurants];
            [self useToSaveDocument];
        }
    }

}
 */
//测试在线文件

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
    theSpan.latitudeDelta = 0.03;
    theSpan.longitudeDelta = 0.03;
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
    theSpan.latitudeDelta = 0.03;
    theSpan.longitudeDelta = 0.03;
    theRegion.center = [[locations lastObject] coordinate];
    theRegion.span = theSpan;
    [self.mapView setRegion:theRegion];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    MKCoordinateRegion theRegion;
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta = 0.03;
    theSpan.longitudeDelta = 0.03;
    theRegion.center = [newLocation coordinate];
    theRegion.span = theSpan;
    [self.mapView setRegion:theRegion];
}

-(NSArray *)mapAnnotations
{
    //[self initRestaurantsArray];
    NSMutableArray *annotations = [NSMutableArray array];
    for (LocalRestaurant *restaurant in self.restaurants) {
        [annotations addObject:[RestauAnnotation annotationForRestaurant:restaurant]];
    }
    return annotations;
}
-(void)setRestaurants:(NSMutableArray *)restaurants
{
    _restaurants = restaurants;
    [LocalRestaurant setRestaurants:restaurants];
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
    if (self.annotations) {
        if (self.mapView.annotations) {
            [self.mapView removeAnnotations:self.mapView.annotations];
        }
        [self.mapView addAnnotations: self.annotations];
        //NSLog(@"%d in array annotations",[self.annotations count]);
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
    [super viewWillAppear:YES];
}
- (void)viewDidLoad
{
    self.restaurants = [LocalRestaurant getRestaurants];
    self.mapView.delegate = self;
    self.annotations = [self mapAnnotations];
    /*
    if (!self.managedObjectContext) {
        [self useDocument];
    }
     */
    
    self.spinner= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self currentLocation];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("version check", NULL);
    dispatch_async(downloadQueue, ^{
        if ([self onCheckVersion]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertForNewVersion];
            });
        };
    });
    [super viewDidLoad];
     //NSLog(@"%d----------------------------", [self.restaurants count]);
	
    // Do any additional setup after loading the view.
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
    self.restauAnnotation = view.annotation;
    //NSLog(@"In mapView didselect %@ %@",self.restauAnnotation.title,self.restauAnnotation.restaurant.information);

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
/*

- (IBAction)doRefresh:(id)sender {
    
    [self.spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    [self refresh];
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        [segue.destinationViewController initWithRestaurant:self.restauAnnotation.restaurant];
    }
}

-(BOOL)onCheckVersion
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
                    return YES;
                }
            }
        }
    }
    return NO;
}
-(void)alertForNewVersion
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新的版本!!" message: @"A new version of app is available to download" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Download", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/chi-zai-ba-li/id641363963?ls=1&mt=8"]];
    }
}

@end
