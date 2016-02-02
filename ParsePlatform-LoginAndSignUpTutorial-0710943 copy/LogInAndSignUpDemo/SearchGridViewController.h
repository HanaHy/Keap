//
//  SearchGridViewController.h
//  Keap
//
//  Created by Hana Hyder on 12/24/15.
//
//

#import <UIKit/UIKit.h>
//#import <Parse/Parse.h>
//#import <QuartzCore/QuartzCore.h>

@interface SearchGridViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
  UICollectionView *_collectionView;
}

@property (nonatomic, retain) UICollectionView  *_collectionView;

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

@property (nonatomic, retain) NSArray       *qArray;
@property (nonatomic, retain) NSString       *titleText;

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;


@end
