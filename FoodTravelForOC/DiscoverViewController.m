//
//  DiscoverViewController.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/14.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "DiscoverViewController.h"

@interface DiscoverViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSMutableArray *foodLean;
@property (nonatomic) UIVisualEffectView *blurEffectiveView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    // Do any additional setup after loading the view.
    _collectionView.backgroundColor = [UIColor clearColor];
    
    //模糊背景
    _blurEffectiveView = [[UIVisualEffectView alloc] initWithEffect: [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _blurEffectiveView.frame = self.view.bounds;
    [_imageView addSubview:_blurEffectiveView];
    
    //上滑手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action: @selector(deleteCell:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    swipe.delegate = self;
    [self.collectionView addGestureRecognizer:swipe];
    
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action: @selector(saveImage:)];
    longPress.delegate = self;
    [self.collectionView addGestureRecognizer:longPress];
    
}

//懒加载
- (NSMutableArray *)foodLean {
    if (_foodLean == nil) {
        _foodLean = [NSMutableArray arrayWithCapacity:100];
    }
    return _foodLean;
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
}

//登录判断
//- (void)viewDidAppear:(BOOL)animated {
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
//        return;
//    }
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"More" bundle:nil];
//    SignViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"Sign"];
//    [self presentViewController:controller animated:YES completion:nil];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 下载数据

- (void) loadData {
    [self.foodLean removeAllObjects];
    [self.collectionView reloadData];
    NSString *name = @"Food";
    AVQuery *query = [AVQuery queryWithClassName:name];
    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@%@", error, error.userInfo);
        }
        if (objects) {
//            self.foodLean = [NSMutableArray arrayWithCapacity:objects.count];
            for (NSInteger i = 0; i < objects.count; i++) {
                AVObject *object = objects[i];
                FoodFromLeanClound *food = [[FoodFromLeanClound alloc] initWithObject:object];
//                [self.foodLean addObject:food];
                self.foodLean[i] = food;
                NSIndexPath *temp = [NSIndexPath indexPathForRow:i inSection:0];
                NSArray *indexTemp = [NSArray arrayWithObjects:temp, nil];
                [self.collectionView insertItemsAtIndexPaths:indexTemp];
                NSLog(@"%@", indexTemp);
                NSLog(@"%ld",(long)i);
                NSLog(@"数据获取成功");
            }
            [self.collectionView reloadData];
            NSLog(@"%lu", self.foodLean.count);
            NSLog(@"%ld",(long)[self collectionView:self.collectionView numberOfItemsInSection:0]);
        } else {
            NSLog(@"数据获取失败");
        }
    }];
}

//删除Cell
- (void) deleteCell: (UISwipeGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.collectionView];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:point];
        if (indexPath) {
            [[_foodLean[indexPath.row] toAVObject:@"Food"] deleteInBackgroundWithBlock: ^(BOOL success, NSError *error) {
                if (error) {
                    NSLog(@"删除数据失败");
                }
                if (success) {
                    NSLog(@"已删除数据");
                }
                [_foodLean removeObjectAtIndex:indexPath.row];
                
                [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
                
            }];
        }
    }
    
}

//保存图片

- (void) saveImage: (UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.collectionView];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存图片至图库" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:point];
            if (indexPath) {
                FoodFromLeanClound *object = _foodLean[indexPath.row];
                AVFile *image = object.image;
                if (image) {
                    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], nil, nil, nil);
                        NSLog(@"图片保存成功");
                    }];
                }
            }
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction: enterAction];
        [alertController addAction: cancleAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//点赞
- (void) didLikeButtonPressed: (FoodCollectionViewCell *)cell {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        if (indexPath) {
            FoodFromLeanClound *object = _foodLean[indexPath.row];
            object.isLike = object.isLike.boolValue ?  @(0) : @(1);
            cell.isLike = object.isLike;
            NSLog(@"1Cell :%i", cell.isLike.boolValue);
            NSLog(@"isLike:%@",cell.isLike);
            [[object toAVObject:@"Food"] saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                if (error) {
                    NSLog(@"点赞失败");
                }
                if (success) {
                    NSLog(@"已点赞");
                }
            }];
        }
}

//更新(存在bug)
- (IBAction)refresh:(id)sender {
    [self loadData];
}



#pragma mark - Data Source

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.foodLean.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FoodCollectionViewCell *cell = (FoodCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.delegate = self;
    FoodFromLeanClound *object = _foodLean[indexPath.row];
    cell.nameLabel.text = object.name;
    cell.locationLabel.text = object.location;
    cell.isLike = object.isLike;
    cell.layer.cornerRadius = 4.0;
    AVFile *temp = object.image;
    if (temp) {
        [temp getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error != nil) {
                NSLog(@"获取图片失败");
            }
            if (data) {
                cell.imagaView.image = [UIImage imageWithData:data];
                NSLog(@"成功获取图片");
            }
        }];
    }
    return cell;
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
