//
//  HDAnnotationView+Method.h
//  HDGansuKJG
//
//  Created by liuyi on 2018/11/2.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

#import "HDAnnotationView.h"

@interface HDAnnotationView (Method)

//自定义视图布局
- (void)setupAnnView:(HDAnnotation *)annotation;
//
- (void)bigPicture;   // POI变大动画
- (void)smallPicture; // POI变小

- (void)changeBigPOIImageWithPath:(NSString *)imgPath andTitle:(NSString *)title;
- (void)changePOIImageWithPath:(NSString *)imgPath;

- (void)stopAnimate;
- (void)popJumpAnimationView:(UIView *)sender;

@end






