//
//  RestauAnnotation.m
//  shake paris v1.3
//
//  Created by user on 28/03/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "RestauAnnotation.h"
@implementation RestauAnnotation 
@synthesize restaurant =_restaurant;

+(RestauAnnotation *) annotationForRestaurant:(Restaurant *)restaurant
{
    RestauAnnotation *annotations = [[RestauAnnotation alloc] init];
    annotations.restaurant = restaurant;
    return annotations;
}

-(NSString *)title
{
    return self.restaurant.name;
}

-(NSString *)subtitle
{
    return self.restaurant.address;
}

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.restaurant.latitude doubleValue];
    coordinate.longitude =[self.restaurant.longitude doubleValue];
    return coordinate;
}

-(UIImage *)thumbnail
{
    NSLog(@"Image Url : %@",self.restaurant.imageURL);
    NSURL *url = [NSURL URLWithString:self.restaurant.imageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return data ? [UIImage imageWithData:data] : nil;
    
}
@end
