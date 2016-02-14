//
//  MySignUpViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "MySignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KeapAPIBot.h"

@interface MySignUpViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;

@property (strong, nonatomic) KeapAPIBot *apiBot;

@end

@implementation MySignUpViewController

@synthesize fieldsBackground, apiBot;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBG.png"]]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp1.png"]]];
    
    // Change button apperance
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"Exit.png"] forState:UIControlStateNormal];
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"ExitDown.png"] forState:UIControlStateHighlighted];
    
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUp.png"] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpDown.png"] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
  
    // Add background for fields
    [self setFieldsBackground:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignUpFieldBG.png"]]];
    [self.signUpView insertSubview:fieldsBackground atIndex:1];
    
    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.additionalField.layer;
    layer.shadowOpacity = 0.0f;
  //self.signUpView.emailField.alpha = 0;
  //self.signUpView.additionalField.alpha = 0;
    // Set text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.additionalField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    // Change "Additional" to match our use
    [self.signUpView.additionalField setPlaceholder:@"Full Name"];
    
    self.delegate = self;
    
    self.apiBot = [KeapAPIBot botWithDelegate:self];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Move all fields down on smaller screen sizes
  float yOffset = -10.0f;//[UIScreen mainScreen].bounds.size.height <= 480.0f ? 30.0f : 0.0f;

    CGRect fieldFrame = self.signUpView.usernameField.frame;

    [self.signUpView.dismissButton setFrame:CGRectMake(-20.0f, 10.0f, 87.5f, 45.5f)];
    [self.signUpView.logo setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 100.0f)/2, 35.0f, 100.0f, 100.0f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    [self.fieldsBackground setFrame:CGRectMake(10.0f, fieldFrame.origin.y + yOffset, [[UIScreen mainScreen] bounds].size.width - 20.0f, 174.0f)];
    //[self.fieldsBackground setFrame:CGRectMake(10.0f, 180.0f, [[UIScreen mainScreen] bounds].size.width - 20.0f, 100.0f)];
    [self.signUpView.usernameField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width - 10.0f,
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.passwordField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width - 10.0f,
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.emailField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                    fieldFrame.origin.y + yOffset,
                                                    fieldFrame.size.width - 10.0f,
                                                    fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.additionalField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                         fieldFrame.origin.y + yOffset,
                                                         fieldFrame.size.width - 10.0f,
                                                         fieldFrame.size.height)];
}


- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    NSLog(@"should sign up user %@",info);
//    [self.apiBot signupUserWithEmail:[info objectForKey:@"email"] password:[info objectForKey:@"password"] username:[info objectForKey:@"username"] fullname:[info objectForKey:@"fullname"] completion:^(KeapAPISuccessType result, NSDictionary *response) {
//        if (result == success) {
//            NSLog(@"%s signed up user",__FUNCTION__);
//        }
//        NSLog(@"%s response: %@",__FUNCTION__, response);
//    }];
    return YES;
}


- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"signed up user %@",user);
    [self.apiBot signupUserWithEmail:user.email password:user.password username:user.username fullname:@"John Wick" completion:^(KeapAPISuccessType result, NSDictionary *response) {
        if (result == success) {
            NSLog(@"%s signed up user",__FUNCTION__);
            [KeapAPIBot storeUserInformation:user];
        }
        NSLog(@"%s response: %@",__FUNCTION__, response);
    }];
}


- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"failed to sign up the user %@",error);
}


- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"user cancelled sign up");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
