//
//  PostListingViewController.m
//  Keap
//
//  Created by Hana Hyder on 11/25/15.
//
//

#import "PostListingViewController.h"
#import "OBOListViewController.h"

@interface PostListingViewController ()

@end

@implementation PostListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
 /* fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginFieldBG.png"]];
  [self.logInView addSubview:self.fieldsBackground];
  [self.logInView sendSubviewToBack:self.fieldsBackground];*/
  
  UIImageView *multibtn = [[UIImageView alloc]
                           initWithImage:[UIImage imageNamed:@"sell-background-compressed.png"]];
  float x = [UIScreen mainScreen].bounds.size.width/[UIImage imageNamed:@"sell-background-compressed.png"].size.width;
  multibtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIImage imageNamed:@"sell-background-compressed.png"].size.height*x);
  [self.view addSubview:multibtn];
  [self.view sendSubviewToBack:multibtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sellButtonTouchHandler:(id)sender {
  OBOListViewController *vc = [[OBOListViewController alloc] init];
  vc.mess = 1;
  //vc.itemObjectID   = itObId;
  [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)oboButtonTouchHandler:(id)sender {
  
  OBOListViewController *vc = [[OBOListViewController alloc] init];
  vc.mess = 2;
  //vc.itemObjectID   = itObId;
  [self.navigationController pushViewController:vc animated:YES];
  
}
- (IBAction)reqButtonTouchHandler:(id)sender {
  
}
- (IBAction)offButtonTouchHandler:(id)sender {
  
}

@end
