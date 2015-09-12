//
//  EEPhotoGalleryVC.m
//  VKPhotoViewer
//
//  Created by admin on 8/12/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEPhotoGalleryVC.h"
#import "Constants.h"
#import "EEAppManager.h"
#import "EEGalleryCell.h"
#import "UIImageView+Haneke.h"
#import "EETransitionFromPhotoGalleryVCToPhotosVC.h"
#import "EETransitionFromPhotosVCToPhotoGalleryVC.h"
#import "EEPhotosVC.h"

@interface EEPhotoGalleryVC ()

@end
NSInteger spacing = 0;
static NSString *CelID = @"GalleryCell";

@implementation EEPhotoGalleryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellImageSnapshot = [UIView new];
    _currentIndex = [EEAppManager sharedAppManager].currentPhotoIndex;
    _allPhotos = [EEAppManager sharedAppManager].allPhotos;
    _album = [EEAppManager sharedAppManager].currentAlbum;
    _image = [UIImage new];
    [self setupCollectionView];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld of %@",_currentIndex+1,[_album getAlbumSize]];
    
    if ([[_allPhotos objectAtIndex:_currentIndex] isLiked]) {
        _likeBtn.imageView.image = [UIImage imageNamed:@"LikeFilled"];
    } else {
        _likeBtn.imageView.image = [UIImage imageNamed:@"Like"];
    }
    _likesCountLbl.text = [[_allPhotos objectAtIndex:_currentIndex] getLikesCount];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSIndexPath *lIndexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
    [_collectionView scrollToItemAtIndexPath:lIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[EEAppManager sharedAppManager].allPhotos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%i %@",[EEAppManager sharedAppManager].allPhotos.count, [[EEAppManager sharedAppManager].currentAlbum getAlbumSize]);
    NSString* albumSizeToString = [NSString stringWithFormat:@"%lu",(unsigned long)[EEAppManager sharedAppManager].allPhotos.count];
    if (indexPath.row == [EEAppManager sharedAppManager].allPhotos.count - 1
        && ![albumSizeToString isEqualToString:[[EEAppManager sharedAppManager].currentAlbum getAlbumSize]]) {
        [_baseAlbumDelegate BaseAlbumDelegateUploadPhotos: ^{
            [_collectionView reloadData];
        }];
    }
    EEGalleryCell *lCell = (EEGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CelID forIndexPath:indexPath];
    lCell.imageView.image = nil;
    [lCell.spinner startAnimating];
    [lCell.spinner setHidesWhenStopped:YES];
    _newIndex = indexPath.row;
    UIImage* placeholderImg = [[UIImage alloc] init];
    //NSString* linkForSmallPhoto =
    //[lCell.imageView hnk_setImageFromURL:[NSURL URLWithString:((EEPhoto*)self.allPhotos[indexPath.row]).sPhotoLink]];
    [lCell.imageView hnk_setImageFromURL:[NSURL URLWithString:[self setPhotoAtIndex:indexPath.row]] placeholder:placeholderImg success:^(UIImage *image) {
        self.cellImageSnapshot.hidden = YES;
        [self.cellImageSnapshot removeFromSuperview];
        //self.cellImageSnapshot.hidden = YES;
        [lCell.spinner stopAnimating];
        lCell.imageView.image = image;
    } failure:^(NSError *error) {
        
    }];
    return lCell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != _newIndex) {
        if (_newIndex > _currentIndex) {
            _currentIndex++;
        } else {
            _currentIndex--;
        }
        EEPhoto *lPhoto = [_allPhotos objectAtIndex:_currentIndex];
        [EEAppManager sharedAppManager].currentPhoto = lPhoto;
        self.navigationItem.title = [NSString stringWithFormat:@"%ld of %@",_currentIndex + 1,[_album getAlbumSize]];
        if ([[_allPhotos objectAtIndex:_currentIndex] isLiked]) {
            _likeBtn.imageView.image = [UIImage imageNamed:@"LikeFilled"];
        } else {
            _likeBtn.imageView.image = [UIImage imageNamed:@"Like"];
        }
        
        _likesCountLbl.text = [lPhoto getLikesCount];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}

