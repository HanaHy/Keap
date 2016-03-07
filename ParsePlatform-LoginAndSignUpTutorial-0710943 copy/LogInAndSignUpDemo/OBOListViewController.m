//
//  OBOListViewController.m
//  Keap
//
//  Created by Hana Hyder on 11/30/15.
//
//

#import "OBOListViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "ImagePickTableViewCell.h"
#import "DescripTableViewCell.h"
#import "CategPickTableViewCell.h"
#import "PricePickTableViewCell.h"
#import "KeapAPIBot.h"

#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

#define kOFFSET_FOR_KEYBOARD 215.0

/*#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)*/

@interface OBOListViewController ()

@property (strong, nonatomic) KeapAPIBot *apiBot;
@property (strong, nonatomic) dispatch_queue_t apiThread;

@end

@implementation OBOListViewController

@synthesize userList;
@synthesize pickerView;
@synthesize categories;
@synthesize category;
@synthesize mess;
@synthesize oldSize;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  /*UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [dismissButton setImage:[UIImage imageNamed:@"Exit.png"] forState:UIControlStateNormal];
  [dismissButton setImage:[UIImage imageNamed:@"ExitDown.png"] forState:UIControlStateHighlighted];
  [dismissButton addTarget:self action:@selector(handleExit) forControlEvents:UIControlEventTouchUpInside];
  float fip = [UIScreen mainScreen].bounds.size.width - 87.5f;
  [dismissButton setFrame:CGRectMake(fip, 10.0f, 87.5f, 45.5f)];
  [self.view addSubview:dismissButton];*/
  
  /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];*/
  oldSize = self.view.frame;
    
    self.apiThread = dispatch_queue_create("obo.api", DISPATCH_QUEUE_SERIAL);
    self.apiBot = [KeapAPIBot botWithDelegate:self];
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    dispatch_async(self.apiThread, ^{
        [self.apiBot fetchCategoriesWithCompletion:^(KeapAPISuccessType result, NSDictionary *response) {
            if (result == success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.categories = [response objectForKey:@"categories"];
                    [self.userList reloadData];
                });
            }
            NSLog(@"%s %@",__FUNCTION__, response);
        }];
    });
}

#pragma mark - Table view data source

