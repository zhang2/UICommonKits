//
//  ZJGPrintTool.m
//  UserDefaultDemo
//
//  Created by zjg on 6/10/21.
//

#import "ZJGPrintTool.h"

@implementation ZJGPrintTool

+ (UIColor *)arndomColor {
    CGFloat red = arc4random_uniform(256)/ 255.0;

    CGFloat green = arc4random_uniform(256)/ 255.0;

    CGFloat blue = arc4random_uniform(256)/ 255.0;

    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];

    return color;
}

@end
