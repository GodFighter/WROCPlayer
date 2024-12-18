//
//  WRPlayerDefine.h
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/6.
//

#ifndef WRPlayerDefine_h
#define WRPlayerDefine_h


@class WRPlayer;

/**
 播放器状态
 */
typedef enum : NSUInteger {
    WRPlayerStatus_None    = 0,
    WRPlayerStatus_Loading = 1,
    WRPlayerStatus_Ready   = 2,
    WRPlayerStatus_Playing = 3,
    WRPlayerStatus_Paused  = 4,
    WRPlayerStatus_End     = 5,
    WRPlayerStatus_Stop    = 6,
    WRPlayerStatus_Failed  = 7,
} WRPlayerStatus;

/**
 播放状态
 */
typedef enum : NSUInteger {
    WRPlaybackStatus_Playing = 0,
    WRPlaybackStatus_Pause   = 1,
} WRPlaybackStatus;


typedef enum : NSUInteger {
    WRPlayerOperation_Back = 0,
    WRPlayerOperation_Play,
    WRPlayerOperation_FullScreen,
    WRPlayerOperation_Share,
} WRPlayerOperation;

@protocol WRPlayerDelegate <NSObject>

- (void)playerStatusDidChanged:(WRPlayer *)player;
- (void)playerPlayTimeDidChanged:(WRPlayer *)player;

@end

#endif /* WRPlayerDefine_h */
