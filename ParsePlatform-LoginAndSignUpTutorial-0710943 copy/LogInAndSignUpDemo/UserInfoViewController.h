//
//  UserInfoViewController.h
//  Keap
//
//  Created by Hana Hyder on 12/24/15.
//
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *userBids;
@property (nonatomic, strong) IBOutlet UIButton *userListings;

- (IBAction)userBidsButtonTouchHandler:(id)sender;
- (IBAction)userListingsButtonTouchHandler:(id)sender;

@end
