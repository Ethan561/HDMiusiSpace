//
//  HDMapView+Download.h
//  HDGansuKJG
//
//  Created by liuyi on 2018/10/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

#import "HDMapView.h"

@interface HDMapView (Download)

- (void)recordItemToSet:(NSString *)suffixPath;
- (void)startDownloadItem;
- (void)downloadFirstLevel;

@end
