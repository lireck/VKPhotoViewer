//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "LeftViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "LeftViewCell.h"


@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _titlesArray = @[@"Set View Controllers",
                     @"Open Right View",
                     @"",
                     @"Profile",
                     @"News",
                     @"Articles",
                     @"Video",
                     @"Music"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(20.f, 0.f, 20.f, 0.f);
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark -

- (void)openLeftView
{
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)openRightView
{
    [kMainViewController showRightViewAnimated:YES completionHandler:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = _titlesArray[indexPath.row];
    
    cell.tintColor = _tintColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0)
//    {
//        ViewController *viewController = [kNavigationController viewControllers].firstObject;
//        
//        UIViewController *viewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//        viewController2.title = @"Test";
//        
//        [kNavigationController setViewControllers:@[viewController, viewController2]];
//        
//        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
//    }
//    else if (indexPath.row == 1)
//    {
//        if (![kMainViewController isLeftViewAlwaysVisible])
//        {
//            [kMainViewController hideLeftViewAnimated:YES completionHandler:^(void)
//             {
//                 [kMainViewController showRightViewAnimated:YES completionHandler:nil];
//             }];
//        }
//        else [kMainViewController showRightViewAnimated:YES completionHandler:nil];
//    }
//    else
//    {
//        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//        viewController.title = _titlesArray[indexPath.row];
//        [kNavigationController pushViewController:viewController animated:YES];
//        
//        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
//    }
}

@end
