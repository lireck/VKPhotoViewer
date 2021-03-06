//
//  EEAppManager.m
//  VKPhotoViewer
//
//  Created by admin on 7/20/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEAppManager.h"
#import "EERequests.h"
#import "EEResponseBilder.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperation.h"
#import "Constants.h"
#import "EENetworkManager.h"
#import "AppDelegate.h"

@interface EEAppManager ()

@end


@implementation EEAppManager

+ (EEAppManager *)sharedAppManager{
    
    static dispatch_once_t once;
    static id sharedAppManager;
    
    dispatch_once(&once, ^{
        sharedAppManager = [[self alloc] init];
    });
    return sharedAppManager;
}

- (void)getFriendsWithCount:(NSUInteger)count
                     offset:(NSUInteger)offset
          completionSuccess:(void (^)(id responseObject))success
          completionFailure:(void (^)(NSError * error))failure {
    if ([self isTokenExpired]) {
        [self.delegate tokenDidExpired];
    }
    else {
        EENetworkManager *lManager = [EENetworkManager sharedManager];
        [lManager GET:[EERequests friendsGetRequestWithOffset:offset count:count] parameters:nil success:^ (NSURLSessionDataTask *task, id responseObject) {
            DLog(@"DEBUG - %@",responseObject);
            NSArray *lArray = [responseObject objectForKey:@"response"];
            NSMutableArray *lFriendsList = [[NSMutableArray alloc] initWithArray:[EEResponseBilder getFriendsFromArray:lArray]];
            success(lFriendsList);
            
        } failure:^ (NSURLSessionDataTask *task, NSError *error) {
            failure(error);
        }];
    }
}

- (void)getDetailByUserId:(NSString *)userId
        completionSuccess:(void (^)(BOOL successLoad, EEFriends *friendModel))success
        completionFailure:(void (^)(NSError * error))failure {
    if ([self isTokenExpired]) {
        [self.delegate tokenDidExpired];
    }
    else {
        EENetworkManager *lManager = [EENetworkManager sharedManager];
        [lManager GET:[EERequests getUserInfoRequestWithId:userId] parameters:nil success:^ (NSURLSessionDataTask *task, id responseObject) {
            EEFriends *lUser = [EEFriends new];
            NSArray *lUserDetailResponse = [responseObject objectForKey:@"response"];
            lUser = [EEResponseBilder getDetailFromArray:lUserDetailResponse forUser:lUser];
            success(YES, lUser);
        } failure:^ (NSURLSessionDataTask *task, NSError *error) {
            failure(error);
        }];
    }
}

- (void)getPhotoByLink:(NSString *)photoLink
        withCompletion:(void (^)(UIImage *image, BOOL animated))setImage {
    if ([self isTokenExpired]) {
        [self.delegate tokenDidExpired];
    }
    else {
        _cache = [[EGOCache alloc] init];
        if([_cache imageForKey:photoLink] != nil) {
            setImage([_cache imageForKey:photoLink],NO);
            
        } else{
            
            NSMutableURLRequest *lRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:photoLink] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
            
            AFHTTPRequestOperation *lOperation = [[AFHTTPRequestOperation alloc] initWithRequest:lRequest];
            lOperation.responseSerializer = [AFImageResponseSerializer serializer];
            [lOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [_cache setImage:responseObject forKey:photoLink];
                setImage(responseObject,YES);
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
            [lOperation start];
        }
    }
}

-(void)getAlbumWithId:(NSString *)albId completionSuccess:(void (^)(id))success completionFailure:(void (^)(NSError *))failure {
    if ([self isTokenExpired]) {
        [self.delegate tokenDidExpired];
    }
    else {
        EENetworkManager *lManager = [EENetworkManager sharedManager];
        [lManager GET:[EERequests getAlbumWithId:albId forUser:_currentFriend.userId] parameters:nil success:^ (NSURLSessionDataTask *task, id responseObject) {
            NSArray *lArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
            NSMutableArray *lAlbums = [[NSMutableArray alloc] initWithArray:[EEResponseBilder getAlbumsFromArray:lArray]];
            success(lAlbums);
        } failure:^ (NSURLSessionDataTask *task, NSError *error) {
            failure(error);
        }];
    }
}

