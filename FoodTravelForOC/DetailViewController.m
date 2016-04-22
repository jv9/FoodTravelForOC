//
//  DetailViewController.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/19.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.foodImageView.image = [UIImage imageWithData:self.food.image];
    self.tableView.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:1];
    self.tableView.separatorColor = [UIColor colorWithRed:133.0/255.0 green:206.0/255.0 blue:235.0/255.0 alpha:1];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.estimatedRowHeight = 40.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.title = self.food.name;
    if (self.food.rating) {
        [self.ratingButton setImage:[UIImage imageNamed:self.food.rating] forState:UIControlStateNormal];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.hidesBarsOnSwipe = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Cell";
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.fieldLabel.textColor = [UIColor grayColor];
    cell.valuelabel.textColor = [UIColor grayColor];
    switch (indexPath.row) {
        case 0:
            cell.fieldLabel.text = @"名字";
            cell.valuelabel.text = self.food.name;
            break;
        case 1:
            cell.fieldLabel.text = @"类别";
            cell.valuelabel.text = self.food.type;
            break;
        case 2:
            cell.fieldLabel.text = @"地址";
            cell.valuelabel.text = self.food.location;
            break;
        case 3:
            cell.fieldLabel.text = @"来过";
            cell.valuelabel.text = self.food.isVisited ? @"是" : @"否";
            break;
        case 4:
            cell.fieldLabel.text = @"联系电话";
            cell.valuelabel.text = self.food.phoneNumber;
            break;
        default:
            cell.fieldLabel.text = @"";
            cell.valuelabel.text = @"";
            break;
    }
    return cell;
}

- (IBAction)close:(UIStoryboardSegue *)sender {
    ReviewViewController *controller = sender.sourceViewController;
    self.food.rating = controller.rating;
    if (controller.rating) {
        [self.ratingButton setImage:[UIImage imageNamed:controller.rating] forState:UIControlStateNormal];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        NSError *error;
        [context save:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }    
}

- (IBAction)upload:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults valueForKey:@"username"];
    AVObject *newFood = [AVObject objectWithClassName:string];
    [newFood setObject:self.food.name forKey:@"name"];
    [newFood setObject:@(0) forKey:@"isLike"];
    [newFood setObject:self.food.location forKey:@"location"];
    AVFile *image = [AVFile fileWithName:[self.food.name stringByAppendingString:@".jpg"] data:self.food.image];
    [newFood setObject:image forKey:@"image"];
    [newFood saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if (error) {
            NSLog(@"上传失败");
            NSLog(@"%@",error);
        }
        if (success) {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"上传成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [controller addAction:action];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMap"]) {
        MapViewController *controller = (MapViewController *)[segue destinationViewController];
        controller.food = self.food;
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
