//
//  UIImage+Scale.h
//  BitmapSlice
//
//  Created by Dat Truong on 2014-06-07.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

- (UIImage *)imageScaledToQuarter;
- (UIImage *)imageScaledToHalf;
- (UIImage *)imageScaledToScale:(CGFloat)scale;
- (UIImage *)imageScaledToScale:(CGFloat)scale
       withInterpolationQuality:(CGInterpolationQuality)quality;

@end
