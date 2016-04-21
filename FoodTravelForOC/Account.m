//
//  Account.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/12.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "Account.h"

@implementation Account

- (instancetype) initWithObject:(AVObject *)avobject {
    if (self = [super init]) {
        self.username = avobject[@"username"];
        self.password = avobject[@"password"];
        self.image = avobject[@"image"];
        self.accountID = avobject.objectId;
    }
    return self;
}

- (AVObject *) toAVObeject: (NSString *)className {
    AVObject *avObject = [[AVObject alloc] initWithClassName:className];
    avObject.objectId = _accountID;
    avObject[@"username"] = _username;
    avObject[@"password"] = _password;
    avObject[@"image"] = _image;
    return avObject;
}

@end
