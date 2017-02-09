//
//  MessagesViewController.h
//  Keap
//
//  Created by Hana Hyder on 12/26/15.
//
//

#import <UIKit/UIKit.h>
//#import <SendBirdSDK/SendBirdSDK.h>

@interface MessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
  
  UITableView *userMessages;
  NSArray *qArray;
  
}

@property (nonatomic, retain) UITableView *userMessages;
@property (nonatomic, retain) NSArray       *qArray;

@end
