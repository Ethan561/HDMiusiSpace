//
//  HDTiledView.m
//  HDMapKit
//
//  Created by Liuzhuan on 13-4-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDTiledView.h"
#import "math.h"

static const CGFloat kDefaultTileSizeWidth  = 256.0f; // 瓦片的大小
static const CGFloat kDefaultTileSizeHeight = 256.0f; // 瓦片的大小
static const CFTimeInterval kDefaultFadeDuration = 0.1;

@implementation HDTiledLayer

//初次加载淡入时间，默认0.25s
//由于是类方法，无法直接修改，创建子类进行方法覆盖就行。
+ (CFTimeInterval)fadeDuration
{
    return kDefaultFadeDuration;
}

@end


//HDTiledView

@interface HDTiledView ()

- (HDTiledLayer *)tiledLayer;

@end

@implementation HDTiledView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGSize scaledTileSize = CGSizeApplyAffineTransform(self.tileSize, CGAffineTransformMakeScale(self.contentScaleFactor, self.contentScaleFactor));
        self.tiledLayer.tileSize = scaledTileSize;
        self.tiledLayer.levelsOfDetail = 1;
        self.numberOfZoomLevels = 3;
        self.shouldAnnotateRect = NO;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//重写layerClass()，令该视图创建的图层实例为CATiledLayer
+ (Class)layerClass
{
    return [HDTiledLayer class];
}

// Defaults to (256, 256),设置CATiledLayer的item的大小
- (CGSize)tileSize
{
    return CGSizeMake(kDefaultTileSizeWidth, kDefaultTileSizeHeight);
}

- (size_t)numberOfZoomLevels
{
    return self.tiledLayer.levelsOfDetailBias;
}

- (void)setNumberOfZoomLevels:(size_t)levels
{
    self.tiledLayer.levelsOfDetailBias = levels;
}

- (HDTiledLayer *)tiledLayer
{
    return (HDTiledLayer *)self.layer;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat scale = CGContextGetCTM(ctx).a / self.tiledLayer.contentsScale;
    
    NSInteger col = (NSInteger)((CGRectGetMinX(rect) * scale) / self.tileSize.width);
    NSInteger row = (NSInteger)((CGRectGetMinY(rect) * scale+0.0001) / self.tileSize.height); // 加0.0001是补丁，处理了在iPhone 6P上面瓦片加载错误的问题
    
    UIImage *tile_image = [self.delegate tiledView:self
                                       imageForRow:row
                                            column:col
                                             scale:(NSInteger)scale];

    [tile_image drawInRect:rect];
}


@end








