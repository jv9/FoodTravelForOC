//
//  WeatherModel.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/15.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface WeatherModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDictionary *main;;
@property (nonatomic, copy) NSArray *weather;

+ (instancetype) modelWithDict : (NSDictionary *)dict;
@end
