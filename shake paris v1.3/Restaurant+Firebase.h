//
//  Restaurant+Firebase.h
//  shake paris v1.3
//
//  Created by user on 03/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "Restaurant.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Restaurant (Firebase) 
+(NSArray *)getRestaurants;
+(NSMutableArray *) initTypes;
+(NSMutableArray *)getRestaurantTypes;
+(void)setRestaurants:(NSArray *)restaurantsOfMapVC;
+ (Restaurant *) restaurantWithFirebaseInfo:(NSDictionary *)restaurantDictionary inManagedObjectContext:(NSManagedObjectContext *)context;
+(NSArray *)initDistance:(CLLocation *)userlocation withArray:(NSArray *)restaus;
@end
