//
//  HDMapView+AnnView.m
//  HDGansuKJG
//
//  Created by liuyi on 2018/10/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

#import "HDMapView+AnnView.h"
#import "HDAnnotationView.h"
#import "HDAnnotation.h"
#import "HDAnnotationView+Method.h"

@implementation HDMapView (AnnView)

#pragma mark ----- 点位添加、移除 -----

- (void)addAnnotation:(HDAnnotation *)annotation animated:(BOOL)animate {
    HDAnnotationView *pinAnnotation = [[HDAnnotationView alloc] initWithAnnotation:annotation
                                                                            onView:self
                                                                          animated:animate];
    
    if (!self.pinAnnotations) {
        self.pinAnnotations = [[NSMutableArray alloc] init];
    }
    [self.pinAnnotations addObject:pinAnnotation];
    [self addObserver:pinAnnotation
           forKeyPath:@"contentSize"
              options:NSKeyValueObservingOptionNew
              context:nil];
}

- (void)addAnnotations:(NSArray *)annotations animated:(BOOL)animate
{
    for (HDAnnotation *annotation in annotations) {
        [self addAnnotation:annotation animated:animate];
    }
}

- (void)removeAnnatation:(HDAnnotationView *)annView animated:(BOOL)animate
{
    //保留连续定位点
    if (annView.annotation.annType == kAnnotationType_Successive) {
        return;
    }
    [annView.layer removeAllAnimations];
    [annView removeFromSuperview];
    [self removeObserver:annView forKeyPath:@"contentSize"];
}

- (void)removeAllAnnatations:(BOOL)animate
{
    for (HDAnnotationView *annView in self.pinAnnotations) {
        [self removeAnnatation:annView animated:animate];
    }
    
    [self.pinAnnotations removeAllObjects];
    [self setZoomScale:1 animated:YES];
}

#pragma mark ----- 跳动动画操作 -----
- (void)jumpAnimationAnnotationView:(NSString *)identifier {
    for (HDAnnotationView *pin in self.pinAnnotations) {
        if (pin.annotation.beaconNum == identifier.integerValue) {
            [pin popJumpAnimationView:pin];
        }else {
            if (pin.isAnimating) {
                [pin stopAnimate];
            }
        }
    }
}

- (void)stopPinAnimate
{
    for (HDAnnotationView *pin in self.pinAnnotations) {
        pin.isAnimating = NO;
        [pin stopAnimate];
    }
}

#pragma mark ----- 放大、缩小 -----
// 通过identifier放大图片
- (void)bigAnnotationView:(NSString *)identifier
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (HDAnnotationView *pin in self.pinAnnotations) {
            if ([pin.annotation.identify isEqualToString:identifier]) {
                CGPoint pointToMove = CGPointMake(pin.annotation.point.x/self.minimumZoomScale, pin.annotation.point.y/self.minimumZoomScale);
                [self setContentCenter:pointToMove animated:YES];
                if (pin.isBig == NO){
                    [self.annBgView bringSubviewToFront:pin]; // 放大的点位于最上方
                    [pin bigPicture];
                }
            }else if (pin.annotation.annType == kAnnotationType_Successive){
                continue;
            }
            else {
                [pin smallPicture];
            }
        }
    });
}

// 通过蓝牙号放大图片
- (void)bigAnnByBeaconNum:(NSNumber *)beaconMinor
{
    for (HDAnnotationView *pin in self.pinAnnotations) {
        if (pin.annotation.beaconNum == beaconMinor.integerValue) {
            CGPoint pointToMove = CGPointMake(pin.annotation.point.x/self.minimumZoomScale, pin.annotation.point.y/self.minimumZoomScale);
            [self setContentCenter:pointToMove animated:YES];
            
            if (pin.isBig == NO){
                [self.annBgView bringSubviewToFront:pin];
                [pin bigPicture];
            }
            
        }else if ([pin.annotation.identify isEqualToString:@"kSuccessive_Ann_ID"]){
            continue;
        }
        else {
            [pin smallPicture];
        }
    }
}

- (void)smallAllAnnView {
    for (HDAnnotationView *annView in self.pinAnnotations) {
        [annView smallPicture];
    }
}


#pragma mark ----- 点位图片更换、移动 -----

- (void)moveToCenter:(NSString *)identifier
{
    for (HDAnnotationView *pin in self.pinAnnotations) {
        if ([pin.annotation.identify isEqualToString:identifier]) {
            CGPoint pointToMove = CGPointMake(pin.annotation.point.x/self.minimumZoomScale, pin.annotation.point.y/self.minimumZoomScale);
            [self setContentCenter:pointToMove animated:YES];
            break;
        }
    }
}

