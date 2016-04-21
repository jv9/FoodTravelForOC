//
//  WeatherViewController.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/15.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()

@property (nonatomic, weak) IBOutlet UILabel *cityLabel;
@property (nonatomic, weak) IBOutlet UILabel *temperatureLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, copy) NSString *currentLocation;
@property (nonatomic, copy) NSString *weatherAPI;


@end

@implementation WeatherViewController

- (NSString *) currentLocation {
    if (_currentLocation == nil) {
        _currentLocation = [[NSUserDefaults standardUserDefaults] valueForKey:@"weathercity"];
    }
    return _currentLocation;
}
//
//- (NSString *)weatherAPI {
//    if (_weatherAPI == nil) {
//        _weatherAPI = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&appid=b1b15e88fa797225412429c1c50c122a", _currentLocation];
//    }
//    return _weatherAPI;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getWeather];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWeather {
    self.currentLocation = (self.currentLocation == nil) ? @"Tokyo" : self.currentLocation;
    NSLog(@"%@",self.currentLocation);
    self.cityLabel.text = self.currentLocation;
    self.weatherAPI = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&appid=66890b227ff7c3a88180cb030f2dc9b2", self.currentLocation];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:self.weatherAPI]];
    NSLog(@"%@",self.weatherAPI);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@%@", error, self.weatherAPI);
        }
        if (data) {
            NSError *jsonError;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            NSLog(@"%@",dict);
            if (jsonError) {
                NSLog(@"haha%@",jsonError.localizedDescription);
            }
            WeatherModel *model = [WeatherModel modelWithDict:dict];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                double number = [[model.main valueForKey:@"temp"] doubleValue] - 273.15;
                self.temperatureLabel.text = [NSString stringWithFormat:@"%.0f°",number];
                self.detailLabel.text =[NSString stringWithFormat:@"%@",[model.weather[0] valueForKey:@"description"]];
            }];
        }
    }];
    [task resume];
}

- (IBAction)unwindToHome:(UIStoryboardSegue *)sender {
    
}

- (IBAction)getCity:(UIStoryboardSegue *)sender {
    LocationTableViewController *controller = sender.sourceViewController;
    self.currentLocation = controller.selectedCity;
    [self getWeather];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ( [segue.identifier  isEqual: @"showLocation"]) {
        UINavigationController *destinationController = segue.destinationViewController;
        LocationTableViewController *controller = destinationController.viewControllers[0];
        controller.selectedCity = self.cityLabel.text;
    }
}


@end
