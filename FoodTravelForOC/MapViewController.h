//
//  MapViewController.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/19.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Food.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic)IBOutlet MKMapView *mapView;
@property (nonatomic)Food *food;

@end
