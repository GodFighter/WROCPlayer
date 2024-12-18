//
//  AVAsset+WRPlayer.m
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/13.
//

#import "AVAsset+WRPlayer.h"

@implementation AVAsset (WRPlayer)

- (NSString * _Nullable)wr_title {
    NSArray *items = [AVMetadataItem metadataItemsFromArray:self.metadata filteredByIdentifier:AVMetadataCommonIdentifierTitle];
    AVMetadataItem *title = items.firstObject;
    return title.stringValue;
}

- (UIImage * _Nullable)wr_imageWithRTime:(NSTimeInterval)time {
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self];
    generator.appliesPreferredTrackTransform = YES;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;

    CMTimeScale timeScale = self.duration.timescale;
    CMTime cmTime = CMTimeMakeWithSeconds(time, timeScale);
    
    NSError *error = nil;
    CGImageRef cgImage = [generator copyCGImageAtTime:cmTime actualTime:NULL error:&error];
    UIImage *image = nil;
    if (error == nil) {
        image = [UIImage imageWithCGImage:cgImage];
    }
    CFRelease(cgImage);
    return image;
}

- (void)wr_imageWithTime:(NSTimeInterval)time completion:(void (^)(UIImage * _Nullable image))completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self wr_imageWithRTime:time];
        NSTimeInterval begin = time;
        while (image == nil || [self imageIsPureColor:image]) {
            image = [self wr_imageWithRTime:begin];
            begin += 1;
            if (begin >= CMTimeGetSeconds(self.duration)) {
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(image);
            }
        });
    });

}

- (BOOL)imageIsPureColor:(UIImage *)image {
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
    CGContextDrawImage(context, drawRect, image.CGImage);
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
