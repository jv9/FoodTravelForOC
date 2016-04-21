//
//  FoodTableViewController.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/17.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
//#import "UITableView+FDTemplateLayoutCell.h"
#import "Food.h"
#import "FoodTableViewCell.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@interface FoodTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchResultsUpdating>

@end