//
//  FoodFromLeanClound.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/13.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodFromLeanClound : NSObject

@property (nonatomic, copy) NSString *foodId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *rating;
@property (nonatomic, copy) NSNumber *isLike;
@property (nonatomic) AVFile *image;


- (instancetype) initWithObject:(AVObject *)avobject;
- (AVObject *)toAVObject : (NSString *)className;

@end
