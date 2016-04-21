//
//  ReviewViewController.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/19.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "ReviewViewController.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    [self.backgroundImageView addSubview:blurEffectView];
    
    //动画效果
    CGAffineTransform scale = CGAffineTransformMakeScale(0.0, 0.0);
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0, 400);
    self.dislikeButton.transform = CGAffineTransformConcat(scale, translate);
    self.goodButton.transform = CGAffineTransformConcat(scale, translate);
    self.greatButton.transform = CGAffineTransformConcat(scale, translate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:UIViewAnimationOptionTransitionNone animations:^(void) {
        self.dislikeButton.transform = CGAffineTransformIdentity;
    } completion:nil];
    [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:UIViewAnimationOptionTransitionNone animations:^(void) {
        self.goodButton.transform = CGAffineTransformIdentity;
    } completion:nil];
    [UIView animateWithDuration:0.5 delay:0.4 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:UIViewAnimationOptionTransitionNone animations:^(void) {
        self.greatButton.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

- (IBAction)rating:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            self.rating = @"dislike";
            break;
        case 200:
            self.rating = @"good";
            break;
        case 300:
            self.rating = @"great";
            break;
        default:
            break;
    }
    [self performSegueWithIdentifier:@"unwindToDetailView" sender:sender];
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
