//
//  SearchViewController.h
//  Keap
//
//  Created by Hana Hyder on 11/30/15.
//
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
  
  UITableView *categoryListings;
  NSMutableArray *categories;
}

@property (nonatomic, retain) UITableView *categoryListings;
@property (nonatomic, retain) NSMutableArray       *categories;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end
