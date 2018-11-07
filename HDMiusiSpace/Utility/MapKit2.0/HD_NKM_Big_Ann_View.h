//
//  HD_NKM_Big_Ann_View.h
//  HDJinShaSiteMuseum
//
//  Created by HDNiuKuiming on 2017/7/6.
//  Copyright © 2017年 HDNiuKuiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDAnnotation.h"

@class HDMapView, HDAnnotationView;

@protocol BigDetailDelegate <NSObject>

- (void)pushToDetail;
- (void)playOrPauseAction;

@end
@interface HD_NKM_Big_Ann_View : UIView

@property (weak, nonatomic) IBOutlet UIImageView * _Nullable imgView;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable nameLabel;
@property (nonnull, strong) HDAnnotation *myAnn;
@property (nonatomic, strong) HDAnnotationView * _Nonnull myAnnView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) id <BigDetailDelegate> delegate;

@end
