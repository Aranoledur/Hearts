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
#import <VKSdk/VKSdk.h>

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
                self.userRecord.name = [result valueForKey:@"name"];
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
    NSRange r1 = [urlString rangeOfString:@"50x50/"];
    if(!r1.length)
        r1 = [urlString rangeOfString:@"x200/"];
    NSRange r2 = [urlString rangeOfString:@".jpg"];
    NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length + 4);
    NSString *subFileName = [urlString substringWithRange:rSub];
    return subFileName;
}

- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader {
    
    // 1
    [self.profilePictureView setImage:self.userRecord.image];
}

- (IBAction)vkAuthorize:(UIButton *)sender {
    [VKSdk authorize:@[VK_PER_FRIENDS]];
}

@end
