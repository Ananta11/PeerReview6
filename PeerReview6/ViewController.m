//
//  ViewController.m
//  PeerReview6
//
//  Created by Ananta Shahane on 6/10/17.
//  Copyright © 2017 Ananta Shahane. All rights reserved.
//

#import "ViewController.h"
#import "NXOAuth2.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *LogoutButton;
@property (weak, nonatomic) IBOutlet UIButton *RefreshButton;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageView;

-(void) Setup;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self Setup];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedLoginButton:(id)sender {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Instagram"];
    self.LoginButton.enabled = NO;
    self.LogoutButton.enabled = YES;
    self.RefreshButton.enabled = YES;
    self.LoginButton.alpha = 0.25;
    self.LogoutButton.alpha = 1;
    self.RefreshButton.alpha = 1;

    
}

- (IBAction)clickedLogoutButton:(id)sender {
    NXOAuth2AccountStore *store = [NXOAuth2AccountStore sharedStore];
    NSArray *accounts = [store accountsWithAccountType:@"Instagram"];
    for (id acct in accounts)
    {
        [store removeAccount:acct];
    }
    self.LogoutButton.enabled = NO;
    self.LoginButton.enabled = YES;
    self.RefreshButton.enabled = NO;
    self.LoginButton.alpha = 1;
    self.LogoutButton.alpha = 0.25;
    self.RefreshButton.alpha = 0.25;
}

- (IBAction)clickedRefreshButton:(id)sender {
    NSArray *instagramAccounts = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"Instagram"];
    if([instagramAccounts count] == 0)
    {
        NSLog(@"Warning: %ld Instagram accounts logged in..", (long)[instagramAccounts count]);
        return;
    }
    NXOAuth2Account *acct = instagramAccounts[0];
    NSString *token = acct.accessToken.accessToken;
    NSString *urlStr = [@"https://api.instagram.com/v1/users/self/media/recent/?access_token=" stringByAppendingString:token];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error)
        {
            NSLog(@"Couldn't complete task error: %@", error);
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode < 200 || httpResponse.statusCode > 300)
        {
            NSLog(@"HTTP Error: %ld", (long)httpResponse);
            return;
        }
        NSError *parseErr;
        id pkg = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];
        if(!pkg)
        {
            NSLog(@"Coudn't parse response: %@", parseErr);
            return;
        }
        NSString *imageAddress = pkg[@"data"][0][@"images"][@"standard_resolution"][@"url"];
        NSLog(@"Imaage address: %@", imageAddress);
        NSURL *image = [NSURL URLWithString:imageAddress];
        [[session dataTaskWithURL:image completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(error)
            {
                NSLog(@"Couldn't complete task error: %@", error);
                return;
            }
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode < 200 || httpResponse.statusCode > 300)
            {
                NSLog(@"HTTP Error: %ld", (long)httpResponse);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.UIImageView.image = [UIImage imageWithData:data];
                self.view.layer.backgroundColor = [UIColor colorWithRed:0.21 green:0.34 blue:0.53 alpha:1].CGColor;
            });
        }] resume];
    }] resume];
    self.RefreshButton.alpha = 0.25;
}

-(void) Setup
{
    self.LoginButton.enabled = YES;
    self.LogoutButton.enabled = NO;
    self.RefreshButton.enabled = NO;
    self.LogoutButton.alpha = 0.25;
    self.RefreshButton.alpha = 0.25;
}

@end
