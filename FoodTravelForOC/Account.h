//
//  Account.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/12.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic) AVFile *image;
@property (nonatomic, copy) NSString *accountID;

- (instancetype) initWithObject: (AVObject *)avobject;
- (AVObject *) toAVObeject: (NSString *)className;

@end
