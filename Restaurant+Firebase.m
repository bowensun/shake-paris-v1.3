//
//  Restaurant+Firebase.m
//  shake paris v1.3
//
//  Created by user on 03/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "Restaurant+Firebase.h"

static NSArray *restaurants;

@implementation Restaurant (Firebase)

+ (NSArray *)getRestaurants
{
    if (restaurants) {
        return restaurants;
    }else
        return nil;
}
-(void)initDistance:(CLLocation *)userlocation
{
    CLLocation *restauLocation = [[CLLocation alloc] initWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
    //NSLog(@"%@",restauLocation.coordinate.latitude);
    
    self.distance = [NSNumber numberWithDouble:[userlocation distanceFromLocation:restauLocation]];
    //self.distance = [NSNumber numberWithInt:100];
    
}
+(void)setRestaurants:(NSArray *)restaurantsOfMapVC
{
    restaurants = restaurantsOfMapVC;
}
+ (Restaurant *) restaurantWithFirebaseInfo:(NSDictionary *)restaurantDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Restaurant *restaurant = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Restaurant"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@",[restaurantDictionary objectForKey:@"name"]];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1) ) {
        //error
        //NSLog(@"error in class Restaurant function restaurantWithFirebaseInfo");
    }else if ( ![matches count] ){
        restaurant = [NSEntityDescription insertNewObjectForEntityForName:@"Restaurant" inManagedObjectContext:context];
        restaurant.name = [restaurantDictionary objectForKey:@"name"];
        restaurant.address = [restaurantDictionary objectForKey:@"address"];
        restaurant.type = [restaurantDictionary objectForKey:@"type"];
        restaurant.imageURL = [restaurantDictionary objectForKey:@"imageURL"];
        restaurant.telephone = [restaurantDictionary objectForKey:@"telephone"];
        restaurant.information = [restaurantDictionary objectForKey:@"information"];
        restaurant.xineuropeURL= [restaurantDictionary objectForKey:@"xineuropeURL"];
        restaurant.businessHours = [restaurantDictionary objectForKey:@"businessHours"];
        restaurant.latitude = [NSNumber numberWithDouble:[[restaurantDictionary objectForKey:@"latitude"] doubleValue]];
        restaurant.longitude = [NSNumber numberWithDouble:[[restaurantDictionary objectForKey:@"longitude"] doubleValue]];
        restaurant.distance = [NSNumber numberWithDouble:999];
         //NSLog(@"%@",[restaurantDictionary objectForKey:@"longitude"]);
    }else{
        restaurant = [matches lastObject];
    }
    
    return restaurant;
}

@end
