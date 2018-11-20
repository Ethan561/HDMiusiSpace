//
//  LxGridViewFlowLayout.h
//  LxGridView
//

#import <UIKit/UIKit.h>

/*
 此类来源于DeveloperLx的优秀开源项目：LxGridView
 github链接：https://github.com/DeveloperLx/LxGridView
 我对这个类的代码做了一些修改；
 感谢DeveloperLx的优秀代码~
 */

@interface LxGridViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,assign) BOOL panGestureRecognizerEnable;

@end

@protocol LxGridViewDataSource <UICollectionViewDataSource>

@optional

- (void)collectionView:(UICollectionView *)collectionView
       itemAtIndexPathA:(NSIndexPath *)sourceIndexPath
   willMoveToIndexPathB:(NSIndexPath *)destinationIndexPath;
- (void)collectionView:(UICollectionView *)collectionView
       itemAtIndexPathSo:(NSIndexPath *)sourceIndexPath
    didMoveToIndexPathDe:(NSIndexPath *)destinationIndexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView
       itemAtIndexPathS:(NSIndexPath *)sourceIndexPath
    canMoveToIndexPathD:(NSIndexPath *)destinationIndexPath;

@end

@protocol LxGridViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@optional

- (void)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;

@end
