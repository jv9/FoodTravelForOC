//
//  ReviewViewController.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/19.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewViewController : UIViewController

@property (nonatomic, weak)IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak)IBOutlet UIButton *dislikeButton;
@property (nonatomic, weak)IBOutlet UIButton *goodButton;
@property (nonatomic, weak)IBOutlet UIButton *greatButton;
@property (nonatomic, strong)NSString *rating;


@end
