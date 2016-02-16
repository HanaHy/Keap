//
//  WelcomeViewController.m
//  SkaderApp
//
//  Created by Hana Hyder on 8/27/15.
//  Copyright (c) 2015 Hana. All rights reserved.
//

#import "WelcomeViewController.h"
#import "TutorialMainViewController.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "KeapAPIBot.h"
#import "KeapUser.h"
#import "KeapMainViewController.h"

@interface WelcomeViewController ()
@property (nonatomic, strong) UIImageView *borderBackground;

@property (strong, nonatomic) KeapAPIBot *apiBot;

@property (strong, nonatomic) dispatch_queue_t schoolListQueue;

@end

@implementation WelcomeViewController

@synthesize pickerView, dataArray, helloText, headerImageView, extText, confirmButton, emailName, borderBackground, apiBot;

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  
  emailName.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, emailName.center.y );
}

- (void)viewDidLoad {
  [super viewDidLoad];
  emailName.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, emailName.center.y );
  dataArray = [[NSMutableArray alloc] init];
  
    
    // Please do all of this stuff in a .storyboard file :]
    pickerView = [self.view viewWithTag:117];
    //
    
  pickerView.delegate = self;
  emailName.delegate  = self;
//  [[PFUser currentUser] refresh];
//  NSString *fName, *lName, *string, *match;
//  match = @" ";
//  string = [PFUser currentUser][@"additional"];
//  NSScanner *scanner = [NSScanner scannerWithString:string];
//  [scanner scanUpToString:match intoString:&fName];
//  
//  [scanner scanString:match intoString:nil];
//  lName = [string substringFromIndex:scanner.scanLocation];
//
//  
// // NSLog(@"***The user's info is %@", [PFUser currentUser][@"additional"]);
//  [[PFUser currentUser] setObject:fName forKey:@"fName"];
//  [[PFUser currentUser] setObject:lName forKey:@"lName"];
//  [[PFUser currentUser] saveInBackground];
//  [[PFUser currentUser] refresh];
  
  helloText.text = [NSString stringWithFormat:@"%@, %@!", @"Hey", [KeapUser currentUser].fullname];
  
  
  CGFloat x = [UIImage imageNamed:@"clouds.png"].size.height*([[UIScreen mainScreen] bounds].size.width/[UIImage imageNamed:@"clouds.png"].size.width);
  //[self.borderBackground setFrame:CGRectMake(0.0f, [[UIScreen mainScreen] bounds].size.height-x, [[UIScreen mainScreen] bounds].size.width, x)];
  borderBackground  = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, [[UIScreen mainScreen] bounds].size.height-x, [[UIScreen mainScreen] bounds].size.width, x)];
  borderBackground.image = [UIImage imageNamed:@"clouds.png"];
  [self.view addSubview:borderBackground];
  [self.view sendSubviewToBack:self.borderBackground];
  
  //[self addSubview:self.borderBackground];
  //[self sendSubviewToBack:self.borderBackground];
  
  /*NSString *userProfilePhotoURLString = [PFUser currentUser][@"profile"][@"pictureURL"];
  // Download the user's facebook profile picture
  if (userProfilePhotoURLString) {
    NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                             if (connectionError == nil && data != nil) {
                               self.headerImageView.image = [UIImage imageWithData:data];
                               
                               // Add a nice corner radius to the image
                               self.headerImageView.layer.cornerRadius = 50.0f;
                               self.headerImageView.layer.masksToBounds = YES;
                             } else {
                               NSLog(@"Failed to load profile photo.");
                             }
                           }];
  }*/
    
    self.schoolListQueue = dispatch_queue_create("keap.school.list", DISPATCH_QUEUE_SERIAL);
    
    self.apiBot = [KeapAPIBot botWithDelegate:self];
  
