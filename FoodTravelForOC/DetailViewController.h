//
//  DetailViewController.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/19.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTableViewCell.h"
#import "Food.h"
#import "MapViewController.h"
#import "ReviewViewController.h"
#import "AppDelegate.h"

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *foodImageView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *ratingButton;

@property (nonatomic) Food *food;

@end
