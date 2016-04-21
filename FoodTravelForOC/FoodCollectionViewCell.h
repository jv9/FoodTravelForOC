//
//  FoodCollectionViewCell.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/14.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <UIKit/UIKit.h>


//无此行代码协议无法识别FoodCollectionViewCell类型
@class FoodCollectionViewCell;


//协议设计模式
@protocol FoodCollectionViewCellDelegate <NSObject>

- (void) didLikeButtonPressed: (FoodCollectionViewCell *)cell;

@end

@interface FoodCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<FoodCollectionViewCellDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIImageView *imagaView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) NSNumber *isLike;

- (IBAction)like: (UIButton *)sender;

@end
