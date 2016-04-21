//
//  AddTableViewController.h
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/18.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
#import "AppDelegate.h"
#import "UIScrollView+EmptyDataSet.h"

@interface AddTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *typeTextFiled;
@property (nonatomic, weak) IBOutlet UITextField *locationTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UIButton *yesButton;
@property (nonatomic, weak) IBOutlet UIButton *noButton;

@end
