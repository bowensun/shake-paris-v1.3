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

@interface ShowDetailViewController : UIViewController <ADBannerViewDelegate>
{
    ADBannerView *bannerView;
}

@property (nonatomic, weak) Restaurant *restaurant;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UILabel *businessHours;
@property (weak, nonatomic) IBOutlet UITextView *informationTextView;
@property (weak, nonatomic) IBOutlet UITextView *telephoneTextView;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
-(void)initWithRestaurant:(Restaurant *)restaurant;
@end