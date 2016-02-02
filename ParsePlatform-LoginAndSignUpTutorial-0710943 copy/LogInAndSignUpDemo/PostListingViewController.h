//
//  PostListingViewController.h
//  Keap
//
//  Created by Hana Hyder on 11/25/15.
//
//

#import <UIKit/UIKit.h>

@interface PostListingViewController : UIViewController


@property (nonatomic, strong) IBOutlet UIButton *sellButton;
@property (nonatomic, strong) IBOutlet UIButton *oboButton;
@property (nonatomic, strong) IBOutlet UIButton *reqButton;
@property (nonatomic, strong) IBOutlet UIButton *offButton;


- (IBAction)sellButtonTouchHandler:(id)sender;
- (IBAction)oboButtonTouchHandler:(id)sender;
- (IBAction)reqButtonTouchHandler:(id)sender;
- (IBAction)offButtonTouchHandler:(id)sender;

@end
