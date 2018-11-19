//
//  HDCallOutView.m
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/12.
//  Copyright © 2018 hengdawb. All rights reserved.
//

#import "HDCallOutView.h"
#import "HDAnnotation.h"

@implementation HDCallOutView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapAction)];
    [self addGestureRecognizer:tap];
    
    _rateView = [[XHStarRateView alloc] initWithFrame:CGRectMake((160-60)/2.0, 35, 60, 25) numberOfStars:5 rateStyle:IncompleteStar isAnination:YES andForegroundImg:@"dl_map_star_red" finish:^(CGFloat currentScore) {
        NSLog(@"4----  %f",currentScore);
    }];
    
    [self addSubview:_rateView];
    [_rateView setCurrentScore:4];
    
}

- (void)setMyAnn:(HDAnnotation *)myAnn {
    _myAnn = myAnn;
    [_rateView setCurrentScore:myAnn.star.floatValue];

}

- (void)myTapAction {
    NSLog(@"点击 callout ");
    if (self.myAnn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kMapView_didTapHDCallOutView_Noti" object:self.myAnn];
    }
}


@end




