//
//  WelcomeViewController.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/16.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@property (nonatomic, weak) IBOutlet UILabel *footingLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic ,weak) IBOutlet UIButton *forwardButton;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControll;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _footingLabel.text = _footing;
    _imageView.image = [UIImage imageNamed:_image];
    _pageControll.currentPage = _index;
    if (_index == 0 || _index == 1) {
        [_forwardButton setTitle:@"下页" forState:UIControlStateNormal];
    } else if (_index == 2) {
        [_forwardButton setTitle:@"进入应用" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonTap:(UIButton *)sender {
    if (_index == 0 || _index == 1) {
        WelcomePageViewController * pageViewController = (WelcomePageViewController *)[self parentViewController];
        [pageViewController forward:_index];
    }
    if (_index == 2) {
        TabViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
        [self presentViewController:controller animated:YES completion:nil];
    }
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
