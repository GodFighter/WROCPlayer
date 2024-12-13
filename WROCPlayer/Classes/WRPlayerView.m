//
//  WRPlayerView.m
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/11.
//

#import "WRPlayerView.h"

#import <AVFoundation/AVPlayerLayer.h>

#import "WRPlayerOperationView.h"
//#import "UIImage+WRPlayer.h"

//MARK: -
@interface WRPlayerView ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) WRPlayerOperationView *operationView;

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
    
    [NSLayoutConstraint activateConstraints:@[
        [self.operationView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
        [self.operationView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
        [self.operationView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.operationView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
}

- (WRPlayerOperationView *)operationView {
    if (_operationView == nil) {
        _operationView = [WRPlayerOperationView new];
        _operationView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _operationView;
}

@end
