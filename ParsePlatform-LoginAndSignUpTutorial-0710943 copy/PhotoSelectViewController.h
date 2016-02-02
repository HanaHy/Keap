//
//  PhotoSelectViewController.h
//  Keap
//
//  Created by Hana Hyder on 11/30/15.
//
//

#import <UIKit/UIKit.h>

@interface PhotoSelectViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet  UIImageView *imageView;

- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;

@end
