//
//  SubclassConfigViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "SubclassConfigViewController.h"
#import "MyLogInViewController.h"
#import "MySignUpViewController.h"
#import "WelcomeViewController.h"
#import "KeapMainViewController.h"
//#import "TutorialMainViewController.h"

@implementation SubclassConfigViewController


#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  [[self navigationController] setNavigationBarHidden:YES animated:animated];
    if ([PFUser currentUser]) {
      [[PFUser currentUser] refresh];
      if([PFUser currentUser][@"emailVerified"] == false || [PFUser currentUser].isNew) {
        
       /* //UNCOMMENT THIS &&
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verify Your Email" message:@"Sorry, to ensure your safety you must first verify your email." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [alert show];
        */
        
        
        self.welcomeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome unverified %@!", nil), [[PFUser currentUser] username]];
        
        [self.navigationController pushViewController:[[WelcomeViewController alloc] init] animated:YES];
         
      }
      else
      {
        self.welcomeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome, %@!", nil), [PFUser currentUser][@"fName"]];
        
        //[self.navigationController pushViewController:[[WelcomeViewController alloc] init] animated:YES];
        [self.navigationController pushViewController:[[KeapMainViewController alloc] init] animated:YES];
        //[self.navigationController pushViewController:[[TutorialMainViewController alloc] init] animated:YES];
        
      }
    } else {
        self.welcomeLabel.text = NSLocalizedString(@"Not logged in", nil);
    }
  int imageHeight = [UIScreen mainScreen].bounds.size.width*0.5*[UIImage imageNamed:@"frame_0.gif"].size.height/[UIImage imageNamed:@"frame_0.gif"].size.width;
  UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.25, ([UIScreen mainScreen].bounds.size.height - imageHeight)/2, [UIScreen mainScreen].bounds.size.width*0.5, imageHeight)];
  animatedImageView.animationImages = [NSArray arrayWithObjects:
                                       [UIImage imageNamed:@"frame_0.gif"],
                                       [UIImage imageNamed:@"frame_1.gif"],
                                       [UIImage imageNamed:@"frame_2.gif"],
                                       [UIImage imageNamed:@"frame_3.gif"],
                                       [UIImage imageNamed:@"frame_4.gif"],
                                       [UIImage imageNamed:@"frame_5.gif"],
                                       [UIImage imageNamed:@"frame_6.gif"],
                                       [UIImage imageNamed:@"frame_7.gif"],
                                       [UIImage imageNamed:@"frame_8.gif"],
                                       [UIImage imageNamed:@"frame_9.gif"],
                                       [UIImage imageNamed:@"frame_10.gif"],
                                       [UIImage imageNamed:@"frame_11.gif"],
                                       [UIImage imageNamed:@"frame_12.gif"],
                                       [UIImage imageNamed:@"frame_13.gif"],
                                       [UIImage imageNamed:@"frame_14.gif"],
                                       [UIImage imageNamed:@"frame_15.gif"],
                                       [UIImage imageNamed:@"frame_16.gif"],
                                       [UIImage imageNamed:@"frame_17.gif"],
                                       [UIImage imageNamed:@"frame_18.gif"],
                                       [UIImage imageNamed:@"frame_19.gif"],
                                       [UIImage imageNamed:@"frame_20.gif"],
                                       [UIImage imageNamed:@"frame_21.gif"],
                                       [UIImage imageNamed:@"frame_22.gif"],
                                       [UIImage imageNamed:@"frame_23.gif"],
                                       [UIImage imageNamed:@"frame_24.gif"],
                                       [UIImage imageNamed:@"frame_25.gif"],
                                       [UIImage imageNamed:@"frame_26.gif"],
                                       [UIImage imageNamed:@"frame_27.gif"],
                                       [UIImage imageNamed:@"frame_28.gif"],
                                       [UIImage imageNamed:@"frame_29.gif"],
                                       [UIImage imageNamed:@"frame_30.gif"],
                                       [UIImage imageNamed:@"frame_31.gif"],
                                       [UIImage imageNamed:@"frame_32.gif"],
                                       [UIImage imageNamed:@"frame_33.gif"],
                                       [UIImage imageNamed:@"frame_34.gif"],
                                       [UIImage imageNamed:@"frame_35.gif"],
                                       [UIImage imageNamed:@"frame_36.gif"],
                                       [UIImage imageNamed:@"frame_37.gif"],
                                       [UIImage imageNamed:@"frame_38.gif"],
                                       [UIImage imageNamed:@"frame_39.gif"],
                                       [UIImage imageNamed:@"frame_40.gif"],
                                       [UIImage imageNamed:@"frame_41.gif"],
                                       [UIImage imageNamed:@"frame_42.gif"],
                                       [UIImage imageNamed:@"frame_43.gif"],
                                       [UIImage imageNamed:@"frame_44.gif"],
                                       [UIImage imageNamed:@"frame_45.gif"],
                                       [UIImage imageNamed:@"frame_46.gif"],
                                       [UIImage imageNamed:@"frame_47.gif"],
                                       [UIImage imageNamed:@"frame_48.gif"],
                                       [UIImage imageNamed:@"frame_49.gif"],
                                       [UIImage imageNamed:@"frame_50.gif"],
                                       [UIImage imageNamed:@"frame_51.gif"],
                                       [UIImage imageNamed:@"frame_52.gif"],
                                       [UIImage imageNamed:@"frame_53.gif"],
                                       [UIImage imageNamed:@"frame_54.gif"],
                                       [UIImage imageNamed:@"frame_55.gif"],
                                       [UIImage imageNamed:@"frame_56.gif"],
                                       [UIImage imageNamed:@"frame_57.gif"],
                                       [UIImage imageNamed:@"frame_58.gif"], nil];
  animatedImageView.animationDuration = 1.0f;
  animatedImageView.animationRepeatCount = 10;
  [animatedImageView startAnimating];
  [self.view addSubview: animatedImageView];
  
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Check if user is logged in
    if (![PFUser currentUser]) {        
        // Customize the Log In View Controller
        MyLogInViewController *logInViewController = [[MyLogInViewController alloc] init];
        logInViewController.delegate = self;
        logInViewController.facebookPermissions = @[@"friends_about_me"];
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsDismissButton;
        
        // Customize the Sign Up View Controller
        MySignUpViewController *signUpViewController = [[MySignUpViewController alloc] init];
        signUpViewController.delegate = self;
        signUpViewController.fields = PFSignUpFieldsDefault | PFSignUpFieldsAdditional;
        logInViewController.signUpController = signUpViewController;
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