- (void)getAlbumsWithCount:(NSUInteger)count
                    offset:(NSUInteger)offset
                        Id:(NSString *)userId
         completionSuccess:(void (^)(id))success
         completionFailure:(void (^)(NSError *))failure {
    if ([self isTokenExpired]) {
        [self.delegate tokenDidExpired];
    }
    else {
        EENetworkManager *lManager = [EENetworkManager sharedManager];
        [lManager GET:[EERequests getAlbumsRequestWithOffset:offset count:count byId:userId] parameters:nil success:^ (NSURLSessionDataTask *task, id responseObject) {
            NSArray *lArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
            NSMutableArray *lAlbums = [[NSMutableArray alloc] initWithArray:[EEResponseBilder getAlbumsFromArray:lArray]];
            success(lAlbums);
        } failure:^ (NSURLSessionDataTask *task, NSError *error) {
            failure(error);
        }];
    }
}

- (void)getPhotosWithCount:(NSUInteger)count
                    offset:(NSUInteger)offset
                 fromAlbum:(NSString *)albumId
                   forUser:(NSString *)userId
         completionSuccess:(void (^)(id responseObject))success
         completionFailure:(void (^)(NSError * error))failure{
    if ([self isTokenExpired]) {
        [self.delegate tokenDidExpired];
    }
    else {
        EENetworkManager *lManager = [EENetworkManager sharedManager];
        [lManager GET:[EERequests getPhotosRequestWithOffset:offset count:count fromAlbum:albumId forUser:userId] parameters:nil success:^ (NSURLSessionDataTask *task, id responseObject) {
            NSArray *lArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
            NSMutableArray *lPhotos = [[NSMutableArray alloc] initWithArray:[EEResponseBilder getPhotosFromArray:lArray]];
            success(lPhotos);
        } failure:^ (NSURLSessionDataTask *task, NSError *error) {
            failure(error);
        }];
    }
}

- (void)addLikeForCurrentFriendPhotoWithCaptha:(NSDictionary *)captcha
                             CompletionSuccess:(void (^)(id responseObject))success
                             completionFailure:(void (^)(NSError * error))failure{
    
    if ([self isTokenExpired]) {
        [self.delegate tokenDidExpired];
    }
    else {
        EENetworkManager *lManager = [EENetworkManager sharedManager];
        [lManager GET:[EERequests addLikeWithOwnerId:_currentFriend.userId itemId:_currentPhoto.photoId] parameters:captcha success:^ (NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            BOOL Captcha = CAPTCHA_NEEDED(responseObject);
            if (Captcha) {
                [EEAppManager sharedAppManager].captchaSid = [[responseObject objectForKey:@"error"] objectForKey:@"captcha_sid"];
                [EEAppManager sharedAppManager].captchaImageLink = [[responseObject objectForKey:@"error"] objectForKey:@"captcha_img"];
                PRESENT_VIEW_CONTROLLER(@"CaptchaVC");
            }
            success(responseObject);
        } failure:^ (NSURLSessionDataTask *task, NSError *error ) {
            failure(error);
        }];
    }
}

- (void)deleteLikeForCurrentFriendPhotoWithCaptcha:(NSDictionary *)captcha
                                 CompletionSuccess:(void (^)(id responseObject))success
                                 completionFailure:(void (^)(NSError * error))failure{
    
    if ([self isTokenExpired]) {
        [self.delegate tokenDidExpired];
    }
    else {
        EENetworkManager *lManager = [EENetworkManager sharedManager];
        [lManager GET:[EERequests deleteLikeWithOwnerId:_currentFriend.userId itemId:_currentPhoto.photoId] parameters:captcha success:^ (NSURLSessionDataTask *task, id responseObject) {
            BOOL Captcha = CAPTCHA_NEEDED(responseObject);
            if (Captcha) {
                [EEAppManager sharedAppManager].captchaSid = [[responseObject objectForKey:@"error"] objectForKey:@"captcha_sid"];
                [EEAppManager sharedAppManager].captchaImageLink = [[responseObject objectForKey:@"error"] objectForKey:@"captcha_img"];
                PRESENT_VIEW_CONTROLLER(@"CaptchaVC");
            }
            
            NSLog(@"%@",responseObject);
            success(responseObject);
        } failure:^ (NSURLSessionDataTask *task, NSError *error ) {
            failure(error);
        }];
    }
}

