//
//  EEResponseBilder.m
//  VKPhotoViewer
//
//  Created by admin on 7/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEResponseBilder.h"


@implementation EEResponseBilder


+ (NSMutableArray *)getFriendsFromArray:(NSArray *)array{
    
    NSMutableArray *lArrayFriends = [NSMutableArray new];
      
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
            EEFriends *lUser = [[EEFriends alloc] init];
            lUser.firstName = [NSString stringWithFormat:@"%@",[obj objectForKey:@"first_name"]];
            lUser.lastName = [NSString stringWithFormat:@"%@",[obj objectForKey:@"last_name"]];
            lUser.userId = [NSString stringWithFormat:@"%@",[obj objectForKey:@"user_id"]];
        lUser.smallPhotoLink = [NSString stringWithFormat:@"%@",[obj objectForKey:@"photo_100"]];
        lUser.bigPhotoLink = [NSString stringWithFormat:@"%@",[obj objectForKey:@"photo_200_orig"]];
        
            [lArrayFriends addObject:lUser];
            
        }];
    
    return lArrayFriends;
}

    
     
@end

