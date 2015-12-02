//
//  ViewController.m
//  LoginSampleFB
//
//  Created by user on 14.09.15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PhotoRecord.h"
#import "ListViewController.h"
#import "VKAuthorizeController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];

    self.fbloginButtonFake.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.fbloginButtonFake.delegate = self;
    
    self.userRecord = [[PhotoRecord alloc] init];
    
    [self getFriendsAndPushTable];
    self.view.backgroundColor = self.choosedColor;
    
    [[VKSdk instance] registerDelegate:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButton:	(FBSDKLoginButton *)loginButton
didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
error:	(NSError *)error
{
    NSLog(@"complete login %@", result);
    [self getFriendsAndPushTable];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"complete logout");
    self.fbUserNameLabel.text = @"";
    self.profilePictureView.image = nil;
    self.listView = nil;
}

-(void)getFriendsAndPushTable{
    if([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,picture.width(200).height(200),invitable_friends"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSString *nameOfLoginUser = [result valueForKey:@"name"];
                NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                self.fbUserNameLabel.text = nameOfLoginUser;
                NSURL *url = [[NSURL alloc] initWithString:imageStringOfLoginUser];
                self.userRecord.URL = url;
                self.userRecord.name = nameOfLoginUser;
                self.userRecord.fileName = [self getFileNameFromUrl:imageStringOfLoginUser];
                ImageDownloader *imageDownloader = [[ImageDownloader alloc] initWithPhotoRecord:self.userRecord atIndexPath:nil delegate:self];
                NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                [queue addOperation:imageDownloader];
                
                
                NSArray* invFriends = [[result objectForKey:@"invitable_friends"] objectForKey:@"data"];
                NSMutableArray *records = [NSMutableArray array];
                self.listView = [[ListViewController alloc] init];
                for (NSDictionary *a in invFriends) {
                    PhotoRecord *record = [[PhotoRecord alloc] init];
                    NSString *imageStringOfLoginUser = [[[a valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                    record.URL = [NSURL URLWithString:imageStringOfLoginUser];
                    record.name = [a valueForKey:@"name"];
                    
                    
                    record.fileName = [self getFileNameFromUrl:imageStringOfLoginUser];
                    
                    [records addObject:record];
                    record = nil;
                }
                self.listView.photos = records;
                [self.navigationController pushViewController:self.listView animated:YES];
            }
            else{
                NSLog(@"%@", error);
            }
        }];
    }
}

- (IBAction)buttonPushAction:(id)sender {
    if(self.listView)
        [self.navigationController pushViewController:self.listView animated:YES];
}

-(NSString *)getFileNameFromUrl:(NSString *)urlString{
    NSArray *parts = [urlString componentsSeparatedByString:@"/"];
    NSString *filename = [parts lastObject];
    return filename;
}

- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader {
    
    // 1
    [self.profilePictureView setImage:self.userRecord.image];
}

- (IBAction)vkAuthorize:(UIButton *)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"vk://"]]) {
        [VKSdk authorize:@[VK_PER_FRIENDS]];
    }
    else {
        VKAuthorizeController *controller = [[VKAuthorizeController alloc] initWith:@"5165397" andPermissions:@[VK_PER_FRIENDS] revokeAccess:NO displayType:VK_DISPLAY_IOS];
//        [self.navigationController pushViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark VKSdkDelegate methods
-(void) vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result{
    NSLog(@"VK authorization success");
    if([VKSdk accessToken]){
        VKRequest *userReq = [[VKApi users] get:@{VK_API_FIELDS : @"photo_200_orig"}];
        [userReq executeWithResultBlock:^(VKResponse *response){
            VKUsersArray *userInfo = response.parsedModel;
            VKUser *user = [userInfo.items lastObject];
            NSString *nameOfLoginUser = [user.first_name stringByAppendingString:user.last_name];
            NSString *imageStringOfLoginUser = user.photo_200_orig;
            self.fbUserNameLabel.text = nameOfLoginUser;
            NSURL *url = [[NSURL alloc] initWithString:imageStringOfLoginUser];
            self.userRecord.URL = url;
            self.userRecord.name = nameOfLoginUser;
            self.userRecord.fileName = [self getFileNameFromUrl:imageStringOfLoginUser];
            
            ImageDownloader *imageDownloader = [[ImageDownloader alloc] initWithPhotoRecord:self.userRecord atIndexPath:nil delegate:self];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [queue addOperation:imageDownloader];
        }
                             errorBlock:^(NSError *error){
                                 if (error.code != VK_API_ERROR) {
                                     [error.vkError.request repeat];
                                 }
                                 else {
                                     NSLog(@"VK error: %@", error);
                                 }
                             }];
        
        VKRequest *friendsReq = [[VKApi friends] get:@{VK_API_FIELDS : @"photo_200_orig"}];
        [friendsReq executeWithResultBlock:^(VKResponse * response) {
            VKUsersArray *friendsArr = response.parsedModel;
            NSMutableArray *records = [NSMutableArray array];
            self.listView = [[ListViewController alloc] init];
            for (VKUser* user in friendsArr.items) {
                PhotoRecord *record = [[PhotoRecord alloc] init];
                NSString *imageStringOfLoginUser = user.photo_200_orig;
                record.URL = [NSURL URLWithString:imageStringOfLoginUser];
                record.name = [user.first_name stringByAppendingString:user.last_name];
                
                
                record.fileName = [self getFileNameFromUrl:imageStringOfLoginUser];
                
                [records addObject:record];
                record = nil;
            }
            self.listView.photos = records;
            [self.navigationController pushViewController:self.listView animated:YES];
            
            
        } errorBlock:^(NSError * error) {
            if (error.code != VK_API_ERROR) {
                [error.vkError.request repeat];
            }
            else {
                NSLog(@"VK error: %@", error);
            } 
        }];
    }
}

-(void) vkSdkUserAuthorizationFailed{
    NSLog(@"VK authorization fail");
}

- (void)vkSdkAccessTokenUpdated:(VKAccessToken *)newToken oldToken:(VKAccessToken *)oldToken{
    
}

#pragma mark VKSdkUIDelegagte methods
-(void) vkSdkNeedCaptchaEnter:(VKError *)captchaError{
    VKCaptchaViewController * vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self];
}

-(void)vkSdkShouldPresentViewController:(UIViewController *)controller{
    [self presentViewController:controller animated:YES completion:nil];
    
}
@end
