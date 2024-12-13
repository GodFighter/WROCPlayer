//
//  WRPlayer.m
//  Pods
//
//  Created by 项辉 on 2024/12/6.
//

#import "WRPlayer.h"

#import <AVFoundation/AVPlayer.h>
#import <MediaPlayer/MediaPlayer.h>

#import "WRPlayerView.h"

#define PLAYER_WEAKSELF __weak typeof(self) playerWeakSelf = self;

//MARK: -
@interface WRPlayer()

@property (nonatomic, strong) NSURL *playingURL;
@property (nonatomic, assign) NSTimeInterval startTimePoint; // 起始播放时间点

@property (nonatomic, strong) AVPlayerItem *avPlayerItem;
@property (nonatomic, strong) AVPlayer *avPlayer;

@property (nonatomic, strong) WRPlayerView *playerView;
@property (nonatomic, strong) UISlider *var_volumeSlider;
@property (nonatomic, weak) id var_avplayerTimeObeserver;

@property (nonatomic, assign, readwrite) NSTimeInterval duration;
@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;
@property (nonatomic, assign, readwrite) CGSize naturalSize;

@end

@implementation WRPlayer

//MARK: - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.playerView = [WRPlayerView new];
    }
    return self;
}

//MARK: - Public
+ (instancetype)Shared {
    static WRPlayer *shared = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^(){
        shared = [[WRPlayer alloc] init];
    });
    return shared;
}

- (void)destory {
    self.startTimePoint = 0;
    self.duration = 0;
    self.currentTime = 0;
    self.naturalSize = CGSizeZero;
    
    self.var_volumeSlider = nil;
    self.var_avplayerTimeObeserver = nil;
    
    [self cleanPlayerItem];
    [self cleanPlayer];
    
    [self.playerView destory];
}

- (void)playURL:(NSURL *)url seekToTime:(NSTimeInterval)time {
    [self destory];
    [self setupVolume];
    
    self.status = WRPlayerStatus_Loading;
    self.playingURL = url;
    self.startTimePoint = time;
    
    self.avPlayer = [self initializeAVPlayer];
}

- (void)play {
    [self.avPlayer play];
}

- (void)pause {
    [self.avPlayer pause];
}

- (void)stop {
    [self.avPlayer seekToTime:CMTimeMake(0, 1)];
    [self.avPlayer pause];
    self.status = WRPlayerStatus_Stop;
    
    [self destory];
}

- (void)setSuperView:(UIView *)superView {
    self.playerView.containerView = superView;
}

- (void)setContainerColor:(UIColor *)color {
    self.playerView.backgroundColor = color;
}

//MARK: - Private
- (void)cleanPlayerItem {
    if (self.avPlayerItem) {
        [self removePlayerItemObservers:self.avPlayerItem];
        self.avPlayerItem = nil;
    }
}

- (void)cleanPlayer {
    if (self.avPlayer) {
        [self removePlayerObservers:self.avPlayer];
        [self.avPlayer replaceCurrentItemWithPlayerItem:nil];
        self.avPlayer = nil;
    }
}

- (AVPlayer *)initializeAVPlayer {
    AVPlayerItem *item = [self initializeAVPlayerItem];
    
    AVPlayer *player = AVPlayer.new;
    player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    [player replaceCurrentItemWithPlayerItem:item];
    self.avPlayerItem = item;
    
    [self addPlayerObservers:player];
    
    [self.playerView setupPlayer:player];
    
    return player;
}

- (AVPlayerItem *)initializeAVPlayerItem {
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:self.playingURL];
    PLAYER_WEAKSELF
    [item seekToTime:CMTimeMake(self.startTimePoint, 1) completionHandler:^(BOOL finished) {
        [playerWeakSelf initializeTimeWithItem:item withLoadedAsset:NO];
    }];
    [self addPlayerItemObservers:item];
    
    return item;
}

- (void)setupVolume {
    self.var_volumeSlider = nil;
    MPVolumeView *view = MPVolumeView.new;
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"MPVolumeSlider")]) {
            self.var_volumeSlider = (UISlider *)subview;
            break;
        }
    }
}

//MARK: - Item Info
- (void)initializeTimeWithItem:(AVPlayerItem *)item withLoadedAsset:(BOOL)loadedAsset {
    self.duration = CMTimeGetSeconds(loadedAsset ? item.asset.duration : item.duration);
    if (isnan(self.duration)) {
        self.duration = 0;
    }
    self.currentTime = CMTimeGetSeconds(item.currentTime);
    if (loadedAsset) {
        NSArray *tracks = [item.asset tracksWithMediaType:AVMediaTypeVideo];
        if (tracks.count > 0) {
            AVAssetTrack *track = tracks.firstObject;
            if (track != nil) {
                self.naturalSize = track.naturalSize;
            }
        }
    }
}

