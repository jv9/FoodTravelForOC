//
//  FoodTableViewCell.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/17.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodTableViewCell : UITableViewCell

@property (nonatomic, weak)IBOutlet UILabel *nameLabel;
@property (nonatomic, weak)IBOutlet UILabel *locationLabel;
@property (nonatomic, weak)IBOutlet UILabel *typeLabel;
@property (nonatomic, weak)IBOutlet UIImageView *thumbImageView;

@end
