//
//  ViewController.h
//  LoginSampleFB
//
//  Created by user on 14.09.15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ImageDownloader.h"

@class ListViewController;

@interface LoginViewController : UIViewController<FBSDKLoginButtonDelegate, ImageDownloaderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fbUserNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbloginButtonFake;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) ListViewController* listView;
@property (nonatomic, strong) PhotoRecord *userRecord;
@property (nonatomic, strong) UIColor *choosedColor;

-(void)getFriendsAndPushTable;
- (IBAction)buttonPushAction:(id)sender;
-(NSString *)getFileNameFromUrl:(NSString *)urlString;
@end

