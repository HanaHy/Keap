//
//  UserBidsViewController.m
//  Keap
//
//  Created by Hana Hyder on 12/31/15.
//
//

#import "UserBidsViewController.h"
//#import "PersonalTableViewCell.h"
#import "NewsTableViewCell.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "KeapAPIBot.h"
#import "KeapUser.h"


#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

@interface UserBidsViewController ()

@property (strong, nonatomic) KeapAPIBot *apiBot;
@property (strong, nonatomic) dispatch_queue_t apiThread;

@end

@implementation UserBidsViewController

@synthesize qArray, userListings, numOfBids;

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  
  self.apiBot = [KeapAPIBot botWithDelegate:self];
  self.apiThread = dispatch_queue_create("userbids.api", DISPATCH_QUEUE_SERIAL);
  
  //self.qArray = [NSArray new];

  self.userListings = [self.view viewWithTag:5];
  
  /*UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Back"];
  self.bar.items = [NSArray arrayWithObject:item];
  self.bar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTouchHandler:)];
  */
  //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
  //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTouchHandler:)];
  //self.bar.leftBarButtonItem = backButton;
  //self.navigationItem.leftBarButtonItem = backButton;
  
  //self.bar.backItem
  // = [[UIBarButtonItem alloc]initWithTitle:@"Details" style:UIBarButtonSystemItemDone target:nil action:@selector(backButtonTouchHandler:)];
  
  /*PFQuery *query = [PFQuery queryWithClassName:@"Bids"];
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
  */
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
  dispatch_async(self.apiThread, ^{
    [self.apiBot getAllBidsForUser:[[KeapUser currentUser] username] withCompletion:^(KeapAPISuccessType result, NSDictionary *response) {
      //
      if (result == success) {
        NSArray *bids = [response objectForKey:@"bids"];
        if ([bids count] == 0) {
          // The user has no bids.
          /* DISPLAY THE SAD FLOWER SQUIRREL */
        }
        NSLog(@"%s %@",__FUNCTION__, bids);
        self.qArray = [[NSArray alloc] initWithArray:bids];//[response allValues];
        //self.qArray = [NSArray arrayWithArray:bids];
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.userListings reloadData];
        });
      }
    }];
  });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  /*if(indexPath.row == 0)
  {
   
   UNNECESSARY! MAKING THIS A PROPER NAVIGATION BAR IN XIB
    
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
  {*/
  NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
  
  if(!cell)
  {
    [tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"newFriendCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
  }
  
  NSDictionary *bidItem = [self.qArray objectAtIndex:indexPath.row];
  cell.itemName.text = bidItem[@"name"];
  cell.itemName.adjustsFontSizeToFitWidth = YES;

  
    /*
     @property (nonatomic, strong) IBOutlet UILabel      *itemName;
     @property (nonatomic, strong) IBOutlet UILabel      *price;
     @property (nonatomic, strong) IBOutlet UILabel      *status;
     @property (nonatomic, strong) IBOutlet UIImageView  *img;
     */
    
    /*PFObject *temp = (PFObject *)qArray[indexPath.row - 1];
   
    NSString *f = temp[@"listingID"];
    PFQuery *query = [PFQuery queryWithClassName:@"Listings"];
    [query whereKey:@"objectId" equalTo:f];
    PFObject *item = [query getFirstObject];
    //NSLog(@"F THIS %@", item);
    
    cell.itemName.text = item[@"itemName"];
    cell.name.text = item[@"itemName"];
   // cell.price.text = temp[@"bidPrice"];
    //NSLog(@"%@****", temp[@"bidPrice"]);
    cell.price.text = [NSString stringWithFormat:@"$%@",temp[@"bidPrice"]];
    */
   if([bidItem[@"isAccepted"] boolValue] == true)
    {
      cell.itemDescrip.text = @"Accepted";
      cell.itemDescrip.textColor = [UIColor colorWithRed:0.306 green:0.709 blue:0 alpha:1.0];
      cell.price.textColor = [UIColor colorWithRed:0.306 green:0.709 blue:0 alpha:1.0];
      
    }
    else
    {
      cell.itemDescrip.text = @"Pending";
      cell.itemDescrip.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    }
    
    
    
    /*
     PFFile *fil = temp[@"image"];
     cell.img.image = [UIImage imageWithData:[fil getData]];
     //  self.headerImageView.layer.cornerRadius = 50.0f;
     //self.headerImageView.layer.masksToBounds = YES;
     cell.img.layer.cornerRadius = 10.0f;
     cell.img.layer.masksToBounds = YES;
     */
    
    /*PFFile *fil = item[@"image"];
    cell.img.image = [UIImage imageWithData:[fil getData]];
    
    cell.img.layer.cornerRadius = 10.0f;
    cell.img.layer.masksToBounds  = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    */
    return cell;
  //}
  
 // return nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //NSLog(@"itemBidNumber is: %ld", (long)itemBidNumber);
  //NSLog(@"******THE NUM IS: %ld", [self.qArray count]);
  
  if([self.qArray count] == 0)
  {
    
    int imageHeight = [UIScreen mainScreen].bounds.size.width*[UIImage imageNamed:@"no_listings_image.png"].size.height/[UIImage imageNamed:@"no_listings_image.png"].size.width;
    UIImageView *sadness = [[UIImageView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - imageHeight)/2, [UIScreen mainScreen].bounds.size.width, imageHeight)];
    sadness.image = [UIImage imageNamed:@"no_listings_image.png"];
    
    [self.view addSubview:sadness];
    //[tableView setHidden:YES];
    tableView.separatorColor = [UIColor clearColor];
  }
  return [self.qArray count];
}

/*- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  return (indexPath.row == 0) ? 44.0f : 146.0f;
}*/

- (IBAction)backButtonTouchHandler:(id)sender {
  
  [self.navigationController popViewControllerAnimated:YES];
  // [self dismissViewControllerAnimated:YES completion:nil];
  
  //[self.parentViewController.navigationController popViewControllerAnimated:YES];
  
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
