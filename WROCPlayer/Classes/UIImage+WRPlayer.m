//
//  UIImage+WRPlayer.m
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/12.
//

#import "UIImage+WRPlayer.h"

@implementation UIImage (WRPlayer)

+ (UIImage * _Nullable)WR_SystemImageNamed:(NSString *)imageName {
    return [self WR_SystemImageNamed:imageName withWeight:UIImageSymbolWeightRegular withColor:nil];
}

+ (UIImage * _Nullable)WR_SystemImageNamed:(NSString *)imageName
                                withWeight:(UIImageSymbolWeight)weight {
    return [self WR_SystemImageNamed:imageName withWeight:weight withColor:nil];
}

+ (UIImage * _Nullable)WR_SystemImageNamed:(NSString *)imageName
                                withWeight:(UIImageSymbolWeight)weight
                                 withColor:(UIColor * _Nullable)color {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithWeight:weight];
    UIImage *image = [[UIImage systemImageNamed:imageName withConfiguration:config] wr_conversionColor:color];
    return image;
}

+ (UIImage *)WR_GradientImageWithColors:(NSArray *)colors
                                andSize:(CGSize)size
                           andLocations:(NSArray *)locations
                               andStart:(CGPoint)start
                                 andEnd:(CGPoint)end {
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    if (space == NULL) {
        return nil;
    }
    
    CGFloat resultLocations[locations.count];
    for (int i = 0; i < locations.count; i++) {
        resultLocations[i] = fminf(fmaxf([locations[i] floatValue], 0), 1);
    }
    
    NSMutableArray *colorRefArray = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorRefArray addObject:(id)color.CGColor];
    }
    
    CGGradientRef gradientRef = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colorRefArray, resultLocations);
    CGColorSpaceRelease(space);
    if (gradientRef == NULL) {
        return nil;
    }
    
    CGPoint resultStart = CGPointMake(start.x * size.width, start.y * size.height);
    CGPoint resultEnd = CGPointMake(end.x * size.width, end.y * size.height);

    CGContextDrawLinearGradient(context, gradientRef, resultStart, resultEnd, kCGGradientDrawsBeforeStartLocation);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradientRef);
    
    UIGraphicsEndImageContext();

    return img;

}

- (UIImage * _Nullable)wr_conversionColor:(UIColor * _Nullable)color {
    if (color == nil) {
        return [self imageWithTintColor:UIColor.whiteColor renderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    return [self imageWithTintColor:color renderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (BOOL)wr_isPureColor {
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;

    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize = CGSizeMake(40, 40);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width * 4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, self.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    if (data == NULL) return YES;
    
    int temp_r =  data[0],temp_g = data[1],temp_b = data[2];
    
    BOOL flag = NO;
    for (int x = 0; x < thumbSize.width*thumbSize.height; x++) {
        
        int offset = 4 * x;
        int red = data[offset];
        int green = data[offset+1];
        int blue = data[offset+2];
        
        if (red == temp_r && green == temp_g && temp_b == blue) {
            //颜色相同仍然继续
            flag = YES;
        }else{
            //颜色不同---停止
            flag = NO;
            break;
        }
        temp_r = red;
        temp_g = green;
        temp_b = blue;
    }
    CGContextRelease(context);
    
    return flag;

}

@end
