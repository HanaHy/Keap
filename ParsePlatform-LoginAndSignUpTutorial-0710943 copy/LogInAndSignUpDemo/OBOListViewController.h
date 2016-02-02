//
//  OBOListViewController.h
//  Keap
//
//  Created by Hana Hyder on 11/30/15.
//
//

#import <UIKit/UIKit.h>

@interface OBOListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {
  
  
  UITableView *userList;
  UIPickerView *pickerView;
  NSMutableArray *categories;
  NSString      *category;
  int      mess;
  UITextField   *activeField;
}

@property (nonatomic, retain) IBOutlet UITableView *userList;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic)         NSString*     category;
@property (nonatomic)         int  mess;
@property (nonatomic, retain)         UITextField *activeField;
@property (nonatomic)         CGRect  oldSize;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(void) textFieldDidEndEditing: (UITextField * ) textField;


@end
