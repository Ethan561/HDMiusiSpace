//
//  SSL_PickerView.h
//  SSLImagePicker
//
//  Created by SSLong on 2018/11/24.
//  Copyright © 2018 孙世龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSL_PickerViewDelegate <NSObject>

- (void)getBackSelectedPhotos:(NSArray *)images;

@end

@interface SSL_PickerView : UIView
@property (nonatomic,weak) UIViewController *superVC;
@property (nonatomic,assign) id<SSL_PickerViewDelegate>delegate;
@end


