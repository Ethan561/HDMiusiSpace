//
//  HDMapModel.h
//  HDGansuKJG
//
//  Created by liuyi on 2018/10/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

#import "HDBaseModel.h"

@interface HDMapModel : HDBaseModel

@property (nonatomic, copy) NSString *exhibit_id;  //展品id
@property (nonatomic, copy) NSString *exhibit_num; //展品编号
@property (nonatomic, copy) NSString *x;      //x坐标
@property (nonatomic, copy) NSString *y;      //y坐标
@property (nonatomic, copy) NSString *auto_num;    //蓝牙号
@property (nonatomic, copy) NSString *floor_num;   //楼层
@property (nonatomic, copy) NSString *looked_poi_img;       //点位图片
@property (nonatomic, copy) NSString *unlooked_poi_img;       //点位图片

@property (nonatomic, copy) NSString *title;       //标题
@property (nonatomic, copy) NSString *room_title;
@property (nonatomic, copy) NSString *is_more;         //展品数量，1表示单点，大于1表示有一对多
@property (nonatomic, copy) NSString *circle_list_limg;
@property (nonatomic, copy) NSString *attribute;
@property (nonatomic, copy) NSString *lrc;         //歌词
@property (nonatomic, copy) NSString *mp3;         //音频
@property (nonatomic, copy) NSString *desc;        //展品描述
@property (nonatomic, copy) NSArray *device_info;

@property (nonatomic, copy) NSString *poi_img;

+ (instancetype)mapPoiWithDict:(NSDictionary *)dict;

@end