//  PFQuery *query = [PFQuery queryWithClassName:@"schoolext"];
//  [query setLimit:10000];
//  NSArray *test = [query findObjects];
//  //NSMutableArray *temp = [[NSMutableArray alloc] init];
//  for(int i = 0; i < test.count; i++)
//  {
//    dataArray[i] = (PFObject *)(test[i])[@"School"];
//      NSLog(@"%s %@",__FUNCTION__,(PFObject *)(test[i]));
////      [self.apiBot addInSchool:(NSString *)((PFObject *)(test[i])[@"School"]) extension:(NSString *)((PFObject *)(test[i])[@"Extention"]) completion:^(KeapAPISuccessType result, NSDictionary *response) {
////          NSLog(@"%s response %@",__FUNCTION__, response);
////      }];
//  }
  originalCenter = self.view.center;
  // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    dispatch_async(self.schoolListQueue, ^{
        [self.apiBot fetchSchoolsWithCompletion:^(KeapAPISuccessType result, NSDictionary *response) {
            //
            NSLog(@"\n\n\ncompletion block for fetch schools\n\n\n");
            if (result == success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"\n\n\nReading school list over\n\n\n");
                    self.dataArray = [response objectForKey:@"schools"];
                    [self.pickerView reloadAllComponents];
                });
            }
        }];
    });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSLog(@"%s",__FUNCTION__);
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return self.dataArray.count;
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [[self.dataArray objectAtIndex:row] objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
  //Write the required logic here that should happen after you select a row in Picker View.
//  PFQuery *query = [PFQuery queryWithClassName:@"schoolext"];
//  [query whereKey:@"School" equalTo:[dataArray objectAtIndex:row]];
//  PFObject *result = [query getFirstObject];
//  extText.text = [NSString stringWithFormat:@"@%@",result[@"Extention"]];
//  [[PFUser currentUser] setObject:[dataArray objectAtIndex:row] forKey:@"school"];
//  [[PFUser currentUser] saveInBackground]; //-- In future may comment this line out ?
    extText.text = [[dataArray objectAtIndex:row] objectForKey:@"extension"];
}

- (IBAction)confirmButtonTouchHandler:(id)sender
{
//  NSString *temp = [NSString stringWithFormat:@"%@%@", emailName.text, extText.text];
//  [[PFUser currentUser] setObject:temp forKey:@"email"];
//  [[PFUser currentUser] saveInBackground];
    
    if (extText.text.length < 4) {
        [[[UIAlertView alloc] initWithTitle:@"Wait!" message:@"Please Select a School" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return;
    }
    
    NSLog(@"%s \n\n\n\n\n SCHOOL WELCOME: %@ \n\n\n\n\n",__FUNCTION__, extText.text);
    [self.apiBot updateUserSchool:extText.text completion:^(KeapAPISuccessType result, NSDictionary *response) {
        if (result == success) {
            NSLog(@"successfully signed up");
            [KeapUser setSchool:extText.text];
            [KeapUser setNeedsSchoolEmail:NO];
            if (self.navigationController) {
                [self.navigationController pushViewController:[[KeapMainViewController alloc] init] animated:YES];
            } else {
                [self presentViewController:[[KeapMainViewController alloc] init] animated:YES completion:nil];
            }
        }
    }];
    
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verify Your Email" message:@"Thanks! We just sent you an email. Please verify it so we can get started!" delegate:nil cancelButtonTitle:@"Got it!" otherButtonTitles:nil, nil];
  
  [alert show];
//  
//  if([KeapUser getCurrentUser].isNew)
//  {
//    [self.navigationController pushViewController:[[TutorialMainViewController alloc] init] animated:YES]; 
//  }
//  //[self dismissViewControllerAnimated:YES completion:NULL];
  
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  /* keyboard is visible, move views */
  
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3]; // if you want to slide up the view

  self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 210);
  
  
  [UIView commitAnimations];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3]; // if you want to slide up the view
  
  self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 210);
  
  [UIView commitAnimations];
  
  return YES;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
