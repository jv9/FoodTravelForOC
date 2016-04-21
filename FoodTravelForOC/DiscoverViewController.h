//
//  DiscoverViewController.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/14.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodFromLeanClound.h"
#import "FoodCollectionViewCell.h"
#import "SignViewController.h"
#import "UIScrollView+EmptyDataSet.h"


@interface DiscoverViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, FoodCollectionViewCellDelegate, UIGestureRecognizerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (void) didLikeButtonPressed: (FoodCollectionViewCell *)cell;

@end