- (void)changePOIImg:(NSString *)identifier
            withPath:(NSString *)imagePath
{
    for (HDAnnotationView *annView in self.pinAnnotations) {
        HDAnnotationView *temp = annView;
        if ([temp.annotation.identify isEqualToString:identifier]) {
            [temp changePOIImageWithPath:imagePath];
        }
    }
}

- (void)changeBigPOIImg:(NSString *)identifier
               withPath:(NSString *)imagePath WithTitle:(NSString *)title {
    for (HDAnnotationView *annView in self.pinAnnotations) {
        HDAnnotationView *temp = annView;
        if ([temp.annotation.identify isEqualToString:identifier]) {
            [temp changeBigPOIImageWithPath:imagePath andTitle:title];
        }
    }
}


#pragma mark ----- 连续定位 -----
- (void)updateKeepLocationPinPositionWith:(CGPoint)point timeInterval:(CGFloat)interval
{
    CGPoint destinPoint = CGPointMake(point.x*self.zoomScale, point.y*self.zoomScale);
    HDAnnotation *ann = [HDAnnotation annotationWithPoint:destinPoint];
    ann.annType = kAnnotationType_Successive;
    ann.identify = kSuccessive_Ann_ID;
    ann.point = point;
    [self addSuccsiveAnnotation:ann animated:NO timeInterval:interval];
    
}

- (void)addSuccsiveAnnotation:(HDAnnotation *)annotation animated:(BOOL)animate timeInterval:(CGFloat)interval {
    //自动放大地图，暂时关闭，连续定位效果不好
    
    if (!self.pinAnnotations) {
        self.pinAnnotations = [[NSMutableArray alloc] init];
    }
    if (self.successiveAnn != nil) {
        if (self.zooming == NO) {
            self.successiveAnn.hidden = NO;
            CGRect frame = self.successiveAnn.frame;
            CGRect frameA = [self.successiveAnn frameForPoint:annotation.point];
            CGPoint nowPoint = CGPointMake(annotation.point.x*self.minimumZoomScale/self.zoomScale, annotation.point.y*self.minimumZoomScale/self.zoomScale);
            
            self.successiveAnn.annotation.point = nowPoint;
            [self.annBgView bringSubviewToFront:self.successiveAnn];
            //poi动画时间
            [UIView animateWithDuration:interval animations:^{
                self.successiveAnn.frame = CGRectMake(frameA.origin.x, frameA.origin.y, frame.size.width, frame.size.height);
            } completion:^(BOOL finished) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KeepLocation_RefreshPoint_Noti" object:nil];
                if (![self isMoveToCenter:self.successiveAnn]) {
                    //移动到屏幕中心
                    //[self setContentCenter:annotation.centerPoint animated:YES];
                    //LOG(@"====移动到屏幕中心=====");
                }
            }];
        }
    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //
            HDAnnotationView *pinAnnotation = [[HDAnnotationView alloc] initWithAnnotation:annotation
                                                                                    onView:self
                                                                                  animated:animate];
            self.successiveAnn = pinAnnotation;
            [self.pinAnnotations addObject:self.successiveAnn];
            [self addObserver:pinAnnotation
                   forKeyPath:@"contentSize"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
            [self.annBgView bringSubviewToFront:self.successiveAnn];
            
        });
    }
}

- (BOOL)isMoveToCenter:(HDAnnotationView *)successiveAnn {
    CGRect annFrame = [successiveAnn.superview convertRect:successiveAnn.frame toView:self.superview];
    CGRect safeFrame = CGRectMake(50, 50, self.superview.frame.size.width-100, self.superview.frame.size.height-100);
    BOOL isContain = CGRectContainsRect(safeFrame, annFrame);
    //    LOG(@"===%@ ===%@ ====%d",NSStringFromCGRect(safeFrame),NSStringFromCGRect(annFrame),isContain);
    
    return isContain;
}


- (void)centeredSuccessiveLocation:(CGPoint)centerPoint
{
    if (self.successiveAnn != nil) {
        [self setContentCenter:CGPointMake(centerPoint.x/self.zoomScale, centerPoint.y/self.zoomScale) animated:YES];
    }
}

- (void)removeSuccessive:(HDAnnotation *)ann
{
    for (HDAnnotationView *annTemp in self.pinAnnotations) {
        if (annTemp.annotation.annType == kAnnotationType_Successive) {
            annTemp.hidden = YES;
            [annTemp removeFromSuperview];
        }
    }
}



@end


