//
//  SearchViewController.m
//  Keap
//
//  Created by Hana Hyder on 11/30/15.
//
//


#import "SearchViewController.h"
#import "SBarTableViewCell.h"
#import "SearchGridViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize categoryListings, categories;


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  categories = [[NSMutableArray alloc] init];
  
  [categories addObject:@"Accessories"];
  [categories addObject:@"Bikes & Auto"];
  
  [categories addObject:@"Clothing"];
  [categories addObject:@"DC Swipes"];
  
  [categories addObject:@"Electronics"];
  [categories addObject:@"Furniture"];
  [categories addObject:@"Gardening"];
  [categories addObject:@"Kitchen"];
  //[categories addObject:@"Labor & Moving"];
  [categories addObject:@"Outdoor & Recreation"];
  [categories addObject:@"Pets & Supply"];
  [categories addObject:@"School Supplies"];
  [categories addObject:@"Textbooks"];
  [categories addObject:@"Tickets"];
  [categories addObject:@"Other"];
  /*[categories addObject:@"Accessories"];
   [categories addObject:@"Bath"];
   [categories addObject:@"Bed"];
   [categories addObject:@"Bikes"];
   [categories addObject:@"Books & Textbooks"];
   [categories addObject:@"Clothes"];
   [categories addObject:@"Cool Surprise"];
   [categories addObject:@"Furniture"];
   [categories addObject:@"Kitchen"];
   [categories addObject:@"Room Decor"];
   [categories addObject:@"School Supplies"];
   [categories addObject:@"Misc."];*/
  
  /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];*/
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  
  if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
  {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor=[UIColor colorWithRed:1 green:0.756863 blue:0 alpha:1];
    /*NSArray *viewControllers = self.navigationController.viewControllers;
     UIViewController *rootViewController = (UIViewController *)[viewControllers objectAtIndex:viewControllers.count - 2];
     [rootViewController.view addSubview:view];*/
    
    [self.view addSubview:view];
    
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 15;
  // return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if(indexPath.row == 0)
  {
    SBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if(!cell)
    {
      [tableView registerNib:[UINib nibWithNibName:@"SBarTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
      cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.searchBar.delegate = self;
    cell.searchBar.tag = 101;
    
    return cell;
  }
  
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  
  //cell.backgroundColor = [UIColor colorWithRed:0 green:0.7411 blue:1 alpha:1];
  //cell.textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
  cell.textLabel.textColor = [UIColor colorWithRed:1 green:0.756863 blue:0 alpha:1];
  cell.textLabel.text = [categories objectAtIndex:(indexPath.row - 1)];
  cell.textLabel.textAlignment = ALIGN_CENTER;
  
  [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  //cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:1 green:0.756863 blue:0 alpha:1];
  
  /*if(indexPath.row % 2 == 0)
   {
   cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.98  blue:0.96 alpha:1];
   }*/
  
  /* switch(indexPath.row)
   {
   case 0:
   cell.backgroundColor = [UIColor colorWithRed:1 green:0.756863 blue:0 alpha:1];
   break;
   case 1:
   cell.backgroundColor = [UIColor colorWithRed:0.988235 green:0.86275 blue:0.44706 alpha:1];
   break;
   case 2:
   cell.backgroundColor = [UIColor colorWithRed:0 green:0.7411 blue:1 alpha:1];
   break;
   case 3:
   cell.backgroundColor = [UIColor colorWithRed:0.47 green:0.82 blue:0.93 alpha:1];
   break;
   case 4:
   cell.backgroundColor = [UIColor colorWithRed:0.623529 green:0.870588 blue:0 alpha:1];
   break;
   case 5:
   cell.backgroundColor = [UIColor colorWithRed:0.11 green:0.74 blue:0.52 alpha:1];
   break;
   case 6:
   cell.backgroundColor = [UIColor colorWithRed:0.30588 green:0.709804 blue:0 alpha:1];
   break;
   case 7:
   cell.backgroundColor = [UIColor colorWithRed:0.24 green:0.48 blue:0.88 alpha:1];
   break;
   case 8:
   cell.backgroundColor = [UIColor colorWithRed:0.56 green:0.73 blue:0.99 alpha:1];
   break;
   case 9:
   cell.backgroundColor = [UIColor colorWithRed:0 green:0.7411 blue:1 alpha:1];
   break;
   case 10:
   cell.backgroundColor = [UIColor colorWithRed:1 green:0.44 blue:0.60 alpha:1];
   break;
   case 11:
   cell.backgroundColor = [UIColor colorWithRed:0.988235 green:0.86275 blue:0.44706 alpha:1];
   break;
   
   }*/
  return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //return 100;
  if(indexPath.row == 0)
  {
    return 64;
  }
  return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
  if(indexPath.row != 0)
  {
    SearchGridViewController  *vc = [[SearchGridViewController alloc] init];
    //vc.pq = [PFQuery queryWithClassName:@"Listings"];//= [[PFQuery queryWithClassName:@"Listings"];
    //[vc.pq whereKey:@"school" equalTo:[PFUser currentUser][@"school"]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Listings"];
    [query whereKey:@"school" equalTo:[PFUser currentUser][@"school"]];
    [query whereKey:@"category" equalTo:categories[indexPath.row - 1]];
    NSInteger lim = [query countObjects];
    if(lim != 0)
    {
      [query setLimit:lim];
      [query orderByAscending:@"updatedAt"];
      vc.qArray = [query findObjects];
    }
    
    vc.titleText = categories[indexPath.row - 1];
    
    [self.navigationController pushViewController:vc animated:YES];
  }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
  [theSearchBar resignFirstResponder];
  [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please Forgive Me", nil) message:[NSString stringWithFormat:@"Sorry guys, currently still developing this feature! %C", 0xe108] delegate:nil cancelButtonTitle:NSLocalizedString(@"I forgive you.", nil) otherButtonTitles:nil] show];
  
  //[theSearchBar resignFirstResponder];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
}

-(void)dismissKeyboard {
  [(UISearchBar *)[self.view viewWithTag:101] resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [(UISearchBar *)[self.view viewWithTag:101] resignFirstResponder];
}

/*- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField.tag == 1) {
    [textField resignFirstResponder];
    [(UITextField *)[self.view viewWithTag:2] becomeFirstResponder];
    //[_itemDescrip becomeFirstResponder];
  } else if (textField.tag == 2 || textField.tag == 3) {
    [textField resignFirstResponder];
    // here you can define what happens
    //[_itemDescrip endEditing:YES];
    //    [self.view endEditing:YES];
  }
  return YES;
}*/

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


/*
 
 OBOListViewController *vc = [[OBOListViewController alloc] init];
 //vc.itemObjectID   = itObId;
 [self.navigationController pushViewController:vc animated:YES];
 
 */

@end
