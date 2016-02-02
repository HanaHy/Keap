//
//  ItemDetailViewController.m
//  Keap
//
//  Created by Hana Hyder on 11/21/15.
//
//

#import "ItemDetailViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>


@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  if(_allColor == nil)
  {
    _allColor = [UIColor colorWithRed:1.0 green:0.439 blue:0.596 alpha:1.0];
  } // set to default pink
  
  /* Setting all the colors */
  
  [_headerBG setBackgroundColor:_allColor];
  [_bidPrice setBackgroundColor:_allColor];
  _category.textColor = _allColor;
  _itemDescrip.textColor  = _allColor;
  _userSchool.textColor = _allColor;
  _bidNumber.textColor  = _allColor;
  _date.textColor = _allColor;
  _userName.textColor = _allColor;
  
  
  PFQuery *query = [PFQuery queryWithClassName:@"Listings"];
  [query whereKey:@"objectId" equalTo:_itemObjectID];
  PFObject *temp = (PFObject *)[query getFirstObject];
  _itemName.text = temp[@"itemName"];
  _itemName.adjustsFontSizeToFitWidth = YES;
  PFFile *fil = temp[@"image"];
  _itemImage.image = [UIImage imageWithData:[fil getData]];
  _category.text = temp[@"category"];
  _category.adjustsFontSizeToFitWidth = YES;
  _itemDescrip.text = temp[@"description"];
  
  _canBid = [temp[@"OBO"] boolValue];

  if(_canBid)
  {
  _bidNumber.text = [NSString stringWithFormat:@"%@ ACTIVE BIDS", temp[@"bids"]];
  }
  else
  {
   _bidNumber.text = @"AVAILABLE";
  [_bidButton setImage:[UIImage imageNamed:@"buy_button.png"] forState:UIControlStateNormal];
  }
  
  /* DISABLE BID/BUY BUTTON IF IT IS THE USER'S */
  
  if([temp[@"ownerID"] isEqualToString:[PFUser currentUser].objectId])
  {
    NSLog(@"***** TRUE");
    _bidButton.enabled = NO;
    _contactButton.enabled = NO;
  }
  
  
  NSString *dateString = [NSDateFormatter localizedStringFromDate:temp.createdAt
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterShortStyle];
  _date.text = dateString;
  _date.adjustsFontSizeToFitWidth = YES;
  [_bidPrice setTitle:[NSString stringWithFormat:@"$%@",temp[@"price"]] forState:UIControlStateNormal];
  _val = [temp[@"price"] intValue];
  // [_bidPrice frame].size = CGSizeMake(50,50);
  CGRect buttonFrame = _bidPrice.frame;
  buttonFrame.size = CGSizeMake(50, 50);  // I CAN'T FIX THE SIZE :(
  _bidPrice.frame = buttonFrame;
  NSString *owner = temp[@"ownerID"];
  _ownerID  = temp[@"ownerID"];
  PFQuery *q = [PFUser query];
  [q whereKey:@"objectId" equalTo:owner];
  PFObject *userInf = (PFObject *)[q getFirstObject];
  _userName.text = userInf[@"additional"];
  _userName.adjustsFontSizeToFitWidth = YES;
  _userSchool.text = userInf[@"school"];
  _userSchool.adjustsFontSizeToFitWidth = YES;
  

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BackButtonTouchHandler:(id)sender {
  
  [self.navigationController popViewControllerAnimated:YES];
 // [self dismissViewControllerAnimated:YES completion:nil];
  
  //[self.parentViewController.navigationController popViewControllerAnimated:YES];
  
}

- (IBAction)BidButtonTouchHandler:(id)sender {
  
  /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Some Title" message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
  
  UITextView *someTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, 250, 100)];
  someTextView.backgroundColor = [UIColor clearColor];
  someTextView.textColor = [UIColor whiteColor];
  someTextView.editable = YES;
  someTextView.font = [UIFont systemFontOfSize:15];
  someTextView.text = @"Enter Text Here";
  [alert addSubview:someTextView];
  [alert show];*/
  //[someTextView release];
  //[alert release];
  
  if(_canBid)
  {
  UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Place Bid" message:[NSString stringWithFormat:@"Current bid is at $%i", _val] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
  [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
  
  // Change keyboard type
  [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
  
  dialog.tag = 100;
  
  [dialog show];
    
  }
  else
  {
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Confirm Purchase" message:[NSString stringWithFormat:@"Confirm that you would like to buy this item for $%i", _val] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    dialog.tag = 200;
    
    [dialog show];
  }
  //[dialog release];
  
}

- (IBAction)contactButtonTouchHandler:(id)sender {
  
  if (![MFMessageComposeViewController canSendText]) {
    NSLog(@"Message services are not available.");
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Message Services Unavailable" message:@"Your device doesn't support this feature in this build!" delegate:self cancelButtonTitle:@"Ok, got it!" otherButtonTitles:nil, nil];
    
    [dialog show];
  }
  else {
    MFMessageComposeViewController* composeVC = [[MFMessageComposeViewController alloc] init];
    composeVC.messageComposeDelegate = self;
    
    // Configure the fields of the interface.
    composeVC.recipients = @[@"4084061789"];
    composeVC.body = @"Hi Hana. :-) Major key.";
    
    // Present the view controller modally.
    [self presentViewController:composeVC animated:YES completion:nil];
    
  }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
  // Check the result or perform other tasks.
  
  // Dismiss the mail compose view controller.
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if(alertView.tag == 100)
  {
    
    if(buttonIndex == 1)
    {
      int b = [[alertView textFieldAtIndex:0].text intValue];
      
      if(b < _val)
      {
         UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Low Bid" message:[NSString stringWithFormat:@"To place a valid bid, bid at $%i or more. Remember, the higher the bid, the better chance it will get accepted.", _val] delegate:self cancelButtonTitle:@"Ok, got it!" otherButtonTitles:nil, nil];
        
        [dialog show];
      }
      else
      {
        
        PFObject *bidding = [PFObject objectWithClassName:@"Bids"];
        [bidding setObject:[PFUser currentUser].objectId forKey:@"requester"];
        [bidding setObject:[PFUser currentUser][@"additional"] forKey:@"bidderName"];
        [bidding setObject:[NSNumber numberWithInt:b] forKey:@"bidPrice"];
        [bidding setObject:_itemObjectID forKey:@"listingID"];
        [bidding setObject:_ownerID forKey:@"ownerID"];
        
        [bidding save];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Listings"];
        [query whereKey:@"objectId" equalTo:_itemObjectID];
        PFObject *temp = (PFObject *)[query getFirstObject];
        
        [temp setObject:[NSNumber numberWithInt:([temp[@"bids"] intValue] + 1)] forKey:@"bids"];
        
        [temp save];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bid Sent" message:@"Your bid has now been sent! You will be notified if your bid was accepted." delegate:nil cancelButtonTitle:@"Ok, got it!" otherButtonTitles:nil, nil];
        
        [alert show];
        
      }
      
    } //User submit bid
    
    if(alertView.tag == 200)
    {
      if(buttonIndex == 1)
      {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offer Sent" message:@"Your offer to purchase has now been sent! You will be notified by the owner." delegate:nil cancelButtonTitle:@"Ok, got it!" otherButtonTitles:nil, nil];
        
        [alert show];
        
      } /* SEND MESSAGE TO OWNER */
    }
    
  } //Alert that popped was the user bid.
}

-(BOOL)prefersStatusBarHidden{
  return YES;
}


@end
