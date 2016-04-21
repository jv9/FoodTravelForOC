//
//  WelcomePageViewController.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/16.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeViewController.h"

@interface WelcomePageViewController : UIPageViewController <UIPageViewControllerDataSource>

@property (nonatomic, strong)NSMutableArray *pageImage;
@property (nonatomic, strong)NSMutableArray *pageFooting;
@property (nonatomic) NSInteger index;

- (void)forward:(NSInteger)index;
@end