- (void)setupCollectionView {
    [self.collectionView registerClass:[EEGalleryCell class] forCellWithReuseIdentifier:CelID];
    UICollectionViewFlowLayout *lFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [lFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    lFlowLayout.minimumInteritemSpacing = 0;
    lFlowLayout.minimumLineSpacing = 0;
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:lFlowLayout];
}

- (NSString *)setPhotoAtIndex:(NSInteger)index {
    NSString *lLink;
    EEPhoto *lPhoto = [[EEPhoto alloc] init];
    lPhoto = [_allPhotos objectAtIndex:index];
    BOOL lNoPhoto = NO;
    
    if (lPhoto.xxlPhotoLink){
        lLink = lPhoto.xxlPhotoLink;
    }else if (lPhoto.xlPhotoLink){
        lLink = lPhoto.xlPhotoLink;
        
    }else if (lPhoto.lPhotoLink){
        lLink = lPhoto.lPhotoLink;
        
    }else if (lPhoto.mPhotoLink){
        lLink = lPhoto.mPhotoLink;
        
    }else if (lPhoto.sPhotoLink){
        lLink = lPhoto.sPhotoLink;
        
    }else if (lPhoto.xsPhotoLink){
        lLink = lPhoto.xsPhotoLink;
    }else{
        lNoPhoto = YES;
    }
    
    return lLink;
}

#pragma mark - button realization

- (IBAction)shareBtnTaped:(id)sender {
    
    NSArray *sharedItems = [[NSArray alloc] initWithObjects:_image, nil];
    UIActivityViewController *lActivityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
    
    lActivityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:lActivityViewController animated:YES completion:nil];
    
    
}
- (IBAction)likeBtnTaped:(id)sender {
    if ([[EEAppManager sharedAppManager].currentPhoto isLiked]) {
        [[EEAppManager sharedAppManager] deleteLikeForCurrentFriendPhotoWithCaptcha:nil
         CompletionSuccess:^(id responseObject) {
            NSInteger lLikesCount = [(NSNumber *)[[responseObject objectForKey:@"response"] objectForKey:@"likes"] integerValue];
            _likesCountLbl.text = [NSString stringWithFormat:@"%li",(long)lLikesCount];
            _likeBtn.imageView.image = [UIImage imageNamed:@"Like"];
            [EEAppManager sharedAppManager].currentPhoto.Liked = [NSNumber numberWithInt:0];
            [EEAppManager sharedAppManager].currentPhoto.likesCount = [NSNumber numberWithInteger:lLikesCount];
        } completionFailure:^(NSError *error) {
            
        }];
    } else {
 
        [[EEAppManager sharedAppManager] addLikeForCurrentFriendPhotoWithCaptha:nil CompletionSuccess:^(id responseObject) {
                    NSInteger lLikesCount = [(NSNumber *)[[responseObject objectForKey:@"response"] objectForKey:@"likes"] integerValue];
                    _likesCountLbl.text = [NSString stringWithFormat:@"%li",(long)lLikesCount];
                    _likeBtn.imageView.image = [UIImage imageNamed:@"LikeFilled"];
                    [EEAppManager sharedAppManager].currentPhoto.Liked = [NSNumber numberWithInt:1];
                    [EEAppManager sharedAppManager].currentPhoto.likesCount = [NSNumber numberWithInteger:lLikesCount];
        } completionFailure:^(NSError *error) {
            
        }];


  
    }
}
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a DSLFirstViewController
    if (fromVC == self && [toVC isKindOfClass:[EEPhotosVC class]]) {
        return [[EETransitionFromPhotoGalleryVCToPhotosVC alloc] init];
    }
    else {
        return nil;
    }
}
-(EEGalleryCell*) visableCell {
    return (EEGalleryCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
}

@end
