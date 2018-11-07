//
//  HDAnnotationView+Method.m
//  HDGansuKJG
//
//  Created by liuyi on 2018/11/2.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

#import "HDAnnotationView+Method.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "HDMapView.h"
#import "HDAnnotation.h"
#import "HD_NKM_Big_Ann_View.h"

@implementation HDAnnotationView (Method)

//自定义视图布局
- (void)setupAnnView:(HDAnnotation *)annotation {
    if (annotation.annType == kAnnotationType_One) {
        UIImage *myImage = [UIImage imageNamed:Placeholder_PIN];
        [self setImage:myImage forState:UIControlStateNormal];

//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 16)];
//        bgView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height+10);
//        bgView.backgroundColor = [UIColor blackColor];
//        bgView.alpha = 0.5;
//        bgView.layer.cornerRadius = 8;
//        bgView.layer.masksToBounds = YES;
//        [self addSubview:bgView];
//
//        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 16)];
//        nameL.center = bgView.center;
//        nameL.font = [UIFont systemFontOfSize:12];
//        nameL.textColor = [UIColor whiteColor];
//        nameL.text = annotation.title;
//        nameL.backgroundColor = [UIColor clearColor];
//        [self addSubview:nameL];
        
    }
    
    if (annotation.annType == kAnnotationType_More) {
        [self setImage:[UIImage imageNamed:@"A_map_cluster"] forState:UIControlStateNormal];
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        numL.textAlignment = NSTextAlignmentCenter;
        numL.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        numL.font = [UIFont systemFontOfSize:14];
        numL.textColor = [UIColor whiteColor];
        numL.text = annotation.pointCount;
        numL.backgroundColor = [UIColor clearColor];
        [self addSubview:numL];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 16)];
        bgView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height+10);
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        bgView.layer.cornerRadius = 8;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 16)];
        nameL.center = bgView.center;
        nameL.font = [UIFont systemFontOfSize:12];
        nameL.textColor = [UIColor whiteColor];
        nameL.text = annotation.title;
        nameL.backgroundColor = [UIColor clearColor];
        [self addSubview:nameL];
        
    }
    
    if (annotation.annType == kAnnotationType_ServiceInfo) {
        UIImage *myImage = [UIImage imageNamed:@"服务设施-卫生间"];

        [self sd_setImageWithURL:[NSURL URLWithString:annotation.poiImgPath] forState:UIControlStateNormal placeholderImage:myImage];
        self.userInteractionEnabled = NO;
    }
    
    //连续定位
    if (annotation.annType == kAnnotationType_Successive) {
        [self setImage:[UIImage imageNamed:@"map_loc_icon"] forState:UIControlStateNormal];
        self.userInteractionEnabled = NO;
    }

}

#pragma mark -------- 大图点位或弹窗视图 --------

- (void)bigPicture
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.bigAnn = [[[NSBundle mainBundle] loadNibNamed:@"HD_NKM_Big_Ann_View" owner:self options:nil] lastObject];
        NSURL *poiImgURL = [NSURL URLWithString:self.annotation.poiImgPath];
        [self.bigAnn.imgView sd_setImageWithURL:poiImgURL];
        if (self.annotation.annType == kAnnotationType_Loc) {
            self.bigAnn.imgView.image = [UIImage imageNamed:@"placeholder_ann"];
        }
        
//        HDLY_AudioPlayer *player = [HDLY_AudioPlayer shared];
//        if (player.state == STKAudioPlayerStatePlaying && player.fileno == self.annotation.identify) {
//            self.bigAnn.playBtn.selected = YES;
//        }
        self.bigAnn.titleLabel.text = self.annotation.title;
        self.bigAnn.subTitleLabel.text = self.annotation.title;
        self.bigAnn.myAnn = self.annotation;
        self.bigAnn.myAnnView = self;
        self.userInteractionEnabled = NO;
        [self frameForBigAnn];
        [self addSubview:self.bigAnn];
        
        self.isBig = YES;
        
        //开启跳动动画
        //[self popJumpAnimationView:bigAnn];
    });
}

