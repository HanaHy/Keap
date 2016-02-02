//
//  SearchGridViewController.m
//  Keap
//
//  Created by Hana Hyder on 12/24/15.
//
//

#import "SearchGridViewController.h"
#import "ItemCollectionViewCell.h"
#import "ItemDetailViewController.h"

#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

@interface SearchGridViewController ()

@end

@implementation SearchGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //self.view = [[UIview alloc] initWithFrame:<#(CGRect)#>]
  UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
  
  [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
  
  [layout setMinimumInteritemSpacing:5.0f];
  [layout setMinimumLineSpacing:10.0f];
  
  [layout setItemSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
  
  [layout setSectionInset:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
  
  CGRect nFrame1 = [[UIScreen mainScreen] applicationFrame];
  
  nFrame1.origin.y = 44.0f;
  nFrame1.size.height -= 44.0f;
  _collectionView=[[UICollectionView alloc] initWithFrame:nFrame1 collectionViewLayout:layout];
  [_collectionView setDataSource:self];
  [_collectionView setDelegate:self];
  
  //[_collectionView registerClass:[ItemCollectionViewCell class] forCellWithReuseIdentifier:@"itemGridCell"];
  
  
  [_collectionView registerNib:[UINib nibWithNibName:@"ItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"itemGridCell"];
  //[_collectionView registerNib:[UINib nibWithNibName:@"ItemCollectionViewCell" bundle:nil] forCellReuseIdentifier:@"itemGridCell"];
  [_collectionView setBackgroundColor:[UIColor whiteColor]];
  
  [self.view addSubview:_collectionView];
  
  UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
  
  [topBar setBackgroundColor:[UIColor colorWithRed:1.0 green:0.76 blue:0.0 alpha:1.0]];
  
  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  backButton.frame = CGRectMake(10.0f, 10.0f, 24.0f, 24.0f);
  
  [backButton setBackgroundImage:[UIImage imageNamed:@"white_back_button.png"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
  
  [topBar addSubview:backButton];
  
  UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, topBar.bounds.size.width, topBar.bounds.size.height)];
  textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
  textLabel.text = _titleText;
  textLabel.textAlignment = ALIGN_CENTER;

  [topBar addSubview:textLabel];
  [textLabel setCenter:topBar.center];
  
  [self.view addSubview:topBar];
  
  //PFObject *temp = ((PFObject *)(_qArray[1]));
 // NSInteger *siz = [_qArray count];
  //NSLog(@"This value is %@ **********, %tu", temp[@"itemName"], siz);
  
  if([_qArray count] == 0)
  {
    
    int imageHeight = [UIScreen mainScreen].bounds.size.width*[UIImage imageNamed:@"no_listings_image.png"].size.height/[UIImage imageNamed:@"no_listings_image.png"].size.width;
    UIImageView *sadness = [[UIImageView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - imageHeight)/2, [UIScreen mainScreen].bounds.size.width, imageHeight)];
    sadness.image = [UIImage imageNamed:@"no_listings_image.png"];
    
    [self.view addSubview:sadness];
  }
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  NSInteger fil = [_qArray count];
  if(fil == 0)
  {
    
    return 0;
  }
  
  return fil;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  //UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
  
  
  ItemCollectionViewCell *cell=[_collectionView dequeueReusableCellWithReuseIdentifier:@"itemGridCell" forIndexPath:indexPath];
  
  
  //NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
  
  if(!cell)
  {
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"itemGridCell"];
    cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"itemGridCell" forIndexPath:indexPath];
   // [collectionView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"newFriendCell"];
//    cell = [collectionView dequeueReusableCellWithIdentifier:@"newFriendCell"];
  }

  PFObject *temp = ((PFObject *)(_qArray[indexPath.row]));
  cell.objectId = @"hehe";
  cell.name.text = @"testing";
  cell.price.text = [NSString stringWithFormat:@"$%@", temp[@"price"]];
  //cell.minView.
  
  PFFile *fil = temp[@"image"];
  cell.img.image = [UIImage imageWithData:[fil getData]];
  //  self.headerImageView.layer.cornerRadius = 50.0f;
  //self.headerImageView.layer.masksToBounds = YES;
  cell.img.layer.cornerRadius = 10.0f;
  cell.img.layer.masksToBounds = YES;
  
  CGRect nFrame = cell.minView.frame;
  nFrame.origin.y = 5;
  [cell.minView setFrame:nFrame];
  
  cell.minView.backgroundColor  = [UIColor redColor];
  
  //cell.backgroundColor=[UIColor greenColor];
  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
  int size = [UIScreen mainScreen].bounds.size.width/2 - 15;
  return CGSizeMake(size, size);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  PFObject *temp = ((PFObject *)_qArray[indexPath.row]);
  
  //NSString itObId = temp.objectId;
  ItemDetailViewController *vc = [[ItemDetailViewController alloc] init];
  vc.itemObjectID   = temp.objectId;
  vc.allColor = [UIColor colorWithRed:1.0 green:0.757 blue:0.0 alpha:1.0];
  [self.navigationController pushViewController:vc animated:YES];
  
}

- (IBAction)backButtonTouchHandler:(id)sender {
  
  [self.navigationController popViewControllerAnimated:YES];
  // [self dismissViewControllerAnimated:YES completion:nil];
  
  //[self.parentViewController.navigationController popViewControllerAnimated:YES];
  
}

-(BOOL)prefersStatusBarHidden{
  return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
