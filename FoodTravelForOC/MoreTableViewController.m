//
//  MoreTableViewController.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/13.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "MoreTableViewController.h"

@interface MoreTableViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak) IBOutlet UILabel *userLabel;

@property (nonatomic) Account *account;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *sectionContent;
@property (nonatomic, strong) NSArray *links;

@end

@implementation MoreTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.userImageView.layer.cornerRadius = 25;
    self.userImageView.clipsToBounds = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//懒加载（重写get）

//- (Account *)account
//{
//    if (_account == nil) {
//        _account = [[Account alloc] init];
//    }
//    return _account;
//}

//懒加载（重写get）
- (NSArray *)sectionTitles
{
    if (_sectionTitles == nil) {
        _sectionTitles = [NSArray arrayWithObjects: @"敬请反馈", @"关注我们", @"帮助", nil];
    }
    return _sectionTitles;
}

//懒加载（重写get）
- (NSArray *)sectionContent {
    if (_sectionContent == nil) {
        _sectionContent = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects: @"您的意见", nil], [NSArray arrayWithObjects: @"微博", @"推特", @"脸书", nil], [NSArray arrayWithObjects: @"欢迎页", nil], nil];
    }
    return _sectionContent;
}

//懒加载（重写get）
- (NSArray *)links
{
    if (_links == nil) {
        _links = [NSArray arrayWithObjects: @"http://weibo.com/wuzhangyong", @"https://twitter.com/angelorlover", @"https://facebook.com/angelorlover", nil];
    }
    return _links;
}

- (void) viewWillAppear:(BOOL)animated {
    [self loadUserFromLeanCloud];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _Bool isLogin = [defaults boolForKey:@"isLogin"];
    if (isLogin) {
        self.navigationItem.rightBarButtonItem.title = @"注销";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"登录";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadUserFromLeanCloud {
    AVQuery *query = [AVQuery queryWithClassName:@"Account"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        [query whereKey:@"username" equalTo:username];
        query.cachePolicy = kAVCachePolicyNetworkElseCache;
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (error != nil) {
                NSLog(@"Error:%@%@",error,error.userInfo);
            }
            if (object != nil) {
                NSLog(@"成功获取数据");
                self.account = [[Account alloc] initWithObject:object];
                AVFile *image = self.account.image;
                if (image != nil) {
                    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (data != nil) {
                            NSLog(@"成功获取图片");
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                            self.userImageView.image = [UIImage imageWithData:data];
                            }];
                        } else {
                            NSLog(@"图片获取失败");
                        }
                    }];
                }
                NSString *username = self.account.username;
                if (username != nil) {
                    self.userLabel.text = username;
                }
            } else {
                NSLog(@"数据获取失败");
            }
        }];
    } else {
        self.userImageView.image = [UIImage imageNamed:@"photoalbum"];
        self.userLabel.text = @"用户名";
    }
}

- (IBAction)log:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        self.navigationItem.rightBarButtonItem.title = @"登录";
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"username"];
        self.userImageView.image = [UIImage imageNamed:@"photoalbum"];
        self.userLabel.text = @"用户名";
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
    }
//    [self loadUserFromLeanCloud];
}

- (IBAction) refreshAccount:(UIRefreshControl *)sender {
    [self loadUserFromLeanCloud];
    [sender endRefreshing];
}

- (IBAction)takePhoto:(id)sender {
    UIAlertController *menu = [UIAlertController alertControllerWithTitle:@"" message:@"选项" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    [menu addAction:cameraAction];
    [menu addAction:photoAction];
    [menu addAction:cancle];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        [self presentViewController:menu animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未登录" message:@"请登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//更新用户图片(仅限首次上传图片)
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    self.userImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.userImageView.clipsToBounds = YES;
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    AVFile *imageFile = [AVFile fileWithName:[username stringByAppendingString:@".jpg"] data: data];
    [self dismissViewControllerAnimated:YES completion:^(void) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
            AVObject *object = [self.account toAVObeject:@"Account"];
            [object setObject:imageFile forKey:@"image"];
            [object saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                if (error != nil) {
                    NSLog(@"%@", error);
                    NSLog(@"上传失败");
                }
                if (success) {
                    //更新图片成功提示
                    [self loadUserFromLeanCloud];
                    NSLog(@"上传成功");
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确实" style:UIAlertActionStyleCancel handler:nil];
//                    [alertController addAction:alertAction];
//                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未登录" message:@"请登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

#pragma mark - clear cache
//多线程清理缓存

//- (void)clearCache {
//    dispatch_async(
//                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
//        NSLog(@"files: %lu", (unsigned long)[files count]);
//        for (NSString *file in files) {
//            NSError *error;
//            NSString *path = [cachePath stringByAppendingPathComponent:file];
//            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//            }
//        }
//        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
//    });
//}

//-(void)clearCacheSuccess
//{
//    NSLog(@"已清理缓存");
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已清除缓存" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//    [alertController addAction:alertAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 1;
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.sectionContent[indexPath.section][indexPath.row];
//    cell.textLabel.text = @"go";
    return cell;
}

#pragma mark - Table view delegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            NSURL *url = [NSURL URLWithString:@"http://weibo.com/wuzhangyong"];
//            [[UIApplication sharedApplication] openURL:url];
//        }
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"showWebView" sender:self];
        }
    } else if (indexPath.section == 1) {
        NSURL *url = [NSURL URLWithString:self.links[indexPath.row]];
        SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:YES];
        [self presentViewController:safariController animated:YES completion:nil];
    } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WelcomePageViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"Welcome"];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
