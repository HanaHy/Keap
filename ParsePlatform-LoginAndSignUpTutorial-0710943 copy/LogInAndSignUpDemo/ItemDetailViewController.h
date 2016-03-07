//
//  ItemDetailViewController.h
//  Keap
//
//  Created by Hana Hyder on 11/21/15.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface ItemDetailViewController : UIViewController  <MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView  *itemImage;
@property (nonatomic, strong) IBOutlet  UILabel     *itemName;
@property (nonatomic, strong) IBOutlet UILabel     *itemPrice;
@property (nonatomic, strong) IBOutlet UIButton *bidPrice;
@property (nonatomic, strong) IBOutlet UILabel     *category;
@property (nonatomic, strong) IBOutlet UITextView     *itemDescrip;
@property (nonatomic, strong) IBOutlet UILabel     *date;
@property (nonatomic, strong) IBOutlet UILabel     *bidNumber;
@property (nonatomic, strong) IBOutlet UILabel     *userName;
@property (nonatomic, strong) IBOutlet UIImageView *userPhoto;
@property (nonatomic, strong) IBOutlet UILabel     *userSchool;
@property (nonatomic, strong) IBOutlet UIButton *bidButton;
@property (nonatomic, strong) IBOutlet UIButton *contactButton;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UIView   *headerBG;

@property (nonatomic)         NSDictionary* itemInfo;


@property (nonatomic)         NSString*     itemObjectID;
@property (nonatomic)         UIColor*       allColor;
@property (nonatomic)         bool          canBid;
@property (nonatomic)         int           val;
@property (nonatomic)         NSString*     ownerID;


- (IBAction)BackButtonTouchHandler:(id)sender;
- (IBAction)BidButtonTouchHandler:(id)sender;
- (IBAction)contactButtonTouchHandler:(id)sender;

@end
