//
//  HD_LY_Cache.m
//  HDNetworkManagerDemo
//
//  Created by liuyi on 2017/5/15.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "HD_LY_Cache.h"
#import <CoreGraphics/CoreGraphics.h>

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex: 0]

static HD_LY_Cache *instance = nil;
static YYCache *_dataCache;
static NSString *const cacheName = @"HD_Cache";

@implementation HD_LY_Cache

+ (void)initialize  {
    
    [super initialize];
    // 实例化方式一
    _dataCache = [[YYCache alloc] initWithName:cacheName];
}

+ (void)saveDataCache:(id)data forKey:(NSString *)key {
    // 默认会开启线程缓存
    [_dataCache setObject:data forKey:key withBlock:nil];
}

+ (id)readDataCache:(NSString *)key {
    
    return  [_dataCache objectForKey:key];
}

+ (void)saveDataCache:(id)data forKey:(NSString *)key parameters:(NSDictionary *)parameters;
{
    NSString *cacheKey = [self cacheKeyWithURL:key parameters:parameters];
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:data forKey:cacheKey withBlock:nil];
}

+ (id)readDataCache:(NSString *)key parameters:(NSDictionary *)parameters
{
    NSString *cacheKey = [self cacheKeyWithURL:key parameters:parameters];
    return  [_dataCache objectForKey:cacheKey];
}

+ (NSString *)getAllHttpCacheSize
{
    // 总大小
    unsigned long long diskCache = [_dataCache.diskCache totalCost];
    NSString *sizeText = nil;
    if (diskCache >= pow(10, 9)) {
        // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", diskCache / pow(10, 9)];
    } else if (diskCache >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", diskCache / pow(10, 6)];
    } else if (diskCache >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", diskCache / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%zdB", diskCache];
    }
    return sizeText;
}

+ (BOOL)isCache:(NSString *)key parameters:(NSDictionary *)parameters;
{
    NSString *cacheKey = [self cacheKeyWithURL:key parameters:parameters];
    return [_dataCache containsObjectForKey:cacheKey];
}

+ (void)removeChacheForKey:(NSString *)key
{
    [_dataCache removeObjectForKey:key withBlock:nil];
}

+ (void)removeAllCaches
{
    [_dataCache removeAllObjects];
}

+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters
{
    if(!parameters){return URL;};
    
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    // 将URL与转换好的参数字符串拼接在一起,成为最终存储的KEY值
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",URL,paraString];
    
    return cacheKey;
}

+ (NSString *)totalCacheSize
{
    unsigned long long diskCache = [_dataCache.diskCache totalCost];
    CGFloat webCache = diskCache / pow(10, 6);
    CGFloat cache1 = [self folderSizeAtPath:[NSString stringWithFormat:@"%@/default",CachePath]];
    CGFloat cache2 = [self folderSizeAtPath:[NSString stringWithFormat:@"%@/OnlineMapCache",CachePath]];
    //NSLog(@"--%lf---%lf---%lf--",webCache,cache1,cache2);
    NSString *caches = [NSString stringWithFormat:@"%.f",webCache+cache1+cache2];
    return caches;
}


//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:filePath]){
        return[[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


//遍历文件夹获得文件夹大小，返回多少M
//设置folderPath为cache路径。
+ (float) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0); //得到缓存大小M
}

+ (void)clearAllCache
{
    [self removeAllCaches];
    NSString *path1 = [NSString stringWithFormat:@"%@/default",CachePath];
    NSString *path2 = [NSString stringWithFormat:@"%@/OnlineMapCache",CachePath];
    NSString *path3 = [NSString stringWithFormat:@"%@/Resource/WebMap", CachePath];

    if ([[NSFileManager defaultManager] fileExistsAtPath:path1]) {
        [[NSFileManager defaultManager] removeItemAtPath:path1 error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:path2]) {
        [[NSFileManager defaultManager] removeItemAtPath:path2 error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:path3]) {
        [[NSFileManager defaultManager] removeItemAtPath:path3 error:nil];
    }
}



@end












