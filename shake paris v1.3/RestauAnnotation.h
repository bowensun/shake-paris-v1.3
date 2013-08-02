//
//  RestauAnnotation.h
//  shake paris v1.3
//
//  Created by user on 28/03/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Restaurant.h"
#import "LocalRestaurant.h"

@interface RestauAnnotation : NSObject <MKAnnotation>

+(RestauAnnotation *) annotationForRestaurant:(LocalRestaurant *)restaurant;
-(UIImage *)thumbnail;
@property (nonatomic,strong) LocalRestaurant *restaurant;
@end