#pragma mark - TableView Implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //Only 3 cells
  
  return 5;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  /*
   1. Select Image Cell (ImageSelectTableViewCell)
   2. Add Description/Title Cell (DescriptionTableViewCell)
   3. CategoryTableViewCell
   
   */
  
  if(indexPath.row == 0)
  {
    ImagePickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageSelect"];
    
    if(!cell)
    {
      [tableView registerNib:[UINib nibWithNibName:@"ImagePickTableViewCell" bundle:nil] forCellReuseIdentifier:@"imageSelect"];
      cell = [tableView dequeueReusableCellWithIdentifier:@"imageSelect"];
    }
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setImage:[UIImage imageNamed:@"Exit.png"] forState:UIControlStateNormal];
    [dismissButton setImage:[UIImage imageNamed:@"ExitDown.png"] forState:UIControlStateHighlighted];
    [dismissButton addTarget:self action:@selector(handleExit) forControlEvents:UIControlEventTouchUpInside];
    float fip = [UIScreen mainScreen].bounds.size.width - 87.5f;
    [dismissButton setFrame:CGRectMake(fip, 10.0f, 87.5f, 45.5f)];
    //[dismissButton setFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [cell addSubview:dismissButton];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
  }
  else if(indexPath.row == 1)
  {
    DescripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descripCell"];
    if(!cell)
    {
      [tableView registerNib:[UINib nibWithNibName:@"DescripTableViewCell" bundle:nil] forCellReuseIdentifier:@"descripCell"];
      cell = [tableView dequeueReusableCellWithIdentifier:@"descripCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.itemName.delegate = self;
    cell.itemName.tag = 1;
    
    cell.itemDescrip.delegate = self;
    cell.itemDescrip.tag = 2;
    
    //[cell.itemDescrip endEditing: YES];
    
    return cell;
    
  }
  else if(indexPath.row == 2)
  {
    CategPickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
    
    if(!cell)
    {
      [tableView registerNib:[UINib nibWithNibName:@"CategPickTableViewCell" bundle:nil] forCellReuseIdentifier:@"categoryCell"];
      cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
      
    }
    
    pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(((self.view.frame.size.width) - 320)/2, 25, 320, 200)];
    [pickerView setDelegate:self];
    
    [cell addSubview:pickerView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
  }
  else if(indexPath.row == 3)
  {
    PricePickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell"];
    
    if(!cell)
    {
      [tableView registerNib:[UINib nibWithNibName:@"PricePickTableViewCell" bundle:nil] forCellReuseIdentifier:@"priceCell"];
      cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell"];
      
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.itemPrice.delegate = self;
    cell.itemPrice.tag = 3;
    
    return cell;
    
  }
  else
  {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.backgroundColor = [UIColor colorWithRed:0 green:0.7411 blue:1 alpha:1];
    if(mess == 1)
    {
      cell.textLabel.text = @"Sell This!";
    }
    else if(mess == 2)
    {
      cell.textLabel.text = @"Auction This!";
    }
    cell.textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    cell.textLabel.textAlignment = ALIGN_CENTER;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  }
  // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
  
  
  
  return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.row == 0)
  {
    return 175;
  }
  else if(indexPath.row == 1)
  {
    return 166;
  }
  else if(indexPath.row == 2)
  {
    return 245;
  }
  else if(indexPath.row == 3)
  {
    return 144;
  }
  else
  {
    return 50;
  }
  
  
  return 0;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return self.categories.count;
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [self.categories objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
  //Write the required logic here that should happen after you select a row in Picker View.
  /*PFQuery *query = [PFQuery queryWithClassName:@"schoolext"];
   [query whereKey:@"School" equalTo:[dataArray objectAtIndex:row]];
   PFObject *result = [query getFirstObject];
   extText.text = [NSString stringWithFormat:@"@%@",result[@"Extention"]];
   [[PFUser currentUser] setObject:[dataArray objectAtIndex:row] forKey:@"school"];
   [[PFUser currentUser] saveInBackground]; //-- In future may comment this line out ?*/
  
  self.category = [self.categories objectAtIndex:row];
  
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.row == 0)
  {
    
    
  } //User selected image picker.
  if(indexPath.row == 4)
  {
    NSLog(@"REACHED HERE ***");
    bool pass = true;
      
      DescripTableViewCell *cell = (id)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
      
      NSString *t2 = [[cell itemName] text];
      
      if([t2 length] == 0)
      {
          pass = false;
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Item Name Missing" message:@"Your listing is missing the name!" delegate:nil cancelButtonTitle:@"Oops!" otherButtonTitles:nil, nil];
          
          [alert show];
          
          return;
          
      }
      
      /* SAVING PRICE */
      
      PricePickTableViewCell *theCell = (id)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
      //UITextField *cellTextField = [theCell itemPrice];
      
      NSString *temp = [[theCell itemPrice] text];
      if([temp length] == 0)
      {
          pass = false;
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Item Price Missing" message:@"Your listing is missing the price!" delegate:nil cancelButtonTitle:@"Oops!" otherButtonTitles:nil, nil];
          
          [alert show];
          
          return;
          
      }
      NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
      f.numberStyle = NSNumberFormatterDecimalStyle;
      NSNumber *myNumber = [f numberFromString:temp];
      
      
      [self.apiBot createListing:t2 category:self.category price:myNumber description:[[cell itemDescrip] text] image:[UIImage imageNamed:@"ImageFrame.png"] withCompletion:^(KeapAPISuccessType result, NSDictionary *response) {
          NSLog(@"%s response is %@",__FUNCTION__,response);
      }];
    
    if(mess == 2) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Listing Posted" message:@"Your item has now been posted! You will be notified of any bids or messages." delegate:nil cancelButtonTitle:@"Ok, got it!" otherButtonTitles:nil, nil];
    
    [alert show];
      
    }
    else if(mess == 1)
    {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Listing Posted" message:@"Your item has now been posted! You will be notified when there is an offer to buy." delegate:nil cancelButtonTitle:@"Ok, got it!" otherButtonTitles:nil, nil];
      
      [alert show];
      
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
  } //User pressed to submit listing.
}

/*-(void)dismissKeyboard {
  [activeField resignFirstResponder];
}*/


/*- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  activeField = textField;
}
*/
-(void) textFieldDidEndEditing: (UITextField * ) textField {
  // Decide which text field based on it's tag and save data to the model.
  activeField = nil;
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if(activeField)
  [activeField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField.tag == 1) {
    [textField resignFirstResponder];
    [(UITextField *)[self.view viewWithTag:2] becomeFirstResponder];
    //[_itemDescrip becomeFirstResponder];
  } else if (textField.tag == 2 || textField.tag == 3) {
    [textField resignFirstResponder];
    // here you can define what happens
    //[_itemDescrip endEditing:YES];
    //    [self.view endEditing:YES];
    //userList.alpha = 0.5;
    
  }
  return YES;
}

- (void)registerForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
  
}

