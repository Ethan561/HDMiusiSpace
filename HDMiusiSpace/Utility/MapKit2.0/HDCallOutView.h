//
//  HDCallOutView.h
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/12.
//  Copyright © 2018 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"

NS_ASSUME_NONNULL_BEGIN

@class  HDAnnotation;

@interface HDCallOutView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (strong, nonatomic) XHStarRateView *rateView;
@property (nonatomic, strong) HDAnnotation *myAnn;

@end


NS_ASSUME_NONNULL_END
