//
//  HDBaseModel.m
//  HDShanXiMuseum
//
//  Created by liuyi on 2017/11/29.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "HDBaseModel.h"
#import <objc/runtime.h>
#import "SDImageCache.h"

@implementation HDBaseModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if (self = [super init]) {
        for (NSString *key in [dic allKeys]) {
            id value = dic[key];
            //1.处理对象类型和数组类型
            if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                [self setValue:value forKeyPath:key];
            }
            //2.处理空类型:防止出现unRecognized selector exception
            else if ([value isKindOfClass:[NSNull class]]) {
                [self setValue:nil forKey:key];
            }
            //3.处理其他类型：包括数字，字符串，布尔，全部使用NSString来处理
            else{
                [self setValue:[NSString stringWithFormat:@"%@",value] forKeyPath:key];
            }
        }
    }
    return self;
}

#pragma mark KVC --- 安全设置 ----
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]) {
        _ID = (NSString *)value;
    }
    if([key isEqualToString:@"description"]) {
        _Des = (NSString *)value;
    }
    //    NSLog(@"%s",__func__);
}
- (void)setNilValueForKey:(NSString *)key
{
    //    NSLog(@"%s",__func__);
}

#pragma mark ___ po或者打印时打出内部信息 ____
-(NSString *)description {
    NSMutableString *text = [NSMutableString stringWithFormat:@"<%@> \n", [self class]];
    NSArray *properties = [self filterPropertys];
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = (NSString *)obj;
        id value = [self valueForKey:key];
        NSString *valueDescription = (value) ? [value description] : @"(null)";//没有赋值显示为null
        if ( ![value respondsToSelector:@selector(count)] && [valueDescription length] > 60  ) {
            valueDescription = [NSString stringWithFormat:@"%@...", [valueDescription substringToIndex:59]];//最长只显示60位
        }
        valueDescription = [valueDescription stringByReplacingOccurrencesOfString:@"\n" withString:@"\n   "];
        [text appendFormat:@"   [%@]: %@\n", key, valueDescription];
    }];
    [text appendFormat:@"</%@>", [self class]];;
    return text;
}

#pragma mark 获取一个类的属性列表
- (NSArray *)filterPropertys
{
    NSMutableArray *props = [NSMutableArray array];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for(int i = 0; i < count; i++){
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
        NSLog(@"name:%s",property_getName(property));
        NSLog(@"attributes:%s",property_getAttributes(property));//attributes:T@"NSString",C,N,V_height
    }
    free(properties);
    return props;
}

#pragma mark --- 模型中的字符串类型的属性转化为字典 ----
-(NSDictionary*)modelStringPropertiesToDictionary
{
    NSArray* properties = [self filterPropertys];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString* key = (NSString*)obj;
        id value = [self valueForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            NSString* va =  (NSString*)value;
            if (va.length > 0) {
                [dic setObject:value forKey:key];
            }
        }
    }];
    return dic;
}

#pragma mark ---- 
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int outCount;
        Ivar * ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];
            NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount;
    Ivar * ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

/*
 //原始键对方法
 // 归档方法
 - (void)encodeWithCoder:(NSCoder *)aCoder
 {
 [aCoder encodeObject:self.name forKey:@"name"];
 [aCoder encodeInteger:self.age forKey:@"age"];
 [aCoder encodeObject:self.gender forKey:@"gender"];
 }
 
 // 反归档方法
 - (instancetype)initWithCoder:(NSCoder *)aDecoder
 {
 self = [super init];
 
 if (self != nil) {
 self.name = [aDecoder decodeObjectForKey:@"name"];
 self.age = [aDecoder decodeIntegerForKey:@"age"];
 self.gender = [aDecoder decodeObjectForKey:@"gender"];
 }
 return self;
 }
 
 //使用方法
 Person *person = [[Person alloc]init];
 person.name = @"Baby";
 person.age = 16;
 person.gender = @"男";
 
 // 归档，调用归档方法
 NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"person.plist"];
 BOOL success = [NSKeyedArchiver archiveRootObject:person toFile:filePath];
 NSLog(@"%d",success);
 
 // 反归档，调用反归档方法
 Person *per = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
 NSLog(@"%@",per);
 
 */

+ (void)clearMapCaches {
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}

@end