//MARK: - Get & Set
- (void)setStatus:(WRPlayerStatus)status {
    if (status == _status) {
        return;
    }
    _status = status;
    if ([self.delegate respondsToSelector:@selector(playerStatusDidChanged:)]) {
        [self.delegate playerStatusDidChanged:self];
    }
}

//MARK: - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:AVPlayerItem.class]) {
        [self observePlayerItem:object forKeyPath:keyPath change:change];
    } else if ([object isKindOfClass:AVPlayer.class]) {
        [self observePlayer:object forKeyPath:keyPath change:change];
    }
}

- (void)observePlayerItem:(AVPlayerItem *)item forKeyPath:(NSString *)keyPath change:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change valueForKey:@"new"] intValue];
        WRPlayerStatus playerStatus = WRPlayerStatus_None;
        NSError *error = nil;
        
        switch (status) {
            case AVPlayerStatusUnknown:
                
                break;
            case AVPlayerStatusReadyToPlay:
                [self initializeTimeWithItem:item withLoadedAsset:YES];
                playerStatus = WRPlayerStatus_Ready;
                break;
            case AVPlayerStatusFailed:
                playerStatus = WRPlayerStatus_Failed;
                error = item.error;
                break;
        }
        self.status = playerStatus;

    }
}

- (void)observePlayer:(AVPlayer *)avPlayer forKeyPath:(NSString *)keyPath change:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    if ([keyPath isEqualToString:@"rate"]) {
        CGFloat rate = [[change valueForKey:@"new"] floatValue];
        self.status = rate == 0 ? WRPlayerStatus_Paused : WRPlayerStatus_Playing;
    }
//    if ([keyPath isEqualToString:@"timeControlStatus"]) {
//        WRPlayerStatus playerStatus = WRPlayerStatus_None;
//        switch (avPlayer.timeControlStatus) {
//            case AVPlayerTimeControlStatusPaused:
//                playerStatus = WRPlayerStatus_Paused;
//                break;
//            case AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate:
//                playerStatus = WRPlayerStatus_Loading;
//                break;
//            case AVPlayerTimeControlStatusPlaying:
//                playerStatus = WRPlayerStatus_Playing;
//                break;
//        }
//        self.status = playerStatus;
//    }
}

//MARK: - AVPlayerItem
- (void)addPlayerItemObservers:(AVPlayerItem *)playerItem {
    [playerItem addObserver:self forKeyPath:NSStringFromSelector(@selector(status)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [playerItem addObserver:self forKeyPath:NSStringFromSelector(@selector(loadedTimeRanges)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(notifyPlayerItemPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(notifyPlayerItemFailedToEndTime:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
}

- (void)removePlayerItemObservers:(AVPlayerItem *)playerItem {
    [playerItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(status)) context:nil];
    [playerItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(loadedTimeRanges)) context:nil];
    
    [NSNotificationCenter.defaultCenter removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
}

- (void)notifyPlayerItemPlayToEndTime:(NSNotification *)notification {
    self.status = WRPlayerStatus_End;
}

- (void)notifyPlayerItemFailedToEndTime:(NSNotification *)notification {
}

//MARK: - AVPlayer
- (void)addPlayerObservers:(AVPlayer *)player {
    [player addObserver:self forKeyPath:NSStringFromSelector(@selector(timeControlStatus)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [player addObserver:self forKeyPath:NSStringFromSelector(@selector(rate)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    [self addPlayTimeObservers:player];
}

- (void)removePlayerObservers:(AVPlayer *)player {
    [player removeObserver:self forKeyPath:NSStringFromSelector(@selector(timeControlStatus)) context:nil];
    [player removeObserver:self forKeyPath:NSStringFromSelector(@selector(rate)) context:nil];

    [self removePlayTimeObservers:player];
}

- (void)addPlayTimeObservers:(AVPlayer *)player {
    PLAYER_WEAKSELF
    self.var_avplayerTimeObeserver = [player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (player.currentItem == nil) {
            return;
        }
        playerWeakSelf.currentTime = CMTimeGetSeconds(playerWeakSelf.avPlayerItem.currentTime);
        
        if ([playerWeakSelf.delegate respondsToSelector:@selector(playerPlayTimeDidChanged:)]) {
            [playerWeakSelf.delegate playerPlayTimeDidChanged:playerWeakSelf];
        }
    }];
}

- (void)removePlayTimeObservers:(AVPlayer *)player {
    
}

@end
