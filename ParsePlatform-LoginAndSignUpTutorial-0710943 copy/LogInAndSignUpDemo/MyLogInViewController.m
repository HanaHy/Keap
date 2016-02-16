//
//  MyLogInViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "MyLogInViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KeapAPIBot.h"
#import "KeapUser.h"
#import "WelcomeViewController.h"

@interface MyLogInViewController () <PFLogInViewControllerDelegate>
@property (nonatomic, strong) UIImageView *fieldsBackground, *borderBackground;
@property (nonatomic, strong) UILabel     *promoteText, *welcome, *spinT;

@property (strong, nonatomic) KeapAPIBot *apiBot;

@end

@implementation MyLogInViewController

@synthesize fieldsBackground, borderBackground, promoteText, welcome, spinT, apiBot;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBG.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]]];
    
    // Set buttons appearance
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"Exit.png"] forState:UIControlStateNormal];
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"ExitDown.png"] forState:UIControlStateHighlighted];
    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"sign_up.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"sign_up_down.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Add login field background
    fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginFieldBG.png"]];
    [self.logInView addSubview:self.fieldsBackground];
    [self.logInView sendSubviewToBack:self.fieldsBackground];
  
    borderBackground  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cute2.png"]];
  [self.logInView addSubview:self.borderBackground];
  [self.logInView sendSubviewToBack:self.borderBackground];
  promoteText = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 330.f, 250.f, 30.0f)];
  
  [self.logInView addSubview:promoteText];
  
  promoteText.text = @"Don't have an account, yet?";
  promoteText.textColor = [UIColor whiteColor];
  promoteText.font = [promoteText.font fontWithSize:12];
  
  spinT = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 65.0f, 250.f, 30.0f)];
  
  [self.logInView addSubview:spinT];
  
  spinT.text = @"Making college more affordable.";
  spinT.textColor = [UIColor whiteColor];
  spinT.font = [promoteText.font fontWithSize:12];
  
  
  welcome = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 40.0f, 250.f, 30.0f)];
  
  [self.logInView addSubview:welcome];
  
  welcome.text = @"Welcome to Keap";
  welcome.textColor = [UIColor whiteColor];
  welcome.font = [welcome.font fontWithSize:20];
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0]];
  
  self.logInView.externalLogInLabel.alpha = 0;
  self.logInView.signUpLabel.alpha = 0;
    
    self.apiBot = [KeapAPIBot botWithDelegate:self];
   
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s",__FUNCTION__);
    if ([KeapUser isLoggedIn]) {
        if ([[KeapUser currentUser] needsSchoolEmail]) {
            [self showWelcomeSequence];
        } else {
            [self proceedToApp];
        }
    } else {
        
    }
}

- (void)proceedToApp {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showWelcomeSequence {
    WelcomeViewController *welcome = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
    if (self.navigationController) {
        [self.navigationController pushViewController:welcome animated:YES];
    } else {
        [self presentViewController:welcome animated:YES completion:nil];
    }
}

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    [self.apiBot loginUserWithEmail:username password:password username:username completion:^(KeapAPISuccessType result, NSDictionary *response) {
        if (result == success) {
            NSLog(@"%s successfully logged in user",__FUNCTION__);
        }
        NSLog(@"%s response: %@",__FUNCTION__, response);
    }];
    return NO;
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self.apiBot loginUserWithEmail:user.email password:user.password username:user.username completion:^(KeapAPISuccessType result, NSDictionary *response) {
        if (result == success) {
            NSLog(@"%s successfully logged in user",__FUNCTION__);
        }
        NSLog(@"%s response: %@",__FUNCTION__, response);
    }];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 0.0f, 0.0f)];
    [self.logInView.logo setFrame:CGRectMake(66.5f, 100.0f, 187.0f, 60.5f)];
    [self.logInView.facebookButton setFrame:CGRectMake(-10.0f, 287.0f, 0.0f, 0.0f)];
    [self.logInView.twitterButton setFrame:CGRectMake(-10.0f+130.0f, 287.0f, 0.0f, 0.0f)];
    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 360.0f, 250.0f, 40.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 180.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 230.0f, 250.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(10.0f, 180.0f, [[UIScreen mainScreen] bounds].size.width - 20.0f, 100.0f)];
  CGFloat x = [UIImage imageNamed:@"Cute2.png"].size.height*([[UIScreen mainScreen] bounds].size.width/[UIImage imageNamed:@"Cute2.png"].size.width);
  [self.borderBackground setFrame:CGRectMake(0.0f, [[UIScreen mainScreen] bounds].size.height-x, [[UIScreen mainScreen] bounds].size.width, x)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
