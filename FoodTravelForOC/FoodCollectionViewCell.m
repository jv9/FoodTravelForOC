//
//  FoodCollectionViewCell.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/14.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "FoodCollectionViewCell.h"

@interface FoodCollectionViewCell()

@end

@implementation FoodCollectionViewCell

- (IBAction)like:(UIButton *)sender {
    [self.delegate didLikeButtonPressed:self];
    NSLog(@"2Cell :%i", self.isLike.boolValue);
    if (self.isLike.boolValue) {
        [_likeButton setImage:[UIImage imageNamed:@"heartfull"] forState:UIControlStateNormal];
        _likeButton.imageView.tintColor = [UIColor redColor];
    } else {
        [_likeButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
        _likeButton.imageView.tintColor = [UIColor redColor];
    }
}

- (NSNumber *)isLike {
    if (!_isLike) {
        _isLike = [NSNumber numberWithInt:0];
    }
    return _isLike;
}

- (UIButton *)likeButton {
    if (_likeButton == nil) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _likeButton;
}

@end
