//
//  UserBidsViewController.h
//  Keap
//
//  Created by Hana Hyder on 12/31/15.
//
//

#import <UIKit/UIKit.h>

@interface UserBidsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
  
  UITableView *userListings;
  NSMutableArray *qArray;
  NSInteger     numOfBids;

}

@property (nonatomic, retain) UITableView *userListings;
@property (nonatomic, retain) NSMutableArray       *qArray;
@property (nonatomic)         NSInteger       numOfBids;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (IBAction)backButtonTouchHandler:(id)sender;

@end
