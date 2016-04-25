//
//  SignViewController.m
//  FoodTravelForOC
//
//  Created by angelorlover on 16/4/12.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

#import "SignViewController.h"

@interface SignViewController ()

@property (nonatomic, weak) IBOutlet UITextField *userTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton *signinButton;
@property (nonatomic, weak) IBOutlet UIView *userView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *signupButton;

@property (nonatomic) Account *account;
@property (nonatomic) FoodFromLeanClound *food;
@property (nonatomic) UIVisualEffectView *blurEffectiveView;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _userTextField.delegate = self;
    _passwordTextField.delegate = self;
    _passwordTextField.secureTextEntry = YES;
    
    //增加背景模糊
    _blurEffectiveView = [[UIVisualEffectView alloc] initWithEffect: [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _blurEffectiveView.frame = _imageView.bounds;
    [_imageView addSubview: _blurEffectiveView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//理解present和dismiss过程

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:YES];
//    NSLog(@"Sign viewWillAppear");
//}
//
//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:YES];
//    NSLog(@"Sign viewDidAppear");
//}
//
//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:YES];
//    NSLog(@"Sign viewWillDisappear");
//}
//
//-(void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:YES];
//    NSLog(@"Sign viewDidDisappear");
//}

//跟随转动方向更新模糊大小
- (void) traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    _blurEffectiveView.frame = self.view.bounds;
}

#pragma mark - TextFieldDelegate
//输入栏切换
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == _userTextField) {
        [_passwordTextField becomeFirstResponder];
    } else {
        [_passwordTextField resignFirstResponder];
    }
    return YES;
}

//textField激活动画
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    _userTextField.returnKeyType = UIReturnKeyNext;
    _passwordTextField.returnKeyType = UIReturnKeyGo;
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionCurlDown animations: ^{
        self.userView.transform = CGAffineTransformMakeTranslation(0, -50);
    } completion:nil];
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionCurlDown animations: ^{
        self.userView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_userTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

// 背景动画，暂时搁置
//- (void)splash {
//    self.imageView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0, 2.0, 1.0);
//    [UIView animateWithDuration: 3.0 animations: ^(void) {
//        self.imageView.layer.transform = CATransform3DIdentity;
//    }];
//    
//}

#pragma mark - 登录

- (IBAction)signin:(UIButton *)sender {
    if ([self.userTextField.text  isEqual: @""] || [self.passwordTextField.text  isEqual: @""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户名或密码不为空" message:@"请输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    AVQuery *query = [AVQuery queryWithClassName:@"Account"];
    [query whereKey:@"username" equalTo:_userTextField.text];
    NSLog(@"获取账户信息");
    [query getFirstObjectInBackgroundWithBlock: ^(AVObject *object, NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error);
        }
        if (object) {
            NSLog(@"获取成功");
            Account *account = [[Account alloc] initWithObject:object];
            if ([account.password isEqualToString:self.passwordTextField.text]) {
                NSLog(@"匹配成功");
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:self.userTextField.text forKey:@"username"];
                [defaults setBool:YES forKey:@"isLogin"];
                [self dismissViewControllerAnimated:YES completion:nil];
//                TabViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Home"];
//                [self presentViewController:controller animated:YES completion:nil];
                
            } else {
                //晃动效果
                
                self.view.transform = CGAffineTransformMakeTranslation(25, 0);
                [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.15 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations: ^{
                    self.view.transform = CGAffineTransformIdentity;
                } completion:nil];
            }
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户名不存在" message:@"请输入" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:action];
            //支持iPad
//            UIPopoverPresentationController * popover = alertController.popoverPresentationController;
//            popover.sourceView = self.view;
//            popover.sourceRect = sender.frame;
            [self presentViewController:alertController animated:YES completion:nil];            
        }
    }];
}

- (IBAction)signup:(UIButton *)sender {
    if ([self.userTextField.text  isEqual: @""] || [self.passwordTextField.text  isEqual: @""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户名或密码不为空" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    AVQuery *query = [AVQuery queryWithClassName:@"Account"];
    [query whereKey:@"username" equalTo:self.userTextField.text];
    NSLog(@"查询用户名是否存在");
    [query findObjectsInBackgroundWithBlock:^(NSArray *objectArray, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
        if (objectArray.count > 0) {
            NSLog(@"%lu",(unsigned long)objectArray.count);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户名已存在" message:@"请重新输入" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            AVObject *object = [[AVObject alloc] initWithClassName:@"Account"];
            [object setObject:self.userTextField.text forKey:@"username"];
            [object setObject:self.passwordTextField.text forKey:@"password"];
            [object saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                }
                if (success) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setValue:self.userTextField.text forKey:@"username"];
                    [defaults setBool:YES forKey:@"isLogin"];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        AVQuery *query = [AVQuery queryWithClassName:@"Test"];
                        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                            if (error) {
                                NSLog(@"%@",error);
                            }
                            if (object) {
                                self.food = [[FoodFromLeanClound alloc] initWithObject:object];
                                NSString *string = [defaults valueForKey:@"username"];
                                AVObject *temp = [[AVObject alloc] initWithClassName:string];
                                [temp setObject:self.food.name forKey:@"name"];
                                [temp setObject:self.food.location forKey:@"location"];
                                [temp setObject:self.food.isLike forKey:@"isLike"];
                                [temp setObject:self.food.image forKey:@"image"];
                                [temp saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                                    if (error) {
                                        NSLog(@"%@",error);
                                    }
                                }];
                                [temp deleteInBackground];
                            }
                        }];
                        TabViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Home"];
                        [self presentViewController:controller animated:YES completion:nil];
                    }];
                    [alertController addAction:action];
                    [self presentViewController:alertController animated:NO completion:nil];
                }
            }];
        }
    }];
}

-(IBAction)visit:(UIButton *)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
//    [self presentViewController:controller animated:YES completion:nil];
    TabViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Home"];
    [self presentViewController:controller animated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
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
