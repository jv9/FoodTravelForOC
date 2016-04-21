//
//  FoodTableViewController.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/17.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "FoodTableViewController.h"

@interface FoodTableViewController ()

@property (nonatomic, copy) NSMutableArray *food;
@property  (nonatomic ,copy) NSMutableArray *animation;
@property (nonatomic, copy) NSMutableArray *searchResult;
@property (nonatomic) UISearchController *searchController;
@property (nonatomic) NSFetchedResultsController *fetchedResultController;


@end

@implementation FoodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义导航栏返回键
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem  alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tableView.backgroundColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:235/255.0 alpha:1];
//    self.tableView.backgroundColor = [UIColor blueColor];
    self.tableView.separatorColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:235/255.0 alpha:1];
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
//    //FDTemplateLayoutCell Debug log
//    self.tableView.fd_debugLogEnabled = YES;
    
    //加载Core Data数据
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
//    NSManagedObjectContext *context = [self managedObjectContext];
    self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultController.delegate = self;
    NSError *error;
    if (error) {
        NSLog(@"%@", error);
    }
    [self.fetchedResultController performFetch: &error];
    self.food = [[NSMutableArray alloc] initWithArray:self.fetchedResultController.fetchedObjects];
    //初始化searchResult
    self.searchResult = [NSMutableArray arrayWithCapacity:self.food.count];
    
    //配置searchController
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SearchViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"Search"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    //配置searchBar
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.placeholder = @"寻找你爱的";
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    self.searchController.searchBar.barTintColor = [UIColor grayColor];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)animation {
    if (_animation == nil) {
        _animation = [NSMutableArray array];
        for (NSInteger i = 0; i < 100; i++) {
            [_animation addObject:@(NO)];
        }
    }
    return _animation;
}

- (IBAction)close:(UIStoryboardSegue *)sender {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if ([self.searchController isActive]) {
        return self.searchResult.count;
    } else {
        return self.food.count;
    }
}

////UITableView+FDTemplateLayoutCell
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:@"Cell" configuration:^(FoodTableViewCell *cell) {
//        Food *food = self.searchController.active ? self.searchResult[indexPath.row] : self.food[indexPath.row];
//        cell.nameLabel.text = food.name;
//        cell.locationLabel.text = food.location;
//        cell.typeLabel.text = food.type;
//        cell.thumbImageView.image = [UIImage imageWithData:food.image];
//        cell.accessoryType = food.isVisited.boolValue ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
//    }];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Cell";
    FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    Food *food = self.searchController.active ? self.searchResult[indexPath.row] : self.food[indexPath.row];
    cell.nameLabel.text = food.name;
    cell.locationLabel.text = food.location;
    cell.typeLabel.text = food.type;
    cell.thumbImageView.image = [UIImage imageWithData:food.image];
    cell.thumbImageView.layer.cornerRadius = 10.0;
    cell.thumbImageView.clipsToBounds = YES;
    cell.accessoryType = food.isVisited.boolValue ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

//Cell动画效果
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.animation[indexPath.row]) {
        return;
    }
    self.animation[indexPath.row] = @(YES);
    cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -500, 0, 0);
    [UIView animateWithDuration:1.0 animations:^{
        cell.layer.transform = CATransform3DIdentity;
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.searchController.active) {
        return NO;
    } else {
        return YES;
    }
}

//分享按钮
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"分享" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIAlertController *shareMenu = [UIAlertController alertControllerWithTitle:@"新浪微博" message:@"分享" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *weiboAction = [UIAlertAction actionWithTitle:@"新浪微博" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
                SLComposeViewController *weiboCompose = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
                Food *food = self.food[indexPath.row];
                [weiboCompose setInitialText:food.name];
                [weiboCompose addImage:[UIImage imageWithData:food.image]];
                [self presentViewController:weiboCompose animated:YES completion:nil];
            } else {
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"新浪微博不可用" message:@"未登录系统微博账户" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                [controller addAction:action];
                [self presentViewController:controller animated:YES completion:nil];
                return;
            }
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [shareMenu addAction:weiboAction];
        [shareMenu addAction:cancleAction];
        [self presentViewController:shareMenu animated:YES completion:nil];
    }];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [delegate managedObjectContext];
        Food *foodToDelete = [self.fetchedResultController objectAtIndexPath:indexPath];
        [context deleteObject:foodToDelete];
        NSError *error;
        [context save:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }];
    shareAction.backgroundColor = [UIColor blackColor];
    deleteAction.backgroundColor = [UIColor redColor];
    return [NSArray arrayWithObjects: deleteAction, shareAction, nil];
}

//实时监控Core Data变化情况
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (type == NSFetchedResultsChangeUpdate ) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView reloadData];
    }
    //更新food
    self.food = [[NSMutableArray alloc] initWithArray:controller.fetchedObjects];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = self.searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.name CONTAINS[cd] %@) OR (SELF.location CONTAINS[cd] %@)", searchText, searchText];
//    if(self.searchResult != nil) {
//        [self.searchResult removeAllObjects];
//    }
    NSArray<Food *> *array = self.food;
    self.searchResult = [NSMutableArray arrayWithArray:[array  filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        DetailViewController *controller = [segue destinationViewController];
        controller.food = [self.searchController isActive] ? self.searchResult[indexPath.row] : self.food[indexPath.row];
    }
}


@end
