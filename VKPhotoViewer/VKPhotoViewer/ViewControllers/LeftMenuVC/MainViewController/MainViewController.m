//
//  MainViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 25.04.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "MainViewController.h"
#import "LeftViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface MainViewController ()

@property (strong, nonatomic) LeftViewController *leftViewController;

@end

@implementation MainViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"navigation"];
    _leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];

        [self setLeftViewEnabledWithWidth:250.f
                        presentationStyle:LGSideMenuPresentationStyleSlideBelow
                     alwaysVisibleOptions:0];
    _leftViewController.tableView.backgroundColor = NAVIGATION_BAR_TINT_COLOR;
        _leftViewController.tintColor = [UIColor whiteColor];
        [_leftViewController.tableView reloadData];
        [self.leftView addSubview:_leftViewController.tableView];
    
}



- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size
{
    [super leftViewWillLayoutSubviewsWithSize:size];
     _leftViewController.tableView.frame = CGRectMake(0.f , 0.f, size.width, size.height);
}


@end
