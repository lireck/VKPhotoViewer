//
//  EECustomTableHeaderView.h
//  VKPhotoViewer
//
//  Created by admin on 9/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EECustomTableHeaderViewDelegate <NSObject>
-(void)logOut;
@end



@interface EECustomTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) id <EECustomTableHeaderViewDelegate> delegate;
@end
