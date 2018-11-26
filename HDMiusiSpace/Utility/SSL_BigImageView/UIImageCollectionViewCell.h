//
//  UIImageCollectionViewCell.h
//  ImageReview
//
//  Created by SSLong on 2017/9/21.
//  Copyright ssl. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageCellClickDelegate<NSObject>
- (void)ImageCellDidClick;
@end
@interface UIImageCollectionViewCell : UICollectionViewCell
@property(nonatomic , assign) NSObject<ImageCellClickDelegate> *delegate;
@property (nonatomic, strong) UIImageView *imageView;

- (void)setImage:(NSString *)imageName;
- (void)setImageWithImage:(UIImage *)image;
@end
