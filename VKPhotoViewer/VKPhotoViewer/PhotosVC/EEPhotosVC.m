//
//  EEPhotosVC.m
//  VKPhotoViewer
//
//  Created by admin on 8/7/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEPhotosVC.h"
#import "EEPhotoCell.h"
#import "EEAppManager.h"
#import "EEPhoto.h"
#import "UIImageView+Haneke.h"



@interface EEPhotosVC ()

@end

@implementation EEPhotosVC

static NSString * const reuseIdentifier = @"PhotoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _photosList = [[NSMutableArray alloc] init];
    _count = 60;
    _offset = 0;
    _user = [[EEAppManager sharedAppManager] currentFriend];
    _album = [[EEAppManager sharedAppManager] currentAlbum];
    self.navigationItem.title = _album.albumTitle;
    [self updateDataWithCount:_count Offset:_offset AlbumId:_album.albumID UserId:_user.userId];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   }


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [_photosList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [collectionView numberOfItemsInSection:0]-1 && _loadedPhotosCount == _count){
        [self updateDataWithCount:_count Offset:_offset AlbumId:_album.albumID UserId:_user.userId];
    }
    
    EEPhotoCell *lCell = (EEPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    lCell.layer.shouldRasterize = YES;
//    lCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    lCell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
    EEPhoto *lPhoto = [_photosList objectAtIndex:indexPath.row];
    
    [lCell.imageView hnk_setImageFromURL:[NSURL URLWithString:lPhoto.sPhotoLink ] placeholder:[UIImage imageNamed:@"placeholder"]];
    
//    [[EEAppManager sharedAppManager] getPhotoByLink:lPhoto.smallPhotoLink withCompletion:^(UIImage *image, BOOL animated) {
//        
//        
//        if (animated){
//            [UIView transitionWithView:lCell.imageView duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//                
//                lCell.imageView.image = image;
//                
//            } completion:nil];
//            
//        }
//        else{
//            lCell.imageView.image = image;
//        }
//
//    }];
    
        return lCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"PhotoView"];
    [[self navigationController] pushViewController:lViewController animated:YES];
    [EEAppManager sharedAppManager].currentPhotoIndex = indexPath.row;
    [EEAppManager sharedAppManager].allPhotos = _photosList;
    [EEAppManager sharedAppManager].currentPhoto = [_photosList objectAtIndex:indexPath.row];
}


#pragma mark - Private Methods

- (void)updateDataWithCount:(NSInteger)count
                     Offset:(NSInteger)offset
                    AlbumId:(NSString *)albumId
                     UserId:(NSString *)userId{
    
    [[EEAppManager sharedAppManager] getPhotosWithCount:count offset:offset fromAlbum:albumId forUser:userId completionSuccess:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSMutableArray class]]){
            [_photosList addObjectsFromArray:responseObject];
            _loadedPhotosCount = [responseObject count];
            _offset+=60;
        }else{
            NSLog(@"error");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } completionFailure:^(NSError *error) {
        NSLog(@"error - %@",error);
    }];
}




@end
