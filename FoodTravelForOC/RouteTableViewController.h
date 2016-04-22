//
//  RouteTableViewController.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/22.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RouteTableViewController : UITableViewController

@property (nonatomic, copy) NSArray<MKRouteStep *> *routeArray;

@end
