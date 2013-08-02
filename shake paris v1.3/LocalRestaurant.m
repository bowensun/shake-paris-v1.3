//
//  LocalRestaurant.m
//  shake paris v1.3
//
//  Created by user on 23/06/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "LocalRestaurant.h"

static NSMutableArray *restaurants;
static NSMutableArray *types;

@implementation LocalRestaurant

+(NSMutableArray *)getRestaurants
{
    return restaurants;
}

+(void)setRestaurants : (NSMutableArray *)arrayRestaurants
{
    if ([arrayRestaurants count]!=0) {
        restaurants = arrayRestaurants;
    }else{
        NSLog(@"赋值出错");
    }
}

-(LocalRestaurant *)initWithDictionary:(NSDictionary *)restaurantDictionary
{
    self.name = [restaurantDictionary objectForKey:@"name"];
    self.address = [restaurantDictionary objectForKey:@"address"];
    self.type = [restaurantDictionary objectForKey:@"type"];
    self.imageURL = [restaurantDictionary objectForKey:@"imageURL"];
    self.telephone = [restaurantDictionary objectForKey:@"telephone"];
    self.information = [restaurantDictionary objectForKey:@"information"];
    self.xineuropeURL= [restaurantDictionary objectForKey:@"xineuropeURL"];
    self.businessHours = [restaurantDictionary objectForKey:@"businessHours"];
    self.latitude = [NSNumber numberWithDouble:[[restaurantDictionary objectForKey:@"latitude"] doubleValue]];
    self.longitude = [NSNumber numberWithDouble:[[restaurantDictionary objectForKey:@"longitude"] doubleValue]];
    self.distance = [NSNumber numberWithDouble:999];
    NSLog(@"%@",[restaurantDictionary objectForKey:@"name"]);
    
    return self;
}

+(NSMutableArray *) initTypes
{
    NSLog(@"初始化类型");
    types = [[NSMutableArray alloc] init];
    for (LocalRestaurant *restau in restaurants) {
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

+(NSMutableArray *)getRestaurantTypes
{
    if (types) {
        return types;
    }else{
        return [LocalRestaurant initTypes];
    }
}

+(NSArray *)initDistance:(CLLocation *)userlocation withArray:(NSArray *)restaus
{
    for (LocalRestaurant *restaurant in restaus) {
        CLLocation *restauLocation = [[CLLocation alloc] initWithLatitude:restaurant.latitude.doubleValue longitude:restaurant.longitude.doubleValue];
        restaurant.distance = [NSNumber numberWithDouble:[userlocation distanceFromLocation:restauLocation]];
    }
    return restaus;
}

//从本地文件读取数据
+(void)loadLocalData
{
    if (!restaurants) {
        restaurants = [[NSMutableArray alloc] init];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shakeparis-export" ofType:@"json"];
    NSData *jdata = [[NSData alloc] initWithContentsOfFile:path];
    //NSLog(@"long of the jdata = %d",[jdata length]);
    NSError *e = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jdata options:kNilOptions error:&e];
    if (!jsonArray) {
        //NSLog(@"Error parsing JSON: %@",e);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"加载本地文件失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [LocalRestaurant setRestaurants:[LocalRestaurant convertNSDictionaryArrayToRestaurantArray:jsonArray]];
    }
    NSLog(@"%d",[restaurants count]);
}

//将本地文件中读取的字典类数组文件转换成餐馆类数组
+(NSMutableArray *)convertNSDictionaryArrayToRestaurantArray: (NSArray *)array
{
    if (!array||[array count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"本地文件数组转换出错" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }else{
        for (NSDictionary *item in array) {
            LocalRestaurant *restaurant = [[LocalRestaurant alloc] init];
            restaurant = [restaurant initWithDictionary:item];
            [restaurants addObject:restaurant];
        }
        return restaurants;
    }
}

@end
