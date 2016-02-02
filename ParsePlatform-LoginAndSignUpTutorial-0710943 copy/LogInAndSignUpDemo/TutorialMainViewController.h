//
//  TutorialMainViewController.h
//  Keap
//
//  Created by Hana Hyder on 11/11/15.
//
//

#import <UIKit/UIKit.h>

@interface TutorialMainViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController  *pageController;

@end
