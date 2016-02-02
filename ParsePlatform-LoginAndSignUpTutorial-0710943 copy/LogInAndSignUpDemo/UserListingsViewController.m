//
//  UserListingsViewController.m
//  Keap
//
//  Created by Hana Hyder on 11/22/15.
//
//

#import "UserListingsViewController.h"
//#import "UserListingsViewController.h"
#import "ListBidTableViewCell.h"
#import "BidTableViewCell.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif


@interface UserListingsViewController ()

@end

@implementation UserListingsViewController

@synthesize userListings, qArray, heightArray, itemArray, itemTemp, itemBidNumber, counter;

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
  heightArray = [NSMutableArray array];
  itemArray   = [NSMutableArray array];
  [itemArray addObject:@"temp"];
  itemBidNumber = 0;
  counter = 0;
  PFQuery *query = [PFQuery queryWithClassName:@"Listings"];
  [query whereKey:@"ownerID" equalTo:[PFUser currentUser].objectId];
  [query orderByDescending:@"updatedAt"];
  NSInteger lim = [query countObjects];
  qArray = [query findObjects];
  itemBidNumber = lim;
  
  [heightArray addObject:[NSNumber numberWithInt:44]];
  
  for(int i = 0; i < lim; i++)
  {
    [heightArray addObject:[NSNumber numberWithInt:267]];
    [itemArray addObject:@"temp"];
    int temp = [((PFObject *)(qArray[i]))[@"bids"] intValue];
    itemBidNumber += temp; //[((PFObject *)(qArray[i]))[@"bids"] intValue];
    if(temp != 0)
    {
      
      PFQuery *qTemp = [PFQuery queryWithClassName:@"Bids"];
      [qTemp whereKey:@"listingID" equalTo:[(PFObject *)(qArray[i]) objectId]];
      NSArray *t = [qTemp findObjects];
      NSLog(@"Did it pick up? %@", t);
      [itemArray addObjectsFromArray:t];
      
    }
    while(temp != 0)
    {
      [heightArray addObject:[NSNumber numberWithInt:44]];
      temp = temp - 1;
    }
    
  }
  
  itemTemp = 0;
  //NSLog(@"THE ARRAY IS: %@", itemArray);
  
  if(lim == 0)
  {
    
    int imageHeight = [UIScreen mainScreen].bounds.size.width*[UIImage imageNamed:@"no_listings_image.png"].size.height/[UIImage imageNamed:@"no_listings_image.png"].size.width;
    UIImageView *sadness = [[UIImageView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - imageHeight)/2, [UIScreen mainScreen].bounds.size.width, imageHeight)];
    sadness.image = [UIImage imageNamed:@"no_listings_image.png"];
    
    [self.view addSubview:sadness];
    userListings.alpha = 0;
  }
  
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.row == 0)
  {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    //cell.backgroundColor = [UIColor colorWithRed:0 green:0.7411 blue:1 alpha:1];
    //cell.textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    cell.textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    cell.textLabel.text = @"Your Listings";
    cell.textLabel.textAlignment = ALIGN_CENTER;
    
    //[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    cell.backgroundColor = [UIColor colorWithRed:0.6235 green:0.8706 blue:0 alpha:1];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10.0f, 10.0f, 24.0f, 24.0f);
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"white_back_button.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:backButton];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
  }
  if(itemTemp == 0)
  {
    ListBidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ownerCell"];
    
    if(!cell)
    {
      [tableView registerNib:[UINib nibWithNibName:@"ListBidTableViewCell" bundle:nil] forCellReuseIdentifier:@"ownerCell"];
      cell = [tableView dequeueReusableCellWithIdentifier:@"ownerCell"];
    }
    
    itemTemp = [((PFObject *)(qArray[counter]))[@"bids"] intValue];
    PFObject *temp = (PFObject *)qArray[counter];
    cell.itemName.text = temp[@"itemName"];
    cell.itemName.adjustsFontSizeToFitWidth = YES;
    
    cell.price.text = [NSString stringWithFormat:@"$%@", temp[@"price"]];
    //cell.category.text = temp[@"category"];
    PFFile *fil = temp[@"image"];
    cell.itemImage.image = [UIImage imageWithData:[fil getData]];
    //  self.headerImageView.layer.cornerRadius = 50.0f;
    //self.headerImageView.layer.masksToBounds = YES;
    cell.itemImage.layer.cornerRadius = 10.0f;
    cell.itemImage.layer.masksToBounds = YES;
    //cell.itemDescrip.text = temp[@"description"];
    
    
    counter = counter + 1;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
  }
  else
  {
    BidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bidderCell"];
    
    if(!cell)
    {
      [tableView registerNib:[UINib nibWithNibName:@"BidTableViewCell" bundle:nil] forCellReuseIdentifier:@"bidderCell"];
      cell = [tableView dequeueReusableCellWithIdentifier:@"bidderCell"];
    }
    
    PFObject *temp = (PFObject *)itemArray[indexPath.row];
    NSLog(@"TESTING: ***: %@", temp);
    cell.bidAmount.text = [NSString stringWithFormat:@"$%@", temp[@"bidPrice"]];
    cell.userName.text = temp[@"bidderName"];
    cell.userName.adjustsFontSizeToFitWidth = YES;
    cell.bidObjectIdW = temp.objectId;
    
    if([temp[@"isAccepted"] boolValue] == true)
    {
      //NSLog(@"THIS HAS BEEN ACCEPTED");
      cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
      cell.userInteractionEnabled = NO;
      //cell.alpha = 0.2f;
      cell.userImage.alpha  = 0.2f;
      cell.bidAccept.alpha = 0.2f;
      cell.bidReject.alpha = 0.2f;
      cell.userName.alpha = 0.2f;
      
      //cell.opaque = YES;
    }
    
    /*NSString *userProfilePhotoURLString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", temp[@"bfbID"]];
    
    //http://graph.facebook.com/10207310250580379/picture?type=square";
    // Download the user's facebook profile picture
    if (userProfilePhotoURLString) {
      NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
      NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
      
      [NSURLConnection sendAsynchronousRequest:urlRequest
                                         queue:[NSOperationQueue mainQueue]
                             completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError == nil && data != nil) {
                                 cell.userImage.image = [UIImage imageWithData:data];
                                 
                                 // Add a nice corner radius to the image
                                 cell.userImage.layer.cornerRadius = 15.0f;
                                 cell.userImage.layer.masksToBounds = YES;
                               } else {
                                 NSLog(@"Failed to load profile photo.");
                               }
                             }];
    }*/
    
    
    
    
    
    itemTemp = itemTemp - 1;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
  }
  
  return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSLog(@"itemBidNumber is: %ld", (long)itemBidNumber);
  return itemBidNumber + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  return [[heightArray objectAtIndex:indexPath.row] floatValue];
}

- (IBAction)backButtonTouchHandler:(id)sender {
  
  [self.navigationController popViewControllerAnimated:YES];
  // [self dismissViewControllerAnimated:YES completion:nil];
  
  //[self.parentViewController.navigationController popViewControllerAnimated:YES];
  
}

-(BOOL)prefersStatusBarHidden{
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
