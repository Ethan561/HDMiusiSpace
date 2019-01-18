//
//  SSL_PickerView.h
//  SSLImagePicker
//
//  Created by SSLong on 2018/11/24.
//  Copyright © 2018 孙世龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSL_PickerViewDelegate <NSObject>

- (void)beginDragingItem; //开始拖拽
- (void)endDragingItem;   //结束拖拽
- (void)getBackSelectedPhotos:(NSArray *)images;//返回选择的图片数组
- (void)didSelectedItemAt:(NSInteger)itemIndex; //返回点击的位置
@end

@interface SSL_PickerView : UIView
@property (nonatomic,weak) UIViewController *superVC;
@property (nonatomic,assign) id<SSL_PickerViewDelegate>delegate;
@property (nonatomic, readonly) UICollectionView *collectionView;
@end


