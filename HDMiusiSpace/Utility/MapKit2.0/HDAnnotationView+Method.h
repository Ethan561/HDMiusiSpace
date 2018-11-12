//
//  HDAnnotationView+Method.h
//  HDGansuKJG
//
//  Created by liuyi on 2018/11/2.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

#import "HDAnnotationView.h"

#define Placeholder_PIN              @"dl_icon_map_white" //默认点位图片
#define Placeholder_PIN_Playing      @"dl_icon_map_dw" //定位
#define Placeholder_PIN_G            @"dl_icon_map_white" //已读
#define Successive_PIN               @"my_location" //连续定位图标

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






