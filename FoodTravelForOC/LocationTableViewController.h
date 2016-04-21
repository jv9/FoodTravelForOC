//
//  LocationTableViewController.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/15.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableViewController : UITableViewController

@property (nonatomic, copy) NSString *selectedCity;
@property (nonatomic, strong) NSMutableArray *cityArray;

@end
