//
//  NewsTableViewCell.h
//  SkaderApp
//
//  Created by Hana Hyder on 9/3/15.
//  Copyright (c) 2015 Hana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel     *itemName;
@property (nonatomic, strong) IBOutlet UITextView  *itemDescrip;
@property (nonatomic, strong) IBOutlet UIImageView *itemImage;
@property (nonatomic, strong) IBOutlet UILabel     *price;

@end
