//
//  HDRouteDrawingView.m
//  HDGansuKJG
//
//  Created by liuyi on 2018/10/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

#import "HDRouteDrawingView.h"

@interface HDRouteDrawingView ()

@end

@implementation HDRouteDrawingView

#define Sub_Mutilple 8.0f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawPointWithArray:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    for (int i = 0; i < _pointArray.count; i++) {
        NSValue *pntValue = _pointArray[i];
        CGPoint linePoint = pntValue.CGPointValue;
        
        CGContextMoveToPoint(context, linePoint.x/Sub_Mutilple*self.mapZoomScale, linePoint.y/Sub_Mutilple*self.mapZoomScale);
        CGFloat lengths[] = {4};
        CGContextSetLineDash(context, 4, lengths,1);
        NSInteger j=i+1;
        if (_pointArray.count > j)
        {
            NSValue *pntValue = _pointArray[j];
            CGPoint point = pntValue.CGPointValue;
            CGContextAddLineToPoint(context, point.x/Sub_Mutilple*self.mapZoomScale, point.y/Sub_Mutilple*self.mapZoomScale);
        }
    }
    CGContextStrokePath(context);
    CGContextRef nowContext = UIGraphicsGetCurrentContext();

    for (int i = 0; i < _pointArray.count; i++) {
        NSValue *pntValue = _pointArray[i];
        CGPoint linePoint = pntValue.CGPointValue;
        // 画点。。
        CGContextFillEllipseInRect(context, CGRectMake(linePoint.x/Sub_Mutilple*self.mapZoomScale-1, linePoint.y/Sub_Mutilple*self.mapZoomScale-1, 2, 2));
        CGContextSetFillColorWithColor(nowContext, [[UIColor cyanColor] CGColor]);
    }
    CGContextStrokePath(nowContext);
    //画起点终点图片
    if (self.pointArray.count >= 2) {
        [self drawImage];
    }
}

- (void)drawRect:(CGRect)rect
{
    [self drawPointWithArray:rect];
}

- (void)drawImage {
    //起点
    UIImage *startImageName = [UIImage imageNamed:@"icon_nav_start"];
    NSValue *pntValue = _pointArray[0];
    CGPoint linePoint = pntValue.CGPointValue;
    [startImageName drawAtPoint:CGPointMake(linePoint.x/Sub_Mutilple*self.mapZoomScale-startImageName.size.width/2.0 , linePoint.y/Sub_Mutilple*self.mapZoomScale-startImageName.size.height+ 20 )];
    
    //终点
    UIImage *endImageName = [UIImage imageNamed:@"icon_nav_end"];
    NSValue *pntValue1 = _pointArray.lastObject;
    CGPoint linePoint1 = pntValue1.CGPointValue;
    [endImageName drawAtPoint:CGPointMake(linePoint1.x/Sub_Mutilple*self.mapZoomScale-endImageName.size.width/2.0 , linePoint1.y/Sub_Mutilple*self.mapZoomScale-endImageName.size.height+ 20)];
}

@end


