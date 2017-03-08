 //
//  MessagesViewController.m
//  Keap
//
//  Created by Hana Hyder on 12/26/15.
//
//

#import "MessagesViewController.h"
#import "MessagesTableViewCell.h"
#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

@interface MessagesViewController ()

@end

@implementation MessagesViewController

@synthesize userMessages, qArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  
  if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
  {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor=[UIColor colorWithRed:0.0 green:0.831 blue:0.525 alpha:1];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.row == 0)
  {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    //cell.backgroundColor = [UIColor colorWithRed:0 green:0.7411 blue:1 alpha:1];
    //cell.textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    cell.textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    cell.textLabel.text = @"Messages";
    cell.textLabel.textAlignment = ALIGN_CENTER;
    
    //[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    cell.backgroundColor = [UIColor colorWithRed:0.0 green:0.831 blue:0.525 alpha:1]; //friendlier green
   //     cell.backgroundColor = [UIColor colorWithRed:0.306 green:0.710 blue:0.0 alpha:1];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10.0f, 10.0f, 24.0f, 24.0f);
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"white_add_arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(newButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:backButton];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
  }
  else
  {
    MessagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainMessage"];
    
    if(!cell)
    {
      [tableView registerNib:[UINib nibWithNibName:@"MessagesTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainMessage"];
      cell = [tableView dequeueReusableCellWithIdentifier:@"mainMessage"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
  }
  
  
  return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //NSLog(@"itemBidNumber is: %ld", itemBidNumber);
  return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  return (indexPath.row == 0) ? 44.0f : 146.0f;
}

- (IBAction)newButtonTouchHandler:(id)sender {
  
  [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please Forgive Me", nil) message:[NSString stringWithFormat:@"Sorry guys, currently still developing this feature! %C", 0xe108] delegate:nil cancelButtonTitle:NSLocalizedString(@"I forgive you.", nil) otherButtonTitles:nil] show];
    
  //[self.navigationController popViewControllerAnimated:YES];
  // [self dismissViewControllerAnimated:YES completion:nil];
  
  //[self.parentViewController.navigationController popViewControllerAnimated:YES];
  
} //Creates a new message.


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
