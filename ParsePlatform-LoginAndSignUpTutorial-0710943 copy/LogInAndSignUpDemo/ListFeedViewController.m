//
//  ListFeedViewController.m
//  Keap
//
//  Created by Hana Hyder on 9/1/15.
//  Copyright (c) 2015 Hana. All rights reserved.
//

#import "ListFeedViewController.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "NewsTableViewCell.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "ItemDetailViewController.h"
#import "KeapAPIBot.h"
#import "KeapUser.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface ListFeedViewController ()

@property (strong, nonatomic) KeapAPIBot *apiBot;
@property (strong, nonatomic) dispatch_queue_t apiThread;

@end

@implementation ListFeedViewController

@synthesize newsListings, qArray, itObId;

- (void)viewDidLoad {
  [super viewDidLoad];
  //[[[self tabBarController] navigationItem] setTitle:@"News Feed"];
//  if([PFUser currentUser][@"emailVerified"] == false)
//  {
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verify Your Email" message:@"Sorry, you must first verify your email to access this feature." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    
//    [alert show];
//  }
//  else{
//    
//    PFQuery *query = [PFQuery queryWithClassName:@"Listings"];
//    [query whereKey:@"school" equalTo:[PFUser currentUser][@"school"]];
//    NSInteger lim = [query countObjects];
//    [query setLimit:lim];
//    [query orderByDescending:@"updatedAt"];
//    qArray = [query findObjects];
//  }
    
    self.apiBot = [KeapAPIBot botWithDelegate:self];
    self.apiThread = dispatch_queue_create("listfeed.api", DISPATCH_QUEUE_SERIAL);
  
  /*CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
   tabFrame.size.height = 75;
   tabFrame.origin.y = self.view.frame.size.height - 75;
   self.tabBar.frame = tabFrame;*/
   //[UIApplication sharedApplication].statusBarHidden = true;
  
  /*UIImageView *multibtn = [[UIImageView alloc]
                           initWithImage:[UIImage imageNamed:@"knack-newsfeed-banner.png"]];
  multibtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 180)/2, 0, 180, 45);
  [self.view addSubview:multibtn];*/
  // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated  {
  [super viewWillAppear:YES];
  
  /*if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
  {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor=[UIColor colorWithRed:0.521 green:0.718 blue:1.0 alpha:0.8];*/
    /*NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *rootViewController = (UIViewController *)[viewControllers objectAtIndex:viewControllers.count - 2];
    [rootViewController.view addSubview:view];*/
    
    /*[self.view addSubview:view];
    
  }*/
    
}

- (void)viewDidAppear:(BOOL)animated {
    dispatch_async(self.apiThread, ^{
        [self.apiBot fetchListings:[[KeapUser currentUser] school] completion:^(KeapAPISuccessType result, NSDictionary *response) {
            //
            if (result == success) {
                NSArray *listings = [response objectForKey:@"listings"];
                if ([listings count] == 0) {
                    // There are no listings for this school
                }
                NSLog(@"%s %@",__FUNCTION__, listings);
                qArray = listings;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.newsListings reloadData];
                });
            }
        }];
    });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  PFQuery *query = [PFQuery queryWithClassName:@"Listings"];
//  [query whereKey:@"school" equalTo:[PFUser currentUser][@"school"]];
//  return [query countObjects];
//  // return 2;
    return [qArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
  /*static NSString *CellIdentifier = @"newFriendCell";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
   if (cell == nil) {
   cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
   }*/
  NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
  
  if(!cell)
  {
    [tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"newFriendCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
  }
    
//    school = EmbeddedModelField('School')
//    owner = EmbeddedModelField('User')
//    name = models.CharField(max_length=150)
//    price = models.DecimalField(max_digits=8, decimal_places=2)
//    bids = ListField(EmbeddedModelField('Bid'))
//    description = models.TextField()
//    images = models.CharField(max_length=150)
    
    
  
  //cell.itemName.text = @"temp";
  NSInteger i = indexPath.row;
  PFObject *temp = ((PFObject *)(qArray[i]));
  cell.itemName.text = temp[@"itemName"];
  cell.itemName.adjustsFontSizeToFitWidth = YES;
  PFFile *fil = temp[@"image"];
  cell.itemImage.image = [UIImage imageWithData:[fil getData]];
  //  self.headerImageView.layer.cornerRadius = 50.0f;
  //self.headerImageView.layer.masksToBounds = YES;
  cell.itemImage.layer.cornerRadius = 5.0f;
  cell.itemImage.layer.masksToBounds = YES;
  cell.itemDescrip.text = temp[@"description"];
  
  if(temp[@"price"] == [NSNumber numberWithInt:0])
  {
    cell.price.text = [NSString stringWithFormat:@"%@", @"FREE"];
  }
  else {
    cell.price.text = [NSString stringWithFormat:@"$%@",temp[@"price"]];
  }
  
  cell.price.adjustsFontSizeToFitWidth  = YES;
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
   //cell.selectionStyle = UITableViewCellSelectionStyleGray;
  
  return cell;
}


/* TESTING */

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  // Add your Colour.
  NewsTableViewCell *cell = (NewsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  [self setCellColor:[UIColor colorWithWhite:0.961 alpha:1.000] ForCell:cell];  //highlight colour
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  // Reset Colour.
  NewsTableViewCell *cell = (NewsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  [self setCellColor:[UIColor whiteColor] ForCell:cell]; //normal color
  
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
  cell.contentView.backgroundColor = color;
  cell.backgroundColor = color;
}

/* DONE */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  PFObject *temp = ((PFObject *)qArray[indexPath.row]);
  
  itObId = temp.objectId;
  ItemDetailViewController *vc = [[ItemDetailViewController alloc] init];
  vc.itemObjectID   = itObId;
  [self.navigationController pushViewController:vc animated:YES];
  
  
  //[self performSegueWithIdentifier:@"PopDetails" sender:tableView];
  //NSLog(@"This id of this number is %@", temp.objectId);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  
  if([[segue identifier] isEqualToString:@"PopDetails"])
  {
    ItemDetailsViewController *vc = [segue destinationViewController];
    vc.itemObjectID   = itObId;
  }
}*/

-(BOOL)prefersStatusBarHidden{
  return YES;
}





@end