#pragma mark - Alert view methods
- (void)showAlertAboutTokenExpired {
    UIAlertView* message;
    message = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat: @"Please Log-Out again"] delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [message show];
}

- (void)showAlertWithError : (NSError*)error {
    UIAlertView* message;
    message = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat: @"There is a problem with internet connection"] delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [message show];
}
#pragma mark - Private methods
- (bool)isTokenExpired {
    if([[[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY] isEqual: nil]) {
        return YES;
    }
    return ([[[NSUserDefaults standardUserDefaults] objectForKey:CREATED]timeIntervalSince1970] + [[[NSUserDefaults standardUserDefaults]objectForKey:TOKEN_LIFE_TIME_KEY] doubleValue] - TEMPORAL_ERROR) < [[NSDate new]  timeIntervalSince1970];
}

#pragma mark - Uploading photos for Gallery

-(void)UploadPhotos:(NSMutableArray *)allPhotos withCompletion:(void (^)())updateData {
    [self getPhotosWithCount:60.0 offset:allPhotos.count fromAlbum:_currentAlbum.albumID forUser:_currentFriend.userId completionSuccess:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSMutableArray class]]){
            [allPhotos addObjectsFromArray:responseObject];
        }else{
            NSLog(@"error");
        }
        if (updateData) {
            updateData();
        }
    } completionFailure:^(NSError *error) {
        NSLog(@"error - %@",error);
    }];
}

- (void)recieveLnkForPhotoCompletionSuccess:(void (^)(id responseObject))success
                          completionFailure:(void (^)(NSError * error))failure  {
    EENetworkManager *lManager = [EENetworkManager sharedManager];
    [lManager GET:[EERequests urlServiceForPhotoOn] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure( error);
    }];
}
- (void)postPhotoWithData:(NSData*)data onUrl:(NSString*)url CompletionSuccess:(void (^)(id responseObject))success
        completionFailure:(void (^)(NSError * error))failure {
    
    EENetworkManager *lManager = [EENetworkManager sharedManager];
    NSDictionary* parameters = @{ @"photo" : data};
    [lManager POST:url parameters: parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFormData:data name:@"photo"];
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        success (responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure (error);
    }];
}
- (void)savePhoto: (NSString*)photo InServiceWithUserId: (NSString*)userId AndHash: (NSString*)hash AndServer: (NSString*)server CompletionSuccess:(void (^)(id responseObject))success CompletitionFailure:(void (^)(NSError *error))failure {
    EENetworkManager *lManager = [EENetworkManager sharedManager];
    [lManager GET:[EERequests savePhoto:photo InServiceWithUserId:userId AndHash:hash AndServer:server] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

-(void)postPhoto:(NSString *)photoId OnWall:(NSString *)idOfUser CompletionSuccess:(void (^)(id))success CompletionFailure:(void (^)(NSError *))failure {
    EENetworkManager *lManager = [EENetworkManager sharedManager];
    [lManager GET:[EERequests postPhoto:photoId OnWall:idOfUser] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)getNewsfeedStartFrom:(NSString *)startFrom
           CompletionSuccess:(void (^)(id responseObject))success
           completionFailure:(void (^)(NSError * error))failure{
    EENetworkManager *lManager = [EENetworkManager sharedManager];
    [lManager GET:[EERequests newsfeedWithStartFrom:startFrom] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *lItems = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
        NSArray *lProfiles = [[responseObject objectForKey:@"response"] objectForKey:@"profiles"];
        
        NSMutableArray *lNews = [[NSMutableArray alloc] initWithArray:[EEResponseBilder getNewsfeedWithItems:lItems profiles:lProfiles]];
        success(lNews);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)EESettingsVCDelegateLogOutButtonTapped {
    [self.delegate tokenDidExpired];
}
@end
