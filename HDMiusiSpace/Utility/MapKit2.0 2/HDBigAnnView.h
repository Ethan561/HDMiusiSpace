//
//  HDBigAnnView.h
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/12.
//  Copyright © 2018 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HDMapView, HDAnnotationView, HDAnnotation;

@interface HDBigAnnView : UIView

@property (weak, nonatomic) IBOutlet UIImageView * _Nullable imgView;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable nameLabel;

@property (nonnull, strong) HDAnnotation *myAnn;
@property (nonatomic, strong) HDAnnotationView * _Nonnull myAnnView;

@end

NS_ASSUME_NONNULL_END
