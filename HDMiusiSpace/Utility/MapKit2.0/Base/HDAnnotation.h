//
//  HDAnnotation.h
//  HDMapKit
//
//  Created by HDNiuKuiming on 2017/5/16.
//  Copyright © 2017年 HDNiuKuiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HDMapModel;

typedef enum{

    kAnnotationType_One, //单个展品点位
    kAnnotationType_More, //合并展品点位
    kAnnotationType_Read, //已读状态点位
    kAnnotationType_Loc,  //展品定位或者好友定位
    
    kAnnotationType_Successive, //连续定位点
    kAnnotationType_ServiceInfo, //用于服务设施显示

}AnnotationType;

@interface HDAnnotation : NSObject

@property (nonatomic, assign) CGPoint    point;         // 坐标
@property (nonatomic, assign) CGSize    size;           // 大小

@property (nonatomic, strong) NSString   *title;        // 名称
@property (nonatomic, strong) NSString   *subtitle;     // 小坐标，一般不显示
@property (nonatomic, strong) NSString   *identify;     // 展品的编号
@property (nonatomic, strong) NSString   *poiImgPath;   // 展品的POI显示的图片
@property (nonatomic, strong) NSString   *audio;        // 展品的音频地址
@property (nonatomic, strong) NSString   *pointCount;

@property (nonatomic, assign) BOOL       isHighShow;    // 是否重点展品
@property (nonatomic, strong) NSString   *poiBigPath;   // 展品放大时候图片
@property (nonatomic, strong) NSString   *serviceType;  // 服务设施类型
@property (nonatomic, assign) NSInteger   beaconNum;    // 当前点的蓝牙号
@property (nonatomic, strong) NSString   *beaconCount;  // 一对多蓝牙数量
@property (nonatomic, assign) AnnotationType annType;   // 当前POI对应的展品的播放状态
@property (nonatomic, strong) HDMapModel *res;

+ (id)annotationWithPoint:(CGPoint)point;
- (id)initWithPoint:(CGPoint)point;

@end


