//
//  UserInfoViewController.m
//  Keap
//
//  Created by Hana Hyder on 12/24/15.
//
//

#import "UserInfoViewController.h"
#import "UserListingsViewController.h"
#import "UserBidsViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  UIImageView *multibtn = [[UIImageView alloc]
                           initWithImage:[UIImage imageNamed:@"list-background-compressed.png"]];
  float x = [UIScreen mainScreen].bounds.size.width/[UIImage imageNamed:@"list-background-compressed.png"].size.width;
  multibtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIImage imageNamed:@"list-background-compressed.png"].size.height*x);
  [self.view addSubview:multibtn];
  [self.view sendSubviewToBack:multibtn];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userBidsButtonTouchHandler:(id)sender {
  UserBidsViewController *vc = [[UserBidsViewController alloc] init];
  //vc.itemObjectID   = itObId;
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)userListingsButtonTouchHandler:(id)sender {
  UserListingsViewController *vc = [[UserListingsViewController alloc] init];
  //vc.itemObjectID   = itObId;
  [self.navigationController pushViewController:vc animated:YES];
  
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
