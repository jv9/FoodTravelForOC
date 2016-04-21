//
//  WelcomePageViewController.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/16.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "WelcomePageViewController.h"

@interface WelcomePageViewController ()

@end

@implementation WelcomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = self;
    //首次展示
    UIViewController *controller = [self viewControllerAtIndex:0];
    NSArray<UIViewController *> *controllers = [NSArray arrayWithObject:controller];
    [self setViewControllers:controllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)pageImage {
    if (_pageImage == nil) {
        _pageImage = [NSMutableArray array];
    }
    _pageImage = [@[@"view-1", @"view-2", @"view-3"] mutableCopy];
    return _pageImage;
}

- (NSMutableArray *)pageFooting {
    if (_pageFooting == nil) {
        _pageFooting = [NSMutableArray array];
    }
    _pageFooting = [@[@"收藏你最爱的", @"定位你喜欢的", @"发现你想要的"] mutableCopy];
    return _pageFooting;
}

#pragma mark - DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [(WelcomeViewController *)viewController index];
    index++;
    UIViewController *controller = [self viewControllerAtIndex:index];
    return controller;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [(WelcomeViewController *)viewController index];
    index--;
    UIViewController *controller = [self viewControllerAtIndex:index];
    return controller;
}

- (UIViewController *)viewControllerAtIndex: (NSInteger)index {
    if ( index == NSNotFound || index < 0 || index >= self.pageFooting.count) {
        NSLog(@"%lu", (unsigned long)self.pageFooting.count);
         NSLog(@"hehe");
        return nil;
    }
    WelcomeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    controller.image = self.pageImage[index];
    controller.footing = self.pageFooting[index];
    controller.index = index;
    return controller;
}

- (void) forward: (NSInteger)index {
    NSArray *controllerArray = [NSArray arrayWithObject:[self viewControllerAtIndex:index+1]];
    [self setViewControllers:controllerArray direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
