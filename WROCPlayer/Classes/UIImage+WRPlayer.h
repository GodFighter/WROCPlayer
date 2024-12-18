//
//  UIImage+WRPlayer.h
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (WRPlayer)

+ (UIImage * _Nullable)WR_SystemImageNamed:(NSString *)imageName;
+ (UIImage * _Nullable)WR_SystemImageNamed:(NSString *)imageName withWeight:(UIImageSymbolWeight)weight;
+ (UIImage * _Nullable)WR_SystemImageNamed:(NSString *)imageName withWeight:(UIImageSymbolWeight)weight withColor:(UIColor * _Nullable)color;
+ (UIImage *)WR_GradientImageWithColors:(NSArray *)colors andSize:(CGSize)size andLocations:(NSArray *)locations andStart:(CGPoint)start andEnd:(CGPoint)end;

- (UIImage * _Nullable)wr_conversionColor:(UIColor * _Nullable)color;

- (BOOL)wr_isPureColor;

@end

NS_ASSUME_NONNULL_END
