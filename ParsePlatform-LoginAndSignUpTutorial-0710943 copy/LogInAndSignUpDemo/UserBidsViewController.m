//
//  UserBidsViewController.m
//  Keap
//
//  Created by Hana Hyder on 12/31/15.
//
//

#import "UserBidsViewController.h"
#import "PersonalTableViewCell.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>


#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

@interface UserBidsViewController ()

@end

@implementation UserBidsViewController

@synthesize qArray, userListings, numOfBids;

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  
  qArray = [NSMutableArray array];
  
  PFQuery *query = [PFQuery queryWithClassName:@"Bids"];
  [query whereKey:@"requester" equalTo:[PFUser currentUser].objectId];
  [query orderByDescending:@"updatedAt"];
  numOfBids = [query countObjects];
  NSArray *t = [query findObjects];

  //NSLog(@"Did it pick up? %@", t);
  [qArray addObjectsFromArray:t];
  
  //NSLog(@"What now? %@", qArray);
  
  if([qArray count] == 0)
  {
    
    int imageHeight = [UIScreen mainScreen].bounds.size.width*[UIImage imageNamed:@"no_listings_image.png"].size.height/[UIImage imageNamed:@"no_listings_image.png"].size.width;
    UIImageView *sadness = [[UIImageView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - imageHeight)/2, [UIScreen mainScreen].bounds.size.width, imageHeight)];
    sadness.image = [UIImage imageNamed:@"no_listings_image.png"];
    
    [self.view addSubview:sadness];
    userListings.alpha = 0;
  }
  
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view from its nib.
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
    cell.textLabel.text = @"Your Bids";
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
  else
  {
    PersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"persCell"];
    
    if(!cell)
    {
      [tableView registerNib:[UINib nibWithNibName:@"PersonalTableViewCell" bundle:nil] forCellReuseIdentifier:@"persCell"];
      cell = [tableView dequeueReusableCellWithIdentifier:@"persCell"];
    }
    
    /*
     @property (nonatomic, strong) IBOutlet UILabel      *itemName;
     @property (nonatomic, strong) IBOutlet UILabel      *price;
     @property (nonatomic, strong) IBOutlet UILabel      *status;
     @property (nonatomic, strong) IBOutlet UIImageView  *img;
     */
    
    PFObject *temp = (PFObject *)qArray[indexPath.row - 1];
   
    NSString *f = temp[@"listingID"];
    PFQuery *query = [PFQuery queryWithClassName:@"Listings"];
    [query whereKey:@"objectId" equalTo:f];
    PFObject *item = [query getFirstObject];
    //NSLog(@"F THIS %@", item);
    
    cell.itemName.text = item[@"itemName"];
   /* cell.name.text = item[@"itemName"]; */
   // cell.price.text = temp[@"bidPrice"];
    //NSLog(@"%@****", temp[@"bidPrice"]);
    cell.price.text = [NSString stringWithFormat:@"$%@",temp[@"bidPrice"]];
    
   if([temp[@"isAccepted"] boolValue] == true)
    {
      cell.status.text = @"Accepted";
      cell.status.textColor = [UIColor colorWithRed:0.306 green:0.709 blue:0 alpha:1.0];
      cell.price.textColor = [UIColor colorWithRed:0.306 green:0.709 blue:0 alpha:1.0];
      
    }
    else
    {
      cell.status.text = @"Pending";
      cell.status.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    }
    
    
    
    /*
     PFFile *fil = temp[@"image"];
     cell.img.image = [UIImage imageWithData:[fil getData]];
     //  self.headerImageView.layer.cornerRadius = 50.0f;
     //self.headerImageView.layer.masksToBounds = YES;
     cell.img.layer.cornerRadius = 10.0f;
     cell.img.layer.masksToBounds = YES;
     */
    
    PFFile *fil = item[@"image"];
    cell.img.image = [UIImage imageWithData:[fil getData]];
    
    cell.img.layer.cornerRadius = 10.0f;
    cell.img.layer.masksToBounds  = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
  }
  
  return nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //NSLog(@"itemBidNumber is: %ld", (long)itemBidNumber);
  return numOfBids + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  return (indexPath.row == 0) ? 44.0f : 146.0f;
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
