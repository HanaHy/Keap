//
//  ItemCollectionViewCell.h
//  Keap
//
//  Created by Hana Hyder on 12/25/15.
//
//

#import <UIKit/UIKit.h>

@interface ItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel      *name;
@property (nonatomic, strong) IBOutlet UILabel      *price;
@property (nonatomic, strong) IBOutlet UIImageView  *img;
@property (nonatomic, strong) IBOutlet  UIView      *minView;

@property (nonatomic)         NSString*     objectId;

@end
