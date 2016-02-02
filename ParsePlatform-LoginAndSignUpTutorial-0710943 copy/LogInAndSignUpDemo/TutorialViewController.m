//
//  TutorialViewController.m
//  Keap
//
//  Created by Hana Hyder on 11/11/15.
//
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:YES];
  self.screenNumber.text = [NSString stringWithFormat:@"Screen #%d", self.index];
  
  if(self.index != 4)
  {
    self.closeButton.alpha = 0;
  }
  

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)confirmButtonTouchHandler:(id)sender
{
  //[self.parentViewController
  [self.parentViewController.navigationController popViewControllerAnimated:YES];
  //[self.navigationController popViewControllerAnimated:YES];
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
