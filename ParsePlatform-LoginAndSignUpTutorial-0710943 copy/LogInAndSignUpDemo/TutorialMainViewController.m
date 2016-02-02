//
//  TutorialMainViewController.m
//  Keap
//
//  Created by Hana Hyder on 11/11/15.
//
//

#import "TutorialMainViewController.h"
#import "TutorialViewController.h"

@interface TutorialMainViewController ()

@end

@implementation TutorialMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [UIColor blueColor];
    // Do any additional setup after loading the view.
  
  self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
  
  self.pageController.dataSource = self;
  [[self.pageController view] setFrame:[[self view] bounds]];
  
  TutorialViewController *initialViewController = [self viewControllerAtIndex:0];
  
  NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
  
  [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
  
  [self addChildViewController:self.pageController];
  [[self view] addSubview:[self.pageController view]];
  [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
  // The number of items reflected in the page indicator.
  return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
  // The selected item reflected in the page indicator.
  return 0;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
  
  NSUInteger index = [(TutorialViewController *)viewController index];
  
  if (index == 0) {
    return nil;
  }
  
  index--;
  
  return [self viewControllerAtIndex:index];
  
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  
  NSUInteger index = [(TutorialViewController *)viewController index];
  
  
  index++;
  
  if (index == 5) {
    //[self dismissViewControllerAnimated:YES completion:NULL];
    //[self.parentViewController dismissViewControllerAnimated:YES completion:NULL];
    return nil;
  }
  
  return [self viewControllerAtIndex:index];
  
}

- (TutorialViewController *)viewControllerAtIndex:(NSUInteger)index {
  
  TutorialViewController *childViewController = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
  childViewController.index = index;
  
  return childViewController;
  
}

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
  NSLog(@"****REACHED****");
  TutorialViewController *viewController =
  [pendingViewControllers objectAtIndex:0];
  if ([viewController index] == 5)
  {
    //[self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
  }
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
