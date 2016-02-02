//
//  ListFeedViewController.h
//  Keap
//
//  Created by Hana Hyder on 9/1/15.
//  Copyright (c) 2015 Hana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
  
  UITableView *newsListings;
  NSArray *qArray;
  NSString *itObId;
}

@property (nonatomic, retain) UITableView *newsListings;
@property (nonatomic, retain) NSArray       *qArray;
@property (nonatomic)         NSString*     itObId;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end
