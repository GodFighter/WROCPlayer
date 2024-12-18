//
//  WRPlayerOperationView.m
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/12.
//

#import "WRPlayerOperationView.h"

#import "UIImage+WRPlayer.h"
#import "AVAsset+WRPlayer.h"

#define TOOL_BAR_HEIGHT 44.0
#define TOOL_BAR_ITEM_SPACING 10.0

//MARK: -
@interface WRPlayerOperationView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *topToolView;
@property (nonatomic, strong) UIView *bottomToolView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UIButton *playButton;

@end

@implementation WRPlayerOperationView

//MARK: - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        [self addViews];
    }
    return self;
}

//MARK: - Public
- (void)setStatus:(WRPlayerStatus)status {
    switch (status) {
        case WRPlayerStatus_Playing:
            break;
        case WRPlayerStatus_None:
        case WRPlayerStatus_Paused:
        case WRPlayerStatus_End:
        case WRPlayerStatus_Stop:
        case WRPlayerStatus_Failed:
            break;
        case WRPlayerStatus_Ready:
        case WRPlayerStatus_Loading:
            break;
    }
}

- (void)setPlaybackStatus:(WRPlaybackStatus)status {
    switch (status) {
        case WRPlaybackStatus_Playing:
            [self updatePlayButton:NO];
            break;
        case WRPlaybackStatus_Pause:
            [self updatePlayButton:YES];
            break;
    }
}

- (void)setAsset:(AVAsset *)asset {
    self.titleLabel.text = asset.wr_title;
}

- (void)setPlaying:(BOOL)isPlaying {
    self.playButton.selected = isPlaying;
    [self updatePlayButton:!self.playButton.selected];
}

//MARK: - Action
- (void)actionBack:(UIButton *)sender {
    if (self.operationBlock) {
        self.operationBlock(WRPlayerOperation_Back, nil);
    }
}

- (void)actionShare:(UIButton *)sender {
    if (self.operationBlock) {
        self.operationBlock(WRPlayerOperation_Share, nil);
    }
}

- (void)actionPlay:(UIButton *)sender {
    if (self.operationBlock) {
        self.operationBlock(WRPlayerOperation_Play, @(sender.selected));
    }
}

//MARK: - UI
- (void)addViews {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.topToolView];
    [self.containerView addSubview:self.bottomToolView];
    
    [self.containerView addSubview:self.backButton];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.shareButton];
    
    [self.containerView addSubview:self.playButton];
    [self updatePlayButton:YES];

    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
        [self.containerView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
        [self.containerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.topToolView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
        [self.topToolView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.containerView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
        [self.topToolView.heightAnchor constraintEqualToConstant:TOOL_BAR_HEIGHT],
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.bottomToolView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
        [self.bottomToolView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.bottomToolView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
        [self.bottomToolView.heightAnchor constraintEqualToConstant:TOOL_BAR_HEIGHT],
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.backButton.topAnchor constraintEqualToAnchor:self.topToolView.topAnchor],
        [self.backButton.bottomAnchor constraintEqualToAnchor:self.topToolView.bottomAnchor],
        [self.backButton.leadingAnchor constraintEqualToAnchor:self.topToolView.safeAreaLayoutGuide.leadingAnchor constant:TOOL_BAR_ITEM_SPACING],
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.topToolView.centerYAnchor],
        [self.titleLabel.leftAnchor constraintEqualToAnchor:self.backButton.rightAnchor constant:TOOL_BAR_ITEM_SPACING],
    ]];

    [NSLayoutConstraint activateConstraints:@[
        [self.shareButton.topAnchor constraintEqualToAnchor:self.topToolView.topAnchor],
        [self.shareButton.bottomAnchor constraintEqualToAnchor:self.topToolView.bottomAnchor],
        [self.shareButton.trailingAnchor constraintEqualToAnchor:self.topToolView.safeAreaLayoutGuide.trailingAnchor constant:-TOOL_BAR_ITEM_SPACING],
    ]];

    [NSLayoutConstraint activateConstraints:@[
        [self.playButton.topAnchor constraintEqualToAnchor:self.bottomToolView.topAnchor],
        [self.playButton.bottomAnchor constraintEqualToAnchor:self.bottomToolView.bottomAnchor],
        [self.playButton.leadingAnchor constraintEqualToAnchor:self.bottomToolView.safeAreaLayoutGuide.leadingAnchor constant:TOOL_BAR_ITEM_SPACING],
    ]];

}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [UIView new];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
        _containerView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        
    }
    return _containerView;
}

- (UIView *)topToolView {
    if (_topToolView == nil) {
        _topToolView = [UIView new];
        _topToolView.translatesAutoresizingMaskIntoConstraints = NO;

        UIColor *begin = [UIColor.blackColor colorWithAlphaComponent:0.5];
        UIColor *end = [UIColor.blackColor colorWithAlphaComponent:0];
        [self addToolBackgroundImageViewWithColors:@[begin, end] forView:_topToolView];

    }
    return _topToolView;
}

- (UIView *)bottomToolView {
    if (_bottomToolView == nil) {
        _bottomToolView = [UIView new];
        _bottomToolView.translatesAutoresizingMaskIntoConstraints = NO;

        UIColor *begin = [UIColor.blackColor colorWithAlphaComponent:0];
        UIColor *end = [UIColor.blackColor colorWithAlphaComponent:0.5];
        [self addToolBackgroundImageViewWithColors:@[begin, end] forView:_bottomToolView];
        
    }
    return _bottomToolView;
}

- (UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_backButton setImage:[UIImage WR_SystemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}

- (UIButton *)shareButton {
    if (_shareButton == nil) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_shareButton setImage:[UIImage WR_SystemImageNamed:@"square.and.arrow.up"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(actionShare:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIButton *)playButton {
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_playButton setImage:[UIImage WR_SystemImageNamed:@"play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(actionPlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (void)updatePlayButton:(BOOL)isPlay {
    UIImage *playImage = [UIImage WR_SystemImageNamed:isPlay ? @"play" : @"pause"];
    [self.playButton setImage:playImage forState:UIControlStateNormal];
}

- (void)addToolBackgroundImageViewWithColors:(NSArray *)colors forView:(UIView *)view {
    UIImage *image = [UIImage WR_GradientImageWithColors:colors andSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width, TOOL_BAR_HEIGHT) andLocations:@[@0, @1] andStart:CGPointZero andEnd:CGPointMake(0, 1)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [imageView.leftAnchor constraintEqualToAnchor:view.leftAnchor],
        [imageView.topAnchor constraintEqualToAnchor:view.topAnchor],
        [imageView.widthAnchor constraintEqualToAnchor:view.widthAnchor],
        [imageView.heightAnchor constraintEqualToAnchor:view.heightAnchor],
    ]];
}

@end
