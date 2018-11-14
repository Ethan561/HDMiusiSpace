//
//  HD_SSL_BigImageVC.h
//  HDHuNanMuseum
//
//  Created by SSLong on 2017/9/21.
//  Copyright © 2017年 liuyi. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface HD_SSL_BigImageVC : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *imageArray;//图片数组
@property (nonatomic)        NSInteger      atIndex;//选中位置

@end