-(void)keyboardWillShow {
  // Animate the current view out of the way
  if (self.view.frame.origin.y < 0)
  {
    [self setViewMovedUp:YES];
  }
  /*else if (self.view.frame.origin.y >= 0)
  {
    [self setViewMovedUp:NO];
  }*/
}

-(void)keyboardWillHide {
  if (self.view.frame.origin.y < 0)
  {
    [self setViewMovedUp:NO];
  }
 /* else if (self.view.frame.origin.y >= 0)
  {
    [self setViewMovedUp:NO];
  }*/
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
  activeField = sender;
  if (sender.tag == 3)
  {
    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0)
    {
      NSLog(@"***HANA");
      [self setViewMovedUp:YES];
    }
  }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3]; // if you want to slide up the view
  
  CGRect rect = self.view.frame;
  if (movedUp)
  {
    // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
    // 2. increase the size of the view so that the area behind the keyboard is covered up.
    rect.origin.y -= kOFFSET_FOR_KEYBOARD;
    rect.size.height += kOFFSET_FOR_KEYBOARD;
  }
  else
  {
    // revert back to the normal state.
    //rect.origin.y += kOFFSET_FOR_KEYBOARD;
    //rect.size.height -= kOFFSET_FOR_KEYBOARD;
    rect.origin.y = oldSize.origin.y;
    rect.size.height = oldSize.size.height - 30;
  }
  self.view.frame = rect;
  
  [UIView commitAnimations];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  // unregister for keyboard notifications while not visible.
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
}




/*- (void) textFieldDidBeginEditing:(UITextField *)textField {
 
  NSLog(@"****MADE IT HERE, HANA");
 *UITableViewCell *cell;
  
  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
    // Load resources for iOS 6.1 or earlier
    cell = (UITableViewCell *) textField.superview.superview;
    
  } else {
    // Load resources for iOS 7 or later
    cell = (UITableViewCell *) textField.superview.superview.superview;
    // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Cell!
  }
  [userList scrollToRowAtIndexPath:[userList indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  
  CGPoint scrollPt = CGPointMake(textField.bounds.origin.x, textField.bounds.origin.y);
  [userList setContentOffset:scrollPt animated:YES];
  
  UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
  [userList scrollToRowAtIndexPath:[userList indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}*/

/*-(void)textFieldDidBeginEditing:(UITextField *)textField {
  if(textField.tag == 3)
  {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(addButtonToKeyboard:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  }
}
*/


/*- (void)keyboardWillShow:(NSNotification *)note {
  // create custom button
  UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
  doneButton.frame = CGRectMake(0, 163, 106, 53);
  doneButton.adjustsImageWhenHighlighted = NO;
  [doneButton setImage:[UIImage imageNamed:@"doneButtonNormal.png"] forState:UIControlStateNormal];
  [doneButton setImage:[UIImage imageNamed:@"doneButtonPressed.png"] forState:UIControlStateHighlighted];
  [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
  
  if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
    dispatch_async(dispatch_get_main_queue(), ^{
      UIView *keyboardView = [[[[[UIApplication sharedApplication] windows] lastObject] subviews] firstObject];
      [doneButton setFrame:CGRectMake(0, keyboardView.frame.size.height - 53, 106, 53)];
      [keyboardView addSubview:doneButton];
      [keyboardView bringSubviewToFront:doneButton];
      
      [UIView animateWithDuration:[[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]-.02
                            delay:.0
                          options:[[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                       animations:^{
                         self.view.frame = CGRectOffset(self.view.frame, 0, 0);
                       } completion:nil];
    });
  }else {
    // locate keyboard view
    dispatch_async(dispatch_get_main_queue(), ^{
      UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
      UIView* keyboard;
      for(int i=0; i<[tempWindow.subviews count]; i++) {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        // keyboard view found; add the custom button to it
        if([[keyboard description] hasPrefix:@"UIKeyboard"] == YES)
          [keyboard addSubview:doneButton];
      }
    });
  }
}*/


-(BOOL)prefersStatusBarHidden{
  return YES;
}

- (void) handleExit {
  
  [self.navigationController popViewControllerAnimated:YES];
}

@end
