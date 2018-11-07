//
//  HDAnnotationView.m
//  HDMapKit
//
//  Created by Liuzhuan on 13-4-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDAnnotationView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "HDMapView.h"
#import "HDAnnotation.h"
#import "HD_NKM_Big_Ann_View.h"
#import "HDAnnotationView+Method.h"


#define Ann_DefaultWidth   45

@interface HDAnnotationView()

@end


@implementation HDAnnotationView

#pragma mark -------- Init Methods --------

- (instancetype)initWithAnnotation:(HDAnnotation *)annotation onView:(HDMapView *)mapView animated:(BOOL)animate {
	CGRect frame = CGRectMake(0, 0, 0, 0); // TODO: remove this
    
	if ((self = [super initWithFrame:frame])) {
		self.annotation = annotation;
        self.frame      = [self frameForPoint:annotation.point];
        self.enabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addTarget:mapView action:@selector(showCallOut:) forControlEvents:UIControlEventTouchDown];
        [mapView.annBgView addSubview:self];

        UIImage *myImage = [UIImage imageNamed:Placeholder_PIN];
        NSURL *poiImgURL = [NSURL URLWithString:annotation.poiImgPath];
        [self sd_setImageWithURL:poiImgURL forState:UIControlStateNormal placeholderImage:myImage];
        
        //自定义视图布局
        [self setupAnnView:self.annotation];
        
        if (animate) {
            CABasicAnimation *pindrop = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pindrop.duration       = 0.3f;
            pindrop.fromValue      = @0.1;
            pindrop.toValue        = @1.0;
            pindrop.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [self.layer addAnimation:pindrop forKey:@"transform.scale"];
        }
        
	}
    
	return self;
}

#pragma mark ---- 重新计算点frame
- (CGRect)frameForPoint:(CGPoint)point {
    
    CGFloat x = point.x - self.annotation.size.width/2.0;
    CGFloat y = point.y - self.annotation.size.height;
    CGSize annSize = self.annotation.size;
    if (annSize.width < 10 || annSize.height < 10) {
        annSize = CGSizeMake(Ann_DefaultWidth, Ann_DefaultWidth);
    }
    if (self.annotation.annType ==  kAnnotationType_Successive || self.annotation.annType ==  kAnnotationType_ServiceInfo) {
        y = point.y - annSize.height/2.0;
        return CGRectMake(round(x), round(y), annSize.width, annSize.height);
    }
    return CGRectMake(round(x), round(y)+18, annSize.width, annSize.height);
}

// 对mapview的放大倍数增加观察者，所有的POI根据放大倍数动态调整坐标
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"contentSize"]) {
        HDMapView *mapView = (HDMapView *)object;
        
        CGFloat      pointX   = (mapView.zoomScale/mapView.minimumZoomScale) * self.annotation.point.x;
        CGFloat      pointY  = (mapView.zoomScale/mapView.minimumZoomScale) * self.annotation.point.y;
        
        if (pointX > 0 && pointY > 0) {
            self.frame = [self frameForPoint:CGPointMake(pointX, pointY)];
        }
        
    }
}

- (void)dealloc
{
    [self stopAnimate];
    _annotation = nil;
    [self.layer removeAllAnimations];
}


@end





