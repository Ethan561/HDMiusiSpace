//
//  HDTiledView.h
//  HDMapKit
//
//  Created by Liuzhuan on 13-4-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class HDTiledView;

@protocol HDTiledViewDelegate <NSObject>
//用代理回调的方法获取当前要绘制加载的瓦片
-(UIImage *)tiledView:(HDTiledView *)tiledView
          imageForRow:(NSInteger)row
               column:(NSInteger)column
                scale:(NSInteger)scale;
@end

@interface HDTiledView : UIView

@property (nonatomic, assign)   id     <HDTiledViewDelegate>delegate;
@property (nonatomic, readonly) CGSize tileSize;
@property (nonatomic, assign)   size_t numberOfZoomLevels;
@property (nonatomic, assign)   BOOL   shouldAnnotateRect;

@end



@interface HDTiledLayer : CATiledLayer
/*
 
 CATiledLayer:瓦片地图绘制加载类
 1、功能简介
 CATiledLayer以图块（tile）为单位异步绘制图层内容，对超大尺寸图片或者只能在视图中显示一小部分的内容效果拔群，因为不用把内容完全载入内存就可以看到内容。
 把内容分解成固定大小的tile，当图块在屏幕上显示的时候，它会调用drawRect的方法进行绘制，只有可见的图块才绘制，这样就节约了处理时间和内存。

 
 2、相关属性

 产生模糊的根源是图层的细节层次（level of detail，简称LOD），CATiledLayer有两个相关属性：
 levelsOfDetail：指图层维护的LOD数目，默认值为1，每进一级会对前一级分辨率的一半进行缓存，图层的levelsOfDetail最大值，也就是最底层细节，对应至少一个像素点。
 levelsOfDetailBias：指的是该图层缓存的放大LOD数目，默认为0，即不会额外缓存放大层次，每进一级会对前一级两倍分辨率进行缓存。
 
 */

@end