// 放大后的UIView超出了当前的范围
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil && self.bigAnn != nil) {
        CGPoint tempoint = [self.bigAnn.playBtn convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.bigAnn.playBtn.bounds, tempoint)) {
            return view = self.bigAnn.playBtn;
        }
        CGPoint tempoint1 = [self.bigAnn.detailBtn convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.bigAnn.detailBtn.bounds, tempoint1)) {
            return view = self.bigAnn.detailBtn;
        }
        CGPoint tempoint2 = [self.bigAnn convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.bigAnn.bounds, tempoint2)) {
            return view = self.bigAnn;
        }
    }
    return view;
}

- (void)frameForBigAnn
{
    CGSize frameSize = self.bigAnn.frame.size;
    CGSize size = self.frame.size;
    
    self.bigAnn.frame = CGRectMake((size.width - frameSize.width)/2, (-frameSize.height-8), frameSize.width, frameSize.height);
    
}

- (void)smallPicture
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *myImage = [UIImage imageNamed:Placeholder_PIN];
        
        NSString *imgStr = self.annotation.poiImgPath;
        //连续定位过滤
        if (self.annotation.annType == kAnnotationType_Successive) {
            return;
        }
        //过滤合并点位
        if (self.annotation.annType == kAnnotationType_More) {
            return;
        }
        
        NSURL *poiImgURL = [NSURL URLWithString:imgStr];
        [self sd_setImageWithURL:poiImgURL forState:UIControlStateNormal placeholderImage:myImage];
        [self.bigAnn removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self.bigAnn];
        self.bigAnn = nil;
        self.isBig = NO;
        self.userInteractionEnabled = YES;
    });
}

#pragma mark -------- 动画 --------
- (void)popJumpAnimationView:(UIButton *)sender {
    CGFloat duration = 1.f;
    CGFloat height = 20.f;
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat currentTy = sender.transform.ty;
    animation.duration = duration;
    
    animation.values = @[@(currentTy), @(currentTy - height/4), @(currentTy-height/4*2), @(currentTy-height/4*3), @(currentTy - height), @(currentTy-height/4*3), @(currentTy -height/4*2), @(currentTy - height/4), @(currentTy)];
    
    animation.keyTimes = @[ @(0), @(0.025), @(0.085), @(0.2), @(0.5), @(0.8), @(0.915), @(0.975), @(1) ];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    animation.repeatCount = HUGE_VALF;
    //界面跳转返回后仍执行跳动动画
    animation.removedOnCompletion = NO;
    
    [sender.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
    self.isAnimating = YES;
}

- (void)shakeToShow:(UIView*)aView{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.duration = 2.0;// 动画时间
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
    // 这三个数字，我只研究了前两个，所以最后一个数字我还是按照它原来写1.0；前两个是控制view的大小的；
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
    
}

- (void)stopAnimate
{
    [self.layer removeAnimationForKey:@"kViewShakerAnimationKey"];
    [self.layer removeAnimationForKey:@"transform"];
    
    self.isAnimating = NO;
}

#pragma mark -------- 图片更新 --------

// 或者是收号以后，更新，图片传入的是路径
- (void)changePOIImageWithPath:(NSString *)imgPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *myImage = [UIImage imageNamed:Placeholder_PIN];
        NSString *imgStr = imgPath;
        NSURL *poiImgURL = [NSURL URLWithString:imgStr];
        self.annotation.poiImgPath = imgPath;
        [self sd_setImageWithURL:poiImgURL forState:UIControlStateNormal placeholderImage:myImage];
        [self.bigAnn removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self.bigAnn];
        self.bigAnn = nil;
        self.isBig = NO;
    });
}

- (void)changeBigPOIImageWithPath:(NSString *)imgPath andTitle:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *myImage = [UIImage imageNamed:Placeholder_PIN];
        NSString *imgStr = imgPath;
        NSURL *poiImgURL = [NSURL URLWithString:imgStr];
        [self.bigAnn.imgView sd_setImageWithURL:poiImgURL placeholderImage:myImage];
        self.bigAnn.nameLabel.text = title;
    });
}

@end
