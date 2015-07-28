//
//  EEUserDetailVC.m
//  VKPhotoViewer
//
//  Created by admin on 7/21/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEUserDetailVC.h"
#import "EEAppManager.h"
#import "UIImage+StackBlur.h"
#import "EEUserDetailCell.h"


@interface EEUserDetailVC ()

@end

@implementation EEUserDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Detail";
    [_spinner startAnimating];
    
   [_mainPhoto.layer setCornerRadius:_mainPhoto.frame.size.width/2];
    _mainPhoto.layer.masksToBounds = YES;
    _mainPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    _mainPhoto.layer.borderWidth = 2;
    
   
    
    [[EEAppManager sharedAppManager] getDetailForUserWithCompletionSuccess:^(BOOL successLoad, EEFriends *friendModel) {
        
       dispatch_async(dispatch_get_main_queue(), ^{
         
           if (friendModel.city&&friendModel.country){
            _city.text = [NSString stringWithFormat:@"from %@, %@",friendModel.city,friendModel.country];
           }
           else if (friendModel.city){
               _city.text = [NSString stringWithFormat:@"from %@",friendModel.city];
           }
           else if (friendModel.country){
               _city.text = [NSString stringWithFormat:@"from %@",friendModel.country];
           }
           else{
               _city.text = @"";
           }
           
           _albumsCountLabel.text = [friendModel getAlbumsCount];
           _photosCountLabel.text = [friendModel getPhotosCount];
           [_spinner stopAnimating];
           [_spinner setHidden:YES];
           [_loadingView setHidden:YES];

       });
        
    } completionFailure:^(NSError *error) {
        
    }];
    EEFriends *lUser = [EEAppManager sharedAppManager].currentFriend;
    _fullName.text = [lUser getFullName];
    [[EEAppManager sharedAppManager] getPhotoByLink:lUser.bigPhotoLink withCompletion:^(UIImage *image, BOOL animated) {
        [image normalize];
        _mainPhoto.image = image;
        _backgroundPhoto.image = [image stackBlur:6];
        
        
            }];
    
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 6;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"UserDetailCell";
   EEUserDetailCell *lCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(lCell==nil){
        
        NSArray *lNib = [[NSBundle mainBundle] loadNibNamed:@"UserDetailCell" owner:self options:nil];
        lCell = [lNib objectAtIndex:0];
        
    }
    
   
    
    return lCell;
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
