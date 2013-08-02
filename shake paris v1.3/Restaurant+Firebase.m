//
//  Restaurant+Firebase.m
//  shake paris v1.3
//
//  Created by user on 03/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "Restaurant+Firebase.h"

static NSArray *restaurants;
static NSMutableArray *types;

@implementation Restaurant (Firebase)

+ (NSArray *)getRestaurants
{
    if (restaurants) {
        return restaurants;
    }else
        return nil;
}
+ (NSMutableArray *)getRestaurantTypes
{
    if (types) {
        return types;
    }else
    {
        return [Restaurant initTypes];
    }
}

+(NSMutableArray *) initTypes
{
    NSLog(@"初始化类型");
    types = [[NSMutableArray alloc] init];
    for (Restaurant *restau in restaurants) {
        NSString *typeString = restau.type;
        NSArray *typeArray = [typeString componentsSeparatedByString:@","];
        for (unsigned int i = 0; i<[typeArray count]; i++) {
            if ([types containsObject:[typeArray objectAtIndex:i]] == NO){
                [types addObject:[typeArray objectAtIndex:i]];
            }
        }
    }
    NSLog(@"%@",types);
    return types;
}
+(NSArray *)initDistance:(CLLocation *)userlocation withArray:(NSArray *)restaus
{
    for (Restaurant *restaurant in restaus) {
        CLLocation *restauLocation = [[CLLocation alloc] initWithLatitude:restaurant.latitude.doubleValue longitude:restaurant.longitude.doubleValue];
        restaurant.distance = [NSNumber numberWithDouble:[userlocation distanceFromLocation:restauLocation]];
    }
    return restaus;
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
         NSLog(@"%@",[restaurantDictionary objectForKey:@"name"]);
    }else{
        restaurant = [matches lastObject];
    }
    
    return restaurant;
}


@end
