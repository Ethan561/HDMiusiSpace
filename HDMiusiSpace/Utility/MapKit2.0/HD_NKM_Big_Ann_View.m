//
//  HD_NKM_Big_Ann_View.m
//  HDJinShaSiteMuseum
//
//  Created by HDNiuKuiming on 2017/7/6.
//  Copyright © 2017年 HDNiuKuiming. All rights reserved.
//

#import "HD_NKM_Big_Ann_View.h"
#import "HDMapView.h"
#import "UIButton+WebCache.h"
#import "HDAnnotationView.h"

@implementation HD_NKM_Big_Ann_View

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapAction)];
    [self addGestureRecognizer:tap];
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePlayBtnStop) name:@"AudioPlayEnded" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePlayBtn) name:@"Notification_Poi_PausePlay" object:nil];
    [self.playBtn setImage:[UIImage imageNamed:@"A_paly"] forState:UIControlStateSelected];
    [self.playBtn setImage:[UIImage imageNamed:@"A_pause"] forState:UIControlStateNormal];

}

- (void)myTapAction
{
 
//    [_myAnnView smallPicture];

}

- (void)changePlayBtnStop {
    
    self.playBtn.selected = NO;

}

- (IBAction)playAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kOut_DoorMap_POI_Push_To_Player"
                                                        object:_myAnn];

//    sender.selected = ! sender.selected;
//    if (sender.selected) {
//        _myAnn.isPlay = kPlay_Status_Yes;
//    } else {
//        _myAnn.isPlay = kPlay_Status_No;
//    }
//    if ([self.delegate respondsToSelector:@selector(playOrPauseAction)]) {
//        [self.delegate playOrPauseAction];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kOut_DoorMap_POI_PlayAction"
//                                                        object:_myAnn];
}

- (IBAction)detailAction:(id)sender {
    NSLog(@"detail");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kOut_DoorMap_POI_Push_To_Player"
                                                        object:_myAnn];
//    if ([self.delegate respondsToSelector:@selector(pushToDetail)]) {
//        [self.delegate pushToDetail];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kOut_DoorMap_POI_Push_To_Player"
//                                                        object:_myAnn];
}

- (void)dealloc
{
    _myAnn = nil;
}


@end



