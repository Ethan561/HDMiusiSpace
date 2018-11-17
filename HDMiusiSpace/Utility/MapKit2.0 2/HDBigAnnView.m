//
//  HDBigAnnView.m
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/12.
//  Copyright © 2018 hengdawb. All rights reserved.
//

#import "HDBigAnnView.h"
#import "HDMapView.h"
#import "UIButton+WebCache.h"
#import "HDAnnotationView.h"

@implementation HDBigAnnView

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.layer.cornerRadius = 10;
//    self.clipsToBounds = YES;
    //
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapAction)];
    [self addGestureRecognizer:tap];
}

- (void)myTapAction {
    NSLog(@"点击 bigAnn ");

}


- (void)dealloc {
    
}



@end






