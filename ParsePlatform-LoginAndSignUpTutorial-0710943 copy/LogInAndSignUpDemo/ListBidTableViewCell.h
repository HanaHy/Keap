//
//  ListBidTableViewCell.h
//  Keap
//
//  Created by Hana Hyder on 11/22/15.
//
//

#import <UIKit/UIKit.h>

@interface ListBidTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel     *itemName;
@property (nonatomic, strong) IBOutlet UIImageView *itemImage;
@property (nonatomic, strong) IBOutlet UILabel     *price;
//@property (nonatomic, strong) IBOutlet UILabel     *category;
//@property (nonatomic, strong) IBOutlet UITextView  *itemDescrip;
@property (nonatomic)         NSString*     listObjectId;
@property (nonatomic, strong) IBOutlet UIButton *rejectButton;
@property (nonatomic, strong) IBOutlet UIButton *acceptButton;

- (IBAction)rejectButtonTouchHandler:(id)sender;
- (IBAction)acceptButtonTouchHandler:(id)sender;


@end
