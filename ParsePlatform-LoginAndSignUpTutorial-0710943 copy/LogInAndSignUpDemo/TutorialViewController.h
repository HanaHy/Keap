//
//  TutorialViewController.h
//  Keap
//
//  Created by Hana Hyder on 11/11/15.
//
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *screenNumber;
@property (strong, nonatomic) IBOutlet  UIButton  *closeButton;

- (IBAction)confirmButtonTouchHandler:(id)sender;

@end
