//
//  Restaurant.h
//  shake paris v1.3
//
//  Created by user on 03/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Restaurant : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * xineuropeURL;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * businessHours;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * information;

@end
