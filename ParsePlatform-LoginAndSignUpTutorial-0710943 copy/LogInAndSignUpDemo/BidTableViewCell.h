//
//  BidTableViewCell.h
//  Keap
//
//  Created by Hana Hyder on 11/22/15.
//
//

#import <UIKit/UIKit.h>

@interface BidTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *userImage;
@property (nonatomic, strong) IBOutlet UILabel     *userName;
@property (nonatomic, strong) IBOutlet UILabel     *bidAmount;
@property (nonatomic)         NSString*     bidObjectIdW;
@property (nonatomic, strong) IBOutlet UIButton *bidReject;
@property (nonatomic, strong) IBOutlet UIButton *bidAccept;


- (IBAction)rejectBidButtonTouchHandler:(id)sender;
- (IBAction)acceptBidButtonTouchHandler:(id)sender;

@end
