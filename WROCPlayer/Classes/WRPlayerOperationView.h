//
//  WRPlayerOperationView.h
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/12.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "WRPlayerDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRPlayerOperationView : UIView

@property (nonatomic, copy) void (^operationBlock)(WRPlayerOperation operation, __nullable id var_value);

- (void)setStatus:(WRPlayerStatus)status;
- (void)setPlaybackStatus:(WRPlaybackStatus)status;

- (void)setAsset:(AVAsset *)asset;

@end

NS_ASSUME_NONNULL_END
