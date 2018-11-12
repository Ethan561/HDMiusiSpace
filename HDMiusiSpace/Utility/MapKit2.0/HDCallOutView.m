//
//  HDCallOutView.m
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/12.
//  Copyright © 2018 hengdawb. All rights reserved.
//

#import "HDCallOutView.h"

@implementation HDCallOutView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapAction)];
    [self addGestureRecognizer:tap];
}

- (void)myTapAction {
    NSLog(@"点击 callout ");
}


@end
