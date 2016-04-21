//
//  WeatherModel.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/15.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

+ (instancetype) modelWithDict:(NSDictionary *)dict {
    WeatherModel *model = [[WeatherModel alloc] init];
    [model mj_setKeyValues:dict];
    return model;
}

@end
