//
//  UIImage+Category.m
//  Test
//
//  Created by zjg on 7/12/21.
//

#import "UIImage+Category.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Category)

/**
 生成一张高斯模糊的图片
*/
+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur
{
    // 模糊度越界
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    if (inBitmapData) {
        inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    }

    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");

    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);

    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);

    if (error) {
        NSLog(@"error from convolution %ld", error);
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];

    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);

    free(pixelBuffer);
    CFRelease(inBitmapData);

    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);

    return returnImage;
}


/**
 根据颜色生成一张图片
*/
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    if (color) {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        // 开启图形上下文
        UIGraphicsBeginImageContext(rect.size);
        // 获取当前的上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        // 将颜色填充到上下文
        CGContextSetFillColorWithColor(context, color.CGColor);
        // 将内容填满指定的尺寸
        CGContextFillRect(context, rect);
        // 从上下文获取图片
        UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
        // 关闭上下文
        UIGraphicsEndImageContext();
        
        return image;
    }
    return nil;
}


/**
 生成一张圆形图片
*/
+ (UIImage *)circleImage:(UIImage *)originImage borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    // 设置圆形图片的直径
    CGFloat imageDia = originImage.size.width;
    // 计算外圆的直径(边框是在图片外额外添加的区域)
    CGFloat borderDia = imageDia + 2 * borderWidth;

    // 开启图形上下文
    UIGraphicsBeginImageContext(originImage.size);
    // 画一个包含边框的圆形
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, borderDia, borderDia)];
    // 设置颜色
    [borderColor set];
    [path fill];

    // 设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderWidth, borderWidth, imageDia, imageDia)];
    // 裁剪图片
    [clipPath addClip];
    
    // 绘制图片
    [originImage drawAtPoint:CGPointMake(borderWidth, borderWidth)];
    // 从上下文中获取图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return resultImage;
}

/**
 生成一张不被渲染的图片
*/
+ (UIImage *)imageRenderingModeAlowsOriginal:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

// 获取截屏生成image
+ (UIImage *)getScreenShot:(CGRect)rect ofView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);

    if (@available(iOS 9.0, *)) {
        
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
    } else if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        
        BOOL isComplate = [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
        NSLog(@">>>>>>>>>>>>>>>>%@", isComplate?@"YES":@"NO");
    } else {
        
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

// 生成二维码
+ (UIImage *)createQRCodeImageWithString:(NSString *)qrString {
    @autoreleasepool {
        // Need to convert the string to a UTF-8 encoded NSData object
        NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
        // Create the filter
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // Set the message content and error-correction level
        [qrFilter setValue:stringData forKey:@"inputMessage"];
        [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
        // Send the image back
        CIImage* image = qrFilter.outputImage;
        
        CGFloat size = 250.0f;
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
        // create a bitmap image that we'll draw into a bitmap context at the desired size;
        size_t width = CGRectGetWidth(extent) * scale;
        size_t height = CGRectGetHeight(extent) * scale;
        CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
        CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        // Create an image with the contents of our bitmap
        CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
        UIImage *resultImage = [UIImage imageWithCGImage:scaledImage];
        // Cleanup
        CGContextRelease(bitmapRef);
        CGImageRelease(bitmapImage);
        CGColorSpaceRelease(cs);
        CGImageRelease(scaledImage);
        return resultImage;
    }
}

// 将颜色生成图片
+ (UIImage *)createImageWithColor:(UIColor*)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// 修改图标颜色
- (UIImage *)imageChangeColor:(UIColor*)color {
    //获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    //画笔沾取颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    //再绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
