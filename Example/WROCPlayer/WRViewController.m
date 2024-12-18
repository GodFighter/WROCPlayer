//
//  WRViewController.m
//  WROCPlayer
//
//  Created by GodFighter on 12/06/2024.
//  Copyright (c) 2024 GodFighter. All rights reserved.
//

#import "WRViewController.h"

#import "WRPlayer.h"

@interface WRViewController () <WRPlayerDelegate>

@property (nonatomic, strong) UIView *playerContainerView;
@property (nonatomic, strong) NSLayoutConstraint *height;

@end

@implementation WRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //http://vjs.zencdn.net/v/oceans.mp4
    //http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
    //http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4
    //http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4
    //http://media.w3.org/2010/05/sintel/trailer.mp4
    //
    WRPlayer.Shared.delegate = self;
    [WRPlayer.Shared setContainerColor:UIColor.whiteColor];
    [WRPlayer.Shared playURL:[NSURL URLWithString:@"http://media.w3.org/2010/05/sintel/trailer.mp4"] seekToTime:0];
    
    UIView *view = [UIView new];
    [self.view addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        self.height = [view.heightAnchor constraintEqualToConstant:300],
        [view.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [view.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];

    [WRPlayer.Shared setSuperView:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [WRPlayer.Shared stop];
    });
    
}

//MARK: -
- (void)playerPlayTimeDidChanged:(WRPlayer *)player {
//    NSLog(@"%1.0f----%1.0f", player.currentTime, player.duration);
}

- (void)playerStatusDidChanged:(WRPlayer *)player {
//    NSLog(@"player status = %ld", player.status);

    switch (player.status) {
        case WRPlayerStatus_Ready:
            [player play];
            if (!CGSizeEqualToSize(player.naturalSize, CGSizeZero)) {
                self.height.constant = UIScreen.mainScreen.bounds.size.width * player.naturalSize.height / player.naturalSize.width;
            }
            break;
            
        default:
            break;
    }
}


@end
