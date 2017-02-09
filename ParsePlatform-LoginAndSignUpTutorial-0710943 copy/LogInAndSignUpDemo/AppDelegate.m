//
//  AppDelegate.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/14/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoTableViewController.h"
//#import <SendBirdSDK/SendBirdSDK.h> // Objective-C
#import "SubclassConfigViewController.h"
#import <LayerKit/LayerKit.h>
@interface AppDelegate () <LYRClientDelegate>
@property (nonatomic) LYRClient *layerClient;
@end

@implementation AppDelegate



#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSURL *appID = [NSURL URLWithString:@"layer:///apps/staging/4584a946-ee29-11e6-b4d1-aa3e02003870"];
    LYRClient *layerClient = [LYRClient clientWithAppID:appID delegate:self options:nil];
    [layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Successfully connected to Layer!");
        } else {
            NSLog(@"Failed connection to Layer with error: %@", error);
        }
    }];


    // ****************************************************************************
    // Fill in with your Parse and Twitter credentials. Don't forget to add your
    // Facebook id in Info.plist:
    // ****************************************************************************
  [Parse setApplicationId:@"sewGUE4NHuoD5Y4EJCAQgUR3TBXZl6tOkcpskGYi"
                clientKey:@"i08hbCNUoBQ4FggL95hHYXuaYM3RomMnnIyOAqhQ"];
    //[PFFacebookUtils initializeFacebook];
    //[PFTwitterUtils initializeWithConsumerKey:@"your_twitter_consumer_key" consumerSecret:@"your_twitter_consumer_secret"];
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    //[SBDMain initWithApplicationId:@"1FA70764-DF0C-4681-B12F-28CC5DE79D09"];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[SubclassConfigViewController alloc] init]];//[[UINavigationController alloc] initWithRootViewController:[[DemoTableViewController alloc] init]];
  
  //[self.navigationController pushViewController:[[SubclassConfigViewController alloc] init] animated:YES];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce
{
    NSLog(@"Layer Client did receive an authentication challenge with nonce=%@", nonce);
    
    /*
     * 1. Connect to your backend to generate an identity token using the provided nonce.
     */
    //NSString *identityToken =
    
    /*
     * 2. Submit identity token to Layer for validation
     */
  //  [layerClient authenticateWithIdentityToken:identityToken completion:^(LYRIdentity *authenticatedUser, NSError *error) {
    //    if (authenticatedUser) {
      //      NSLog(@"Authenticated as User: %@", authenticatedUser);
        //}
    //}];
}

/*// Facebook oauth callback
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Handle an interruption during the authorization flow, such as the user clicking the home button.
   // [FBSession.activeSession handleDidBecomeActive];
}*/

@end
