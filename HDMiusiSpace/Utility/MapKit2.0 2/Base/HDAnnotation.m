//
//  HDAnnotation.m
//  HDMapKit
//
//  Created by HDNiuKuiming on 2017/5/16.
//  Copyright © 2017年 HDNiuKuiming. All rights reserved.
//

#import "HDAnnotation.h"
#import "HDMapModel.h"

@implementation HDAnnotation

+ (id)annotationWithPoint:(CGPoint)point
{
	return [[[self class] alloc] initWithPoint:point];
}

- (id)initWithPoint:(CGPoint)point {
	self = [super init];
    
	if (self) {
		self.point = point;
	}
    
	return self;
}

- (void)dealloc {

}

@end
