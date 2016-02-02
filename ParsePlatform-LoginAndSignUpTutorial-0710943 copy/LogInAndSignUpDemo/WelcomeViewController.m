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

@interface WelcomeViewController ()
@property (nonatomic, strong) UIImageView *borderBackground;
@end

@implementation WelcomeViewController

@synthesize pickerView, dataArray, helloText, headerImageView, extText, confirmButton, emailName, borderBackground;

//@synthesize dataArray;

- (void) dealloc {
  //[pickerView release];
  //[dataArray release];
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  
  emailName.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, emailName.center.y );
}

- (void)viewDidLoad {
  [super viewDidLoad];
  emailName.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, emailName.center.y );
  dataArray = [[NSMutableArray alloc] init];
  
  pickerView.delegate = self;
  emailName.delegate  = self;
  [[PFUser currentUser] refresh];
  NSString *fName, *lName, *string, *match;
  match = @" ";
  string = [PFUser currentUser][@"additional"];
  NSScanner *scanner = [NSScanner scannerWithString:string];
  [scanner scanUpToString:match intoString:&fName];
  
  [scanner scanString:match intoString:nil];
  lName = [string substringFromIndex:scanner.scanLocation];

  
 // NSLog(@"***The user's info is %@", [PFUser currentUser][@"additional"]);
  [[PFUser currentUser] setObject:fName forKey:@"fName"];
  [[PFUser currentUser] setObject:lName forKey:@"lName"];
  [[PFUser currentUser] saveInBackground];
  [[PFUser currentUser] refresh];
  
  helloText.text = [NSString stringWithFormat:@"%@, %@!", @"Hey", [PFUser currentUser][@"fName"]];
  
  
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
  
  PFQuery *query = [PFQuery queryWithClassName:@"schoolext"];
  [query setLimit:920];
  NSArray *test = [query findObjects];
  //NSMutableArray *temp = [[NSMutableArray alloc] init];
  for(int i = 0; i < 920; i++)
  {
    dataArray[i] = (PFObject *)(test[i])[@"School"];
  }
  originalCenter = self.view.center;
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return 920;
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [dataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
  //Write the required logic here that should happen after you select a row in Picker View.
  PFQuery *query = [PFQuery queryWithClassName:@"schoolext"];
  [query whereKey:@"School" equalTo:[dataArray objectAtIndex:row]];
  PFObject *result = [query getFirstObject];
  extText.text = [NSString stringWithFormat:@"@%@",result[@"Extention"]];
  [[PFUser currentUser] setObject:[dataArray objectAtIndex:row] forKey:@"school"];
  [[PFUser currentUser] saveInBackground]; //-- In future may comment this line out ?
  
}

- (IBAction)confirmButtonTouchHandler:(id)sender
{
  NSString *temp = [NSString stringWithFormat:@"%@%@", emailName.text, extText.text];
  [[PFUser currentUser] setObject:temp forKey:@"email"];
  [[PFUser currentUser] saveInBackground];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verify Your Email" message:@"Thanks! We just sent you an email. Please verify it so we can get started!" delegate:nil cancelButtonTitle:@"Got it!" otherButtonTitles:nil, nil];
  
  [alert show];
  
  if([PFUser currentUser].isNew)
  {
    [self.navigationController pushViewController:[[TutorialMainViewController alloc] init] animated:YES]; 
  }
  //[self dismissViewControllerAnimated:YES completion:NULL];
  
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
