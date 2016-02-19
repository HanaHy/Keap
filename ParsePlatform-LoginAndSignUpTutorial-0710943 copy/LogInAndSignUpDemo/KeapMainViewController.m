//
//  KeapMainViewController.m
//  Keap
//
//  Created by Hana Hyder on 11/12/15.
//
//

#import "KeapMainViewController.h"
#import "ListFeedViewController.h"
#import "PostListingViewController.h"
//#import "UserListingsViewController.h"
#import "UserInfoViewController.h"
#import "SearchViewController.h"
#import "MessagesViewController.h"
#import "Keap-Swift.h"

@interface KeapMainViewController ()

@end

@implementation KeapMainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  UIViewController *vc1 = [[ListFeedViewController alloc] initWithNibName:@"ListFeedViewController" bundle:nil];
  vc1.title = @"1";
  [[vc1 navigationItem] setTitle:@"News Feed"];
  //vc1.view.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200);
  //vc1.view.backgroundColor = [UIColor whiteColor];
  
  UIViewController *vc2 = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
  vc2.title = @"2";
  //vc2.view.backgroundColor = [UIColor redColor];
  
  UIViewController *vc3 = [[PostListingViewController alloc] initWithNibName:@"PostListingViewController" bundle:nil];
  vc3.title = @"3";
  //vc3.view.backgroundColor = [UIColor colorWithRed:0.47 green:0.82 blue:0.93 alpha:1];
  //vc3.view.backgroundColor = [UIColor colorWithRed:0.24 green:0.48 blue:0.88 alpha:1];
  
  /*UIViewController *vc4 = [[UIViewController alloc] init];
  vc4.title = @"4";
  //vc4.view.backgroundColor = [UIColor yellowColor];
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];//[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = view.bounds;
  gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.624 green:0.871 blue:0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:0.11 green:1.0 blue:0.77 alpha:1.0] CGColor], nil];
  [view.layer insertSublayer:gradient atIndex:0];
  [vc4.view addSubview:view];*/
  
  
  UIViewController *vc4 = [[MessagesViewController alloc] initWithNibName:@"MessagesViewController" bundle:nil];
  vc4.title = @"4";
  
  UIViewController *vc5 = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];//[[UIViewController alloc] init];
  vc5.title = @"5";
  //vc5.view.backgroundColor = [UIColor purpleColor];
  
  UITabBarController *tabBar = [[UITabBarController alloc] init];
  tabBar.viewControllers = @[vc1,vc2, vc3, vc4, vc5];
  
  tabBar.selectedIndex   = 0;
  tabBar.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
 // tabBar.viewControllers[0].view.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200);

  
  [tabBar willMoveToParentViewController:self];
  [self.view addSubview:tabBar.view];
  [self addChildViewController:tabBar];
  [tabBar didMoveToParentViewController:self];
 // [tabBar setTitle:@"TESTING"];
  
  CGRect tabFrame = tabBar.view.frame; //self.TabBar is IBOutlet of TabBar
  tabFrame.size.height = 57;
  tabFrame.origin.y = self.view.frame.size.height - 57;
  //tabBar.view.frame = tabFrame;
  [UIApplication sharedApplication].statusBarHidden = true;
  UIImageView *multibtn = [[UIImageView alloc]
                           initWithImage:[UIImage imageNamed:@"weeebar.png"]];
  multibtn.frame = CGRectMake(0, tabFrame.origin.y - 1, self.view.frame.size.width, 58);
  [self.view addSubview:multibtn];
  
  //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  
    [KeapChat client];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  
  /*(UITabBarController  *tabVC = [[UITabBarController alloc] init];
  ListFeedViewController *viewController1 = [[ListFeedViewController alloc] initWithNibName:@"ListFeedViewController" bundle:nil];
  tabVC.viewControllers = @[viewController1];*/
  
  //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 //rootViewController = tabVC;
}
- (void)viewWillLayoutSubviews
{
  /*CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of TabBar
  tabFrame.size.height = 60;
  tabFrame.origin.y = self.view.frame.size.height - 60;
  self.tabBar.frame = tabFrame;
  [UIApplication sharedApplication].statusBarHidden = true;
  UIImageView *multibtn = [[UIImageView alloc]
                           initWithImage:[UIImage imageNamed:@"weeebar.png"]];
  multibtn.frame = CGRectMake(0, tabFrame.origin.y - 1, self.view.frame.size.width, 61);
  [self.view addSubview:multibtn];*/
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*-(BOOL)prefersStatusBarHidden{
  return YES;
}*/

@end
