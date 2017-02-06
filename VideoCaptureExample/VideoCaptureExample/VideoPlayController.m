//
//  VideoPlayController.m
//  VideoCaptureExample
//
//  Created by Vols on 2017/2/6.
//  Copyright © 2017年 vols. All rights reserved.
//

#import "VideoPlayController.h"
#import "WKMovieRecorder.h"
#import "WKVideoConverter.h"

#define kScreenSize     [UIScreen mainScreen].bounds.size

@interface VideoPlayController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation VideoPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = kScreenSize.width;
    CGFloat Height = width / 4 * 3;
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.movieURL];
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer: player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.frame = CGRectMake(0, 0, kScreenSize.width, Height);
    playerLayer.position = self.view.center;
    [self.view.layer addSublayer: playerLayer];
    [playerLayer setNeedsDisplay];
    [player play];
    self.player = player;
    _playerLayer = playerLayer;
    
    self.view.backgroundColor = [UIColor blackColor];
    __weak typeof(self) weakSelf = self;
    NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
    [noteCenter addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                            object:nil
                             queue:nil
                        usingBlock:^(NSNotification *note) {
                            [weakSelf.player seekToTime:kCMTimeZero];
                            [weakSelf.player play];
                        }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
