//
//  UserListingsViewController.h
//  Keap
//
//  Created by Hana Hyder on 11/22/15.
//
//

#import <UIKit/UIKit.h>

@interface UserListingsViewController: UIViewController <UITableViewDataSource, UITableViewDelegate> {
  
  UITableView *userListings;
  NSArray *qArray;
  NSMutableArray *heightArray;
  NSMutableArray *itemArray;
  NSInteger itemBidNumber;
  NSInteger itemTemp;
  int counter;
}

@property (nonatomic, retain) UITableView *userListings;
@property (nonatomic, retain) NSArray       *qArray;
@property (nonatomic, retain) NSMutableArray       *heightArray;
@property (nonatomic, retain) NSMutableArray       *itemArray;
@property (nonatomic)         NSInteger     itemBidNumber;
@property (nonatomic)         NSInteger     itemTemp;
@property (nonatomic)         int      counter;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (IBAction)backButtonTouchHandler:(id)sender;

@end