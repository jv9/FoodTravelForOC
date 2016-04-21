//
//  LauchViewController.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/20.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "LauchViewController.h"

@interface LauchViewController ()

@property (nonatomic,weak) IBOutlet UIImageView *imageView;

@end

@implementation LauchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.alpha = 0.0;
    // Do any additional setup after loading the view.
    [self splash];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) splash {
    self.imageView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0, 2.0, 2.0);
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void) {
        self.imageView.alpha = 1.0;
        self.imageView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        [self performSegueWithIdentifier:@"showHome" sender:nil];
    }];    
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
