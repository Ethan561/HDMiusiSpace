//
//  XHStarRateView.h
//  XHStarRateView
//
//  Created by 江欣华 on 16/4/1.
//  Copyright © 2016年 jxh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHStarRateView;

typedef void(^finishBlock)(CGFloat currentScore);

typedef NS_ENUM(NSInteger, RateStyle)
{
    WholeStar = 0, //只能整星评论
    HalfStar = 1,  //允许半星评论
    IncompleteStar = 2  //允许不完整星评论
};

@protocol XHStarRateViewDelegate <NSObject>

-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore;

@end

@interface XHStarRateView : UIView

@property (nonatomic,assign)BOOL isAnimation;       //是否动画显示，默认NO
@property (nonatomic,assign)RateStyle rateStyle;    //评分样式    默认是WholeStar
@property (nonatomic, weak) id<XHStarRateViewDelegate>delegate;

/*
 *pragram
 *foreImgName:传递本地star图片名字
 */
-(instancetype)initWithFrame:(CGRect)frame andForegroundImg: (NSString*)foreImgName;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation andForegroundImg: (NSString*)foreImgName delegate:(id)delegate;


-(instancetype)initWithFrame:(CGRect)frame andForegroundImg: (NSString*)foreImgName finish:(finishBlock)finish;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation andForegroundImg: (NSString*)foreImgName finish:(finishBlock)finish;
-(void)setCurrentScore:(CGFloat)currentScore;
@end
