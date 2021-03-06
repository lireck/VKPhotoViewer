//
//  EEAppManager.h
//  VKPhotoViewer
//
//  Created by admin on 7/20/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EEFriends.h"
#import "EEAlbum.h"
#import "EGOCache.h"
#import "EEPhoto.h"
#import "EESettingsVC.h"

@protocol EEAppManagerDelegate <NSObject>
@optional

-(void)tokenDidExpired;

@end


@interface EEAppManager : NSObject <EESettingsVCDelegate>

@property (nonatomic,retain)EEFriends *currentFriend;
@property (nonatomic,retain)EEFriends *loggedUser;
@property (nonatomic,retain)EEAlbum *currentAlbum;
@property (nonatomic,retain)EEPhoto *currentPhoto;
@property (nonatomic,copy)NSString *captchaSid;
@property (nonatomic,copy)NSString *captchaImageLink;
@property (nonatomic)NSInteger currentPhotoIndex;
@property (nonatomic,retain)EGOCache *cache;
@property (nonatomic, weak)id <EEAppManagerDelegate> delegate;

+ (EEAppManager *)sharedAppManager;
 
- (void)getFriendsWithCount:(NSUInteger)count
                     offset:(NSUInteger)offset
          completionSuccess:(void (^)(id responseObject))success
          completionFailure:(void (^)(NSError * error))failure;

- (void)getDetailByUserId:(NSString *)userId
        completionSuccess:(void (^)(BOOL successLoad, EEFriends *friendModel))success
        completionFailure:(void (^)(NSError * error))failure;

- (void)getPhotoByLink:(NSString *)photoLink withCompletion:(void (^)(UIImage *image,BOOL animated))setImage;

- (void)getAlbumWithId:(NSString*)albId
     completionSuccess:(void (^)(id responseObject))success
     completionFailure:(void (^)(NSError * error))failure;

- (void)getAlbumsWithCount:(NSUInteger)count
                     offset:(NSUInteger)offset
                         Id:(NSString *)userId
          completionSuccess:(void (^)(id responseObject))success
          completionFailure:(void (^)(NSError * error))failure;

- (void)getPhotosWithCount:(NSUInteger)count
                    offset:(NSUInteger)offset
                 fromAlbum:(NSString *)albumId
                   forUser:(NSString *)userId
         completionSuccess:(void (^)(id responseObject))success
         completionFailure:(void (^)(NSError * error))failure;

- (void)addLikeForCurrentFriendPhotoWithCaptha:(NSDictionary *)captcha
                             CompletionSuccess:(void (^)(id responseObject))success
                             completionFailure:(void (^)(NSError * error))failure;


- (void)deleteLikeForCurrentFriendPhotoWithCaptcha:(NSDictionary *)captcha
                                 CompletionSuccess:(void (^)(id responseObject))success
                                 completionFailure:(void (^)(NSError * error))failure;

- (void)showAlertWithError : (NSError*)error;
- (void)showAlertAboutTokenExpired;
-(void)UploadPhotos:(NSMutableArray *)allPhotos withCompletion:(void (^)())updateData;
- (void)recieveLnkForPhotoCompletionSuccess:(void (^)(id responseObject))success
                          completionFailure:(void (^)(NSError * error))failure;

- (void)postPhotoWithData:(NSData*)data
                    onUrl:(NSString*)url
        CompletionSuccess:(void (^)(id responseObject))success
        completionFailure:(void (^)(NSError * error))failure;

- (void)savePhoto:(NSString*)photo
    InServiceWithUserId:(NSString*)userId
                AndHash:(NSString*)hash
                AndServer:(NSString*)server
        CompletionSuccess:(void (^)(id responseObject))success
    CompletitionFailure:(void (^)(NSError *error))failure;

-(void)postPhoto:(NSString*)photoId
          OnWall:(NSString*)idOfUser
CompletionSuccess:(void(^)(id responseObject))success
CompletionFailure:(void (^)(NSError* error)) failure;

- (void)getNewsfeedStartFrom:(NSString *)startFrom
           CompletionSuccess:(void (^)(id responseObject))success
           completionFailure:(void (^)(NSError * error))failure;

@end
