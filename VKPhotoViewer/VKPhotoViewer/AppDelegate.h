//
//  AppDelegate.h
//  VKPhotoViewer
//
//  Created by Admin on 07.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMainViewController [[(MainViewController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController] childViewControllers] objectAtIndex:1]
#define kNavigationController (UINavigationController *)[(MainViewController *)[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

