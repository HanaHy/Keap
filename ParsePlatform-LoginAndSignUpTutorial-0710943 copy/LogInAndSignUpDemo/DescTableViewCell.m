//
//  DescTableViewCell.m
//  Keap
//
//  Created by Hana Hyder on 11/30/15.
//
//

#import "DescTableViewCell.h"

@implementation DescTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) textViewDidBeginEditing:(UITextView *) textView {
  [textView setText:@""];
}
@end
