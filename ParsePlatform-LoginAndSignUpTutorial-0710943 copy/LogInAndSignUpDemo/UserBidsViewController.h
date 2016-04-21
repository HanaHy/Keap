//
//  UserBidsViewController.h
//  Keap
//
//  Created by Hana Hyder on 12/31/15.
//
//

#import <UIKit/UIKit.h>

@interface UserBidsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
  
  //UITableView *userListings;
  //NSArray *qArray;
  //NSInteger     numOfBids;


@property (nonatomic, weak) IBOutlet UITableView *userListings;
@property (nonatomic, strong) NSArray       *qArray;
@property (nonatomic)         NSInteger       numOfBids;
@property (nonatomic, strong) IBOutlet UINavigationBar  *bar;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (IBAction)backButtonTouchHandler:(id)sender;

@end
