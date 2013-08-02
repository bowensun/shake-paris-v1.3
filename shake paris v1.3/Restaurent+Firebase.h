//
//  Restaurant+Firebase.h
//  shake paris v1.3
//
//  Created by user on 17/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "Restaurent.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface Restaurent (Firebase)
+(NSArray *)getRestaurants;
+(void)setRestaurants:(NSArray *)restaurantsOfMapVC;
+ (Restaurent *) restaurantWithFirebaseInfo:(NSDictionary *)restaurantDictionary inManagedObjectContext:(NSManagedObjectContext *)context;
-(void)initDistance:(CLLocation *)userlocation;
@end

