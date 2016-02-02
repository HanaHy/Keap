//
//  DescTableViewCell.h
//  Keap
//
//  Created by Hana Hyder on 11/30/15.
//
//

#import <UIKit/UIKit.h>

@interface DescTableViewCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField  *itemName;
@property (nonatomic, strong) IBOutlet UITextView  *itemDescrip;

@end
