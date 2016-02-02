//
//  PersonalTableViewCell.h
//  Keap
//
//  Created by Hana Hyder on 1/1/16.
//
//

#import <UIKit/UIKit.h>

@interface PersonalTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel      *itemName;
@property (nonatomic, strong) IBOutlet UILabel      *price;
@property (nonatomic, strong) IBOutlet UILabel      *status;
@property (nonatomic, strong) IBOutlet UIImageView  *img;

@end
