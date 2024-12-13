//
//  UIImage+WRPlayer.m
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/12.
//

#import "UIImage+WRPlayer.h"

@implementation UIImage (WRPlayer)

+ (UIImage * _Nullable)WR_SystemImageNamed:(NSString *)imageName {
    return [self WR_SystemImageNamed:imageName withWeight:UIImageSymbolWeightThin withColor:UIColor.whiteColor];
}

+ (UIImage * _Nullable)WR_SystemImageNamed:(NSString *)imageName withWeight:(UIImageSymbolWeight)weight {
    return [self WR_SystemImageNamed:imageName withWeight:weight withColor:UIColor.whiteColor];
}

+ (UIImage * _Nullable)WR_SystemImageNamed:(NSString *)imageName withWeight:(UIImageSymbolWeight)weight withColor:(UIColor * _Nullable)color {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithWeight:weight];
    return [[UIImage systemImageNamed:imageName withConfiguration:config] wr_conversionColor:color];
}

- (UIImage * _Nullable)wr_conversionColor:(UIColor * _Nullable)color {
    if (color == nil) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    return image;

}

@end
