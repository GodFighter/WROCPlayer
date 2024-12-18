//
//  WRPlayerView.m
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/11.
//

#import "WRPlayerView.h"

#import <AVFoundation/AVFoundation.h>

#import "WRPlayerOperationView.h"

//MARK: -
@interface WRPlayerView ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) WRPlayerOperationView *operationView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation WRPlayerView

//MARK: - Life Cycle
- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero]) {
        [self addViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

//MARK: - Public
- (void)setStatus:(WRPlayerStatus)status {
    switch (status) {
        case WRPlayerStatus_None:
        case WRPlayerStatus_Playing:
        case WRPlayerStatus_Paused:
        case WRPlayerStatus_End:
        case WRPlayerStatus_Stop:
        case WRPlayerStatus_Failed:
            [self.loadingView stopAnimating];
            break;
        case WRPlayerStatus_Ready:
        case WRPlayerStatus_Loading:
            [self.loadingView startAnimating];
            break;
    }
    
    [self.operationView setStatus:status];
}

- (void)setPlaybackStatus:(WRPlaybackStatus)status {
    [self.operationView setPlaybackStatus:status];
}

- (void)destory {
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
}

- (void)setupPlayer:(AVPlayer *)player {
    [self destory];
    
    AVPlayerLayer *layer = [AVPlayerLayer new];
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    layer.frame = self.bounds;
    [layer setPlayer:player];
    [self.layer insertSublayer:layer atIndex:0];
    layer.backgroundColor = self.backgroundColor.CGColor;
    self.playerLayer = layer;
    
    if (self.containerView) {
        [self.containerView addSubview:self];
        self.frame = self.containerView.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}

- (void)setAsset:(AVAsset *)asset {
    [self.operationView setAsset:asset];
}

//MARK: - Set & Get
- (void)setContainerView:(UIView *)containerView {
    _containerView = containerView;
    if (![self.superview isKindOfClass:UIWindow.class] && self.superview != containerView) {
        [containerView addSubview:self];
        self.frame = self.containerView.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}

//MARK: - UI
- (void)addViews {
    [self addSubview:self.operationView];
    [self addSubview:self.loadingView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.operationView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
        [self.operationView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
        [self.operationView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.operationView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.loadingView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.loadingView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
    ]];
}

- (WRPlayerOperationView *)operationView {
    if (_operationView == nil) {
        _operationView = [WRPlayerOperationView new];
        _operationView.translatesAutoresizingMaskIntoConstraints = NO;
        
        __weak typeof(self) weakSelf = self;
        _operationView.operationBlock = ^(WRPlayerOperation operation, id  _Nullable var_value) {
            if (weakSelf.operationBlock) {
                weakSelf.operationBlock(operation, var_value);
            }
        };
    }
    return _operationView;
}

- (UIActivityIndicatorView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
        _loadingView.color = UIColor.whiteColor;
        _loadingView.hidesWhenStopped = YES;
    }
    return _loadingView;
}

@end
