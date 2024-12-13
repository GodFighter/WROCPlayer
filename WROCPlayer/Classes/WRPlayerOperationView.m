//
//  WRPlayerOperationView.m
//  WROCPlayer
//
//  Created by 项辉 on 2024/12/12.
//

#import "WRPlayerOperationView.h"

#import "UIImage+WRPlayer.h"

//MARK: -
@interface WRPlayerOperationView ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation WRPlayerOperationView

//MARK: - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        [self addViews];
    }
    return self;
}

//MARK: - UI
- (void)addViews {
    [self addSubview:self.containerView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
        [self.containerView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
        [self.containerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _containerView;
}


@end
