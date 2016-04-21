//
//  FoodFromLeanClound.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/13.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "FoodFromLeanClound.h"

@implementation FoodFromLeanClound

- (instancetype) initWithObject:(AVObject *)avobject {
    if (self = [super init]) {
        self.foodId = avobject.objectId;
        self.name = avobject[@"name"];
        self.type = avobject[@"type"];
        self.location = avobject[@"location"];
        self.rating = avobject[@"rating"];
        self.isLike = avobject[@"isLike"];
        self.image = avobject[@"image"];
    }
    return self;
}

-(AVObject *)toAVObject:(NSString *)className {
    AVObject *avObject = [AVObject objectWithClassName:className];
    avObject.objectId = _foodId;
    avObject[@"name"] = _name;
    avObject[@"type"] = _type;
    avObject[@"location"] = _location;
    avObject[@"rating"] = _rating;
    avObject[@"isLike"] = _isLike;
    avObject[@"image"] = _image;    
    return avObject;
}

@end
