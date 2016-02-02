//
//  ListBidTableViewCell.m
//  Keap
//
//  Created by Hana Hyder on 11/22/15.
//
//

#import "ListBidTableViewCell.h"

@implementation ListBidTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)rejectButtonTouchHandler:(id)sender{
  
  PFQuery *query = [PFQuery queryWithClassName:@"Listings"];
  [query whereKey:@"objectId" equalTo:_listObjectId];
  PFObject *t = [query getFirstObject];
  //[t setObject:@NO forKey:@"isAccepted"];
  //[t saveInBackground];
  [t deleteInBackground];
  
  PFQuery *q2 = [PFQuery queryWithClassName:@"messages"];
  [q2 whereKey:@"UserID" equalTo:@"user"];
  [q2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      // The find succeeded.
     // NSLog(@"Successfully retrieved %d scores.", objects.count);
      // Do something with the found objects
      [PFObject deleteAllInBackground:objects];
    } else {
      // Log details of the failure
      NSLog(@"Error: %@ %@", error, [error userInfo]);
      [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Something Went Wrong!", nil) message:NSLocalizedString(@"Oops! Looks like something is wrong. Wait a few minutes and try again.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
  }];
  
  /* SEND NOTIFICATION */
} // user deletes listing

- (IBAction)acceptButtonTouchHandler:(id)sender{
  
  
  /* SEND NOTIFICATION */
} // user sells item

@end
