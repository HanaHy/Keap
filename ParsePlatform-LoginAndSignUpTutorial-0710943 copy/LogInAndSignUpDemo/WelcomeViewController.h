//
//  WelcomeViewController.h
//  SkaderApp
//
//  Created by Hana Hyder on 8/27/15.
//  Copyright (c) 2015 Hana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {
  
  UIPickerView *pickerView;
  NSMutableArray *dataArray;
  UILabel *helloText;
  UILabel *extText;
  UIImageView *headerImageView;
  UIButton    *confirmButton;
  CGPoint originalCenter;
}

@property (nonatomic, retain) UIPickerView         *pickerView;
@property (nonatomic, retain) NSMutableArray       *dataArray;
@property (nonatomic, strong) IBOutlet UILabel     *helloText;
@property (nonatomic, strong) IBOutlet UILabel     *extText;
@property (nonatomic, strong) IBOutlet UIImageView *headerImageView;
@property (nonatomic, strong) IBOutlet UIButton    *confirmButton;
@property (nonatomic, strong) IBOutlet UITextField  *emailName;

- (IBAction)confirmButtonTouchHandler:(id)sender;

@end
