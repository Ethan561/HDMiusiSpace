//
//  HD_LY_Cache.h
//  HDNetworkManagerDemo
//
//  Created by liuyi on 2017/5/15.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYCache.h"
//注意：需要添加 libsqlite3.tbd

@interface HD_LY_Cache : NSObject

//
+ (void)saveDataCache:(id)data forKey:(NSString *)key;
+ (id)readDataCache:(NSString *)key;
    
+ (void)saveDataCache:(id)data forKey:(NSString *)key parameters:(NSDictionary *)parameters;
+ (id)readDataCache:(NSString *)key parameters:(NSDictionary *)parameters;

+ (NSString *)getAllHttpCacheSize;
+ (void)removeChacheForKey:(NSString *)key;
+ (void)removeAllCaches;
+ (BOOL)isCache:(NSString *)key parameters:(NSDictionary *)parameters;

+ (NSString *)totalCacheSize;
+ (void)clearAllCache;


@end







