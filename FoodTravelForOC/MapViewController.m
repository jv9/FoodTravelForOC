//
//  MapViewController.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/19.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLPlacemark *currentPlacemark;
@property (nonatomic, strong) MKRoute *currentRoute;
@property (nonatomic) MKDirectionsTransportType currentTransportType;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.segmentedControl.hidden = YES;
    self.mapView.delegate = self;
    //查询定位权限
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    }
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:self.food.location completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        //获取地标
        CLPlacemark *placemark = placemarks[0];
        self.currentPlacemark = placemark;
        //增加地图注释
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.title = self.food.name;
        annotation.subtitle = self.food.type;
        annotation.coordinate = placemark.location.coordinate;
        [self.mapView showAnnotations:@[annotation] animated:YES];
        [self.mapView selectAnnotation:annotation animated:YES];
    }];
    //segmnetcontrol添加方法
    [self.segmentedControl addTarget:self action:@selector(showRoute:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSString *identifier = @"Food";
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    view.image = [UIImage imageWithData:self.food.image];
    annotationView.leftCalloutAccessoryView = view;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.canShowCallout = YES;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"showRoute" sender:view];
}

- (IBAction)showRoute:(UIButton *)sender {
    if (!self.currentPlacemark) {
        return;
    }
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.currentTransportType = MKDirectionsTransportTypeAutomobile;
            break;
        case 1:
            self.currentTransportType = MKDirectionsTransportTypeWalking;
            break;
        default:
            break;
    }
    self.segmentedControl.hidden = NO;
    MKDirectionsRequest *directionRequest = [[MKDirectionsRequest alloc] init];
    directionRequest.source = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc]initWithPlacemark:self.currentPlacemark];
    directionRequest.destination = [[MKMapItem alloc]initWithPlacemark:destinationPlacemark];
    directionRequest.transportType = self.currentTransportType;
    MKDirections *direction = [[MKDirections alloc] initWithRequest:directionRequest];
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        //显示路线
        MKRoute *route = response.routes[0];
        self.currentRoute = route;
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        //自动缩放显示区域
        [self.mapView setRegion:MKCoordinateRegionForMapRect(route.polyline.boundingMapRect) animated:YES];
    }];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    render.strokeColor = (self.currentTransportType == MKDirectionsTransportTypeWalking) ? [UIColor blueColor] : [UIColor redColor];
    render.lineWidth = 3.0;
    return render;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showRoute"]) {
        RouteTableViewController *controller = segue.destinationViewController;
        controller.routeArray = self.currentRoute.steps;
    }
}


@end
