//
//  HDMapKit.h
//  HDGansuKJG
//
//  Created by liuyi on 2018/10/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

/*
 版本：V1.0
 开发者：NKM
 更新时间：2017-05-15
 功能描述：瓦片地图加载，基于本地的瓦片和基于网络实时加载瓦片地图
 （1）contentSize的计算，等于地图的宽高除以8；
 （2）zoomScale默认等于minimumZoomScale，一般是以屏幕的宽自适应；
 （3）levelsOfZoom = levelsOfDetail；maximumZoomScale = 2的levelsOfZoom次方；
 （4）在线加载瓦片必须初始化的四个元素，在分类中使用；
 
*/


/*
 
 版本：V2.0
 开发者：liuyi
 更新时间：2018-10-31
 更新描述：地图模块重构，删除无效重复代码、精简模块功能、代码注释
 
 */


#ifndef HDMapKit_h
#define HDMapKit_h

#import "HDMapView.h"
#import "HDMapView+Download.h"
#import "HDMapView+AnnView.h"
#import "HDMapModel.h"
#import "HDRouteDrawingView.h"
#import "HDAnnotation.h"
#import "HDAnnotationView.h"
#import "HDAnnotationView+Method.h"


#endif /* HDMapKit_h */








