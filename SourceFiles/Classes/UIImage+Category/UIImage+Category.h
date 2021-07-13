//
//  UIImage+Category.h
//  Test
//
//  Created by zjg on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)

// 生成一张高斯模糊的图片

+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;

// 根据颜色生成一张图片

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

// 生成一张圆形图片

+ (UIImage *)circleImage:(UIImage *)originImage borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

// 生成一张不被渲染的图片

+ (UIImage *)imageRenderingModeAlowsOriginal:(NSString *)imageName;

// 获取截屏生成image

+ (UIImage *)getScreenShot:(CGRect)rect ofView:(UIView *)view;

// 生成二维码

+ (UIImage *)createQRCodeImageWithString:(NSString *)qrString;

// 将颜色生成图片

+ (UIImage *)createImageWithColor:(UIColor*)color;

// 修改图标颜色

- (UIImage *)imageChangeColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
