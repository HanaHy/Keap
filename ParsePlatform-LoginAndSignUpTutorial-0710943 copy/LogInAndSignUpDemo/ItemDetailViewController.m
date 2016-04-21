//
//  ItemDetailViewController.m
//  Keap
//
//  Created by Hana Hyder on 11/21/15.
//
//

#import "ItemDetailViewController.h"
#import "KeapAPIBot.h"
#import "KeapUser.h"
/*#import <Parse/Parse.h>*/
#import <QuartzCore/QuartzCore.h>


@interface ItemDetailViewController ()

@property (strong, nonatomic) KeapAPIBot *apiBot;
@property (nonatomic) dispatch_queue_t apiThread;

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
  
  
  //PFQuery *query = [PFQuery queryWithClassName:@"Listings"];
  //[query whereKey:@"objectId" equalTo:_itemObjectID];
  //PFObject *temp = (PFObject *)[query getFirstObject];
  _itemName.text = [self.itemInfo objectForKey:@"name"]; //temp[@"itemName"];
  _itemName.adjustsFontSizeToFitWidth = YES;
  //PFFile *fil = temp[@"image"];
  //_itemImage.image = [UIImage imageWithData:[fil getData]];
  _category.text = [self.itemInfo objectForKey:@"category"];
  _category.adjustsFontSizeToFitWidth = YES;
  _itemDescrip.text = [self.itemInfo objectForKey:@"description"];
  
 // _canBid = [temp[@"OBO"] boolValue];

  _canBid = true;
  
  if(_canBid)
  {
 // _bidNumber.text = [NSString stringWithFormat:@"%@ ACTIVE BIDS", temp[@"bids"]];
    _bidNumber.text = @"# OF ACTIVE BIDS";
  }
  else
  {
   _bidNumber.text = @"AVAILABLE";
  [_bidButton setImage:[UIImage imageNamed:@"buy_button.png"] forState:UIControlStateNormal];
  }
  
  /* DISABLE BID/BUY BUTTON IF IT IS THE USER'S */
  
  if([[self.itemInfo objectForKey:@"username"] isEqualToString:[[KeapUser currentUser] username]])
  {
    NSLog(@"***** TRUE");
    _bidButton.enabled = NO;
    _contactButton.enabled = NO;
  }
  
  
 /* NSString *dateString = [NSDateFormatter localizedStringFromDate:temp.createdAt
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterShortStyle];*/
  NSString *dateString = @"00:00:00 0/0/2016";
  _date.text = dateString;
  _date.adjustsFontSizeToFitWidth = YES;
  [_bidPrice setTitle:[NSString stringWithFormat:@"$%@",[self.itemInfo objectForKey:@"price"]] forState:UIControlStateNormal];
  _val = [[self.itemInfo objectForKey:@"username"] intValue];
  // [_bidPrice frame].size = CGSizeMake(50,50);
  CGRect buttonFrame = _bidPrice.frame;
  buttonFrame.size = CGSizeMake(50, 50);  // I CAN'T FIX THE SIZE :(
  _bidPrice.frame = buttonFrame;
  //NSString *owner = [self.itemInfo objectForKey:@"owner"];
 // _ownerID  = temp[@"ownerID"];
  //PFQuery *q = [PFUser query];
  //[q whereKey:@"objectId" equalTo:owner];
  //PFObject *userInf = (PFObject *)[q getFirstObject];
  NSDictionary *ownerInfo = [self.itemInfo objectForKey:@"owner"];
  _userName.text = [NSString stringWithFormat:@"%@ %@", [ownerInfo objectForKey:@"firstName"], [ownerInfo objectForKey:@"lastName"]];
  _userName.adjustsFontSizeToFitWidth = YES;
  NSDictionary *schoolInfo = [self.itemInfo objectForKey:@"school"];
  _userSchool.text = [schoolInfo objectForKey:@"name"];
  _userSchool.adjustsFontSizeToFitWidth = YES;
  

}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.apiBot = [KeapAPIBot botWithDelegate:self];
  self.apiThread = dispatch_queue_create("itemdetail.apibot", DISPATCH_QUEUE_SERIAL);
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
  
//  if(_canBid)
//  {
//  UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Place Bid" message:[NSString stringWithFormat:@"Current bid is at $%i", _val] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//  [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
//  
//  // Change keyboard type
//  [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
//  
//  dialog.tag = 100;
//  
//  [dialog show];
//    
//  }
//  else
//  {
//    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Confirm Purchase" message:[NSString stringWithFormat:@"Confirm that you would like to buy this item for $%i", _val] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    
//    dialog.tag = 200;
//    
//    [dialog show];
//  }
//  //[dialog release];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Place Bid" message:[NSString stringWithFormat:@"Current bid is at %@",[self.itemInfo objectForKey:@"price"]] preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Place Bid" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        NSNumberFormatter *f = [NSNumberFormatter new];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *price = [f numberFromString:[alertController textFields][0].text];
        [self.apiBot makeABidForListingID:self.itemInfo[@"id"] forPrice:price withCompletion:^(KeapAPISuccessType result, NSDictionary *response) {
            NSLog(@"%s Make a bid response %@",__FUNCTION__, response);
        }];
    }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter Bid Here";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
  
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

//-(BOOL)prefersStatusBarHidden{
//  return YES;
//}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

@end
