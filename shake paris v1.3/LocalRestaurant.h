//
//  LocalRestaurant.h
//  shake paris v1.3
//
//  Created by user on 23/06/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocalRestaurant : NSObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * businessHours;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * information;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * xineuropeURL;
@property (nonatomic, retain) NSNumber * distance;

+(NSMutableArray *)getRestaurants;
+(void)setRestaurants : (NSMutableArray *)arrayRestaurants;
+(NSMutableArray *) initTypes;
+(NSMutableArray *)getRestaurantTypes;
+(NSArray *)initDistance:(CLLocation *)userlocation withArray:(NSArray *)restaus;
+(void)loadLocalData;
+(NSMutableArray *)convertNSDictionaryArrayToRestaurantArray: (NSArray *)array;

@end
