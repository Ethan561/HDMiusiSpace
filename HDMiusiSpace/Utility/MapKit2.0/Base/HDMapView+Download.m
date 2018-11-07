//
//  HDMapView+Download.m
//  HDGansuKJG
//
//  Created by liuyi on 2018/10/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

#import "HDMapView+Download.h"
#import "SDWebImageManager.h"

@implementation HDMapView (Download)

- (void)recordItemToSet:(NSString *)suffixPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapItemSet addObject:suffixPath];
    });
}

- (void)startDownloadItem
{
    [self downloadMapItemForNot250];
}

- (void)downloadFirstLevel
{
    NSArray *pathArray = @[@"1_250_0_0.png",
                           @"1_250_0_1.png",
                           @"1_250_0_2.png",
                           @"1_250_0_3.png",
                           @"1_250_1_0.png",
                           @"1_250_1_1.png",
                           @"1_250_1_2.png",
                           @"1_250_1_3.png",
                           @"1_250_2_0.png",
                           @"1_250_2_1.png",
                           @"1_250_2_2.png",
                           @"1_250_2_3.png",
                           @"1_250_3_0.png",
                           @"1_250_3_1.png",
                           @"1_250_3_2.png",
                           @"1_250_3_3.png"];
    
    for (NSInteger i=0;i<pathArray.count;i++) {
        [self.mapItemSet addObject:pathArray[i]];
    }
    [self downloadMapItemForNot250];
}

#pragma mark -------- 瓦片地图背地里下载 ---------

- (void)downloadMapItemForNot250
{
    NSEnumerator *enumerator = [self.mapItemSet objectEnumerator];
    
    NSString *path  = [enumerator nextObject];
    NSMutableArray *urlArray = [NSMutableArray new];
    while (path != nil) {
        NSString *pathStr = [NSString stringWithFormat:@"%@%@", self.urlPrefix, path];
        [urlArray addObject:pathStr];
        path = [enumerator nextObject];
    }
    [self.mapItemSet removeAllObjects];
    
    dispatch_group_t group = dispatch_group_create();
    
    for(NSString *itemPath in urlArray){
        //NSLog(@"%@",itemPath);
        dispatch_group_enter(group);
        
        NSURL *downloadURL = [NSURL URLWithString:itemPath];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:downloadURL
                                                              options:0
         
                                                             progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {}
                                                            completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             NSString *imgName = [itemPath substringFromIndex:self.urlPrefix.length];
             [self storeImg:image withName:imgName];
             
             //下载完成后进入这里执行
             dispatch_group_leave(group);
         }];
        
        //减少刷新次数，下载完一批刷新一次
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            // 下载图片完成后, 回到主线 刷新UI
            [self refreshMapView];
        });
    }
}


- (void)refreshMapView{
    [self reloadViewAction];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(reloadViewAction) withObject:nil afterDelay:1];
}
- (void)storeImg:(UIImage *)img
        withName:(NSString *)imgName
{
    BOOL isDir = FALSE;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:self.mapItemCachePath isDirectory:&isDir] == NO)
    { [self createMapPath:self.mapItemCachePath]; }
    
    BOOL isDirExist = [fileManager fileExistsAtPath:self.mapItemCachePath isDirectory:&isDir];
    if (isDirExist == YES) {
        
        NSString *storeImgPath = [NSString stringWithFormat:@"%@/%@", self.mapItemCachePath, imgName];
        NSData *imagedata=UIImagePNGRepresentation(img);
        if ([fileManager fileExistsAtPath:storeImgPath]) // 如果多线程冲突的话，可能会有下载失败的情况
            [fileManager removeItemAtPath:storeImgPath error:nil];
        
        [fileManager createFileAtPath:storeImgPath contents:imagedata attributes:nil];
    }
}

- (void)createMapPath:(NSString *)webMapPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    NSError *isError = nil;
    BOOL existed = [fileManager fileExistsAtPath:webMapPath isDirectory:&isDir];
    if (isDir == YES && existed == YES) {
        [fileManager removeItemAtPath:webMapPath error:&isError];
    }
    
    [fileManager createDirectoryAtPath:webMapPath withIntermediateDirectories:YES attributes:nil error:nil];
}


@end


