//
//  BidTableViewCell.m
//  Keap
//
//  Created by Hana Hyder on 11/22/15.
//
//

#import "BidTableViewCell.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>


@implementation BidTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)rejectBidButtonTouchHandler:(id)sender {
  PFQuery *query = [PFQuery queryWithClassName:@"Bids"];
  [query whereKey:@"objectId" equalTo:_bidObjectIdW];
  PFObject *t = [query getFirstObject];
  [t setObject:@NO forKey:@"isAccepted"];
  [t saveInBackground];
  [t deleteInBackground];
  
  
  /* TO DO: SEND MESSAGE TO USER */
  
  PFQuery *q2 = [PFQuery queryWithClassName:@"Listings"];
  [q2 whereKey:@"objectId" equalTo:t[@"listingID"]];
  PFObject *t2 = [q2 getFirstObject];
  [t2 setObject:[NSNumber numberWithInt:([t2[@"bids"] intValue] - 1)] forKey:@"bids"];
  [t2 saveInBackground];
  /*if([t2[@"price"] intValue] < [t[@"bidPrice"] intValue])
   {
   [t2 setObject:[NSNumber numberWithInt:[t[@"bidPrice"] intValue]] forKey:@"price"];
   [t2 saveInBackground];
   }*/
  
}
- (IBAction)acceptBidButtonTouchHandler:(id)sender {
  PFQuery *query = [PFQuery queryWithClassName:@"Bids"];
  [query whereKey:@"objectId" equalTo:_bidObjectIdW];
  PFObject *t = [query getFirstObject];
  [t setObject:@YES forKey:@"isAccepted"];
  [t saveInBackground];
  
  /* TO DO: SEND MESSAGE TO USER */
  
  
  PFQuery *q2 = [PFQuery queryWithClassName:@"Listings"];
  [q2 whereKey:@"objectId" equalTo:t[@"listingID"]];
  PFObject *t2 = [q2 getFirstObject];
  if([t2[@"price"] intValue] < [t[@"bidPrice"] intValue])
  {
    [t2 setObject:[NSNumber numberWithInt:[t[@"bidPrice"] intValue]] forKey:@"price"];
    [t2 saveInBackground];
  }
  
}


@end
