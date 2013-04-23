//
//  ShowDetailViewController.m
//  shake paris v1.3
//
//  Created by user on 07/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "ShowDetailViewController.h"


@interface ShowDetailViewController ()

@end

@implementation ShowDetailViewController
@synthesize bannerView = _bannerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initWithRestaurant:(Restaurant *)restaurant
{
    self.restaurant  = restaurant;
}

-(void)loadRestaurantImage
{
    NSURL *url = [NSURL URLWithString:self.restaurant.imageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    [self performSelectorOnMainThread:@selector(imageLoaded:) withObject:image waitUntilDone:YES];
}

-(void)imageLoaded: (UIImage *)image
{
    if(image)
        self.restaurantImage.image = image;
    else
        self.restaurantImage.image = nil;

}
-(void) loadRestaurantData
{
    self.navigationItem.title= self.restaurant.name;
    self.typeLable.text = [self.typeLable.text stringByAppendingString:self.restaurant.type];
    self.addressTextView.text = self.restaurant.address;
    self.businessHours.text = self.restaurant.businessHours;
    self.telephoneTextView.text = self.restaurant.telephone;
    self.informationTextView.text = self.restaurant.information;
    [NSThread detachNewThreadSelector:@selector(loadRestaurantImage) toTarget:self withObject:nil];
    
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self loadRestaurantData];
    self.bannerView.delegate = self;
    self.bannerView.userInteractionEnabled = YES;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showInWebView"]||[segue.identifier isEqualToString:@"showInWebView2"]) {
        [segue.destinationViewController initWithUrl:self.restaurant.xineuropeURL];
    }
}

@end
