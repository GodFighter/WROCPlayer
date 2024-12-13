//
//  WRPlayerDefine.h
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/6.
//

#ifndef WRPlayerDefine_h
#define WRPlayerDefine_h


@class WRPlayer;

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


@protocol WRPlayerDelegate <NSObject>

- (void)playerStatusDidChanged:(WRPlayer *)player;
- (void)playerPlayTimeDidChanged:(WRPlayer *)player;

@end

#endif /* WRPlayerDefine_h */
