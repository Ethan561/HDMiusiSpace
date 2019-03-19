//
//  HDBaseModel.h
//  HDShanXiMuseum
//
//  Created by liuyi on 2017/11/29.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HDBaseModel : NSObject<NSCoding>

- (instancetype)initWithDic:(NSDictionary *)dic;//NSDictionary -> Model
- (NSDictionary *)modelStringPropertiesToDictionary;//Model -> NSDictionary

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *Des;

+ (void)clearMapCaches;

@end
















