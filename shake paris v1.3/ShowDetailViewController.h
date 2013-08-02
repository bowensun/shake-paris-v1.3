//
//  ShowDetailViewController.h
//  shake paris v1.3
//
//  Created by user on 07/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestauAnnotation.h"
#import "neweuropeViewController.h"
#import "Restaurant.h"
#import <iAd/iAd.h>

@interface ShowDetailViewController : UIViewController 
{
    ADBannerView *bannerView;
}

@property (nonatomic, weak) LocalRestaurant *restaurant;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UILabel *businessHours;
@property (weak, nonatomic) IBOutlet UITextView *telephoneTextView;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UILabel *metroLabel;
-(void)initWithRestaurant:(LocalRestaurant *)restaurant;
@end
