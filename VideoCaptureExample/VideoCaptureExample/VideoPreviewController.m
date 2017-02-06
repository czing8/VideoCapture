//
//  VideoPreviewController.m
//  VideoCaptureExample
//
//  Created by Vols on 2017/2/6.
//  Copyright © 2017年 vols. All rights reserved.
//

#import "VideoPreviewController.h"
#import "WKMovieRecorder.h"
#import "WKVideoConverter.h"
#import "UIImageView+PlayGIF.h"
#import "VideoPlayController.h"

#define kScreenSize     [UIScreen mainScreen].bounds.size

@interface VideoPreviewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) WKVideoConverter *converter;

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSURL *gifURL;

@property (nonatomic, strong) VideoPlayController *playVC;

@property (weak, nonatomic) IBOutlet UIImageView *preview;

@end

@implementation VideoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureViews];
    
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - setup
- (void)configureViews {
    _preview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_preview addGestureRecognizer:tapRecognizer];

    //1.生成文件名
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    NSString *name = [df stringFromDate:[NSDate date]];
    NSString *gifName = [name stringByAppendingPathExtension:@".gif"];
    NSString *videoName = [name stringByAppendingPathExtension:@".mp4"];
    
    //2.拷贝视频
    [self copyVideoWithMovieName:videoName];
    
    //3.生成gif
    _preview.contentMode = UIViewContentModeScaleAspectFill;
    _preview.layer.masksToBounds = YES;
    _preview.image = self.movieInfo[WKRecorderFirstFrame];
    [self generateAndShowGifWithName:gifName];
    
}

- (NSString *)generateMoviePathWithFileName:(NSString *)name {
    NSString *documetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *moviePath = [documetPath stringByAppendingPathComponent:name];
    
    return moviePath;
}

- (void)copyVideoWithMovieName:(NSString *)movieName {
    //1.生成视屏URL
    NSMutableString *videoName = [movieName mutableCopy];
    NSURL *videoURL = _movieInfo[WKRecorderMovieURL];
    
    [videoName stringByAppendingPathExtension:@".mp4"];
    
    [videoName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, videoName.length)];
    
    NSString *videoPath = [self generateMoviePathWithFileName:videoName];
    NSURL *newVideoURL = [NSURL fileURLWithPath:videoPath];
    NSError *error = nil;
    
    [[NSFileManager defaultManager] copyItemAtURL:videoURL toURL:newVideoURL error:&error];
    
    
    if (error) {
        
        NSLog(@"%@", [error localizedDescription]);
        
    }else{
        self.videoURL = newVideoURL;
    }
    
}

- (void)generateAndShowGifWithName:(NSString *)gifName {
    NSString *gifPath = [self generateMoviePathWithFileName:gifName];
    NSURL *newVideoURL = [NSURL fileURLWithPath:gifPath];
    
    WKVideoConverter *converter = [[WKVideoConverter alloc] init];
    
    
    [converter convertVideoToGifImageWithURL:self.videoURL destinationUrl:newVideoURL finishBlock:^{//播放gif
        _preview.gifPath = gifPath;
        [_preview startGIF];
    }];
    
    _converter = converter;
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    VideoPlayController *playVC = [[VideoPlayController alloc] init];
    playVC.movieURL = self.videoURL;
    
    [self displayChildController:playVC];
    
    _playVC = playVC;
}

#pragma mark - displayChildController
- (void) displayChildController: (UIViewController*) child {
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    child.view.frame = self.view.frame;
    [child didMoveToParentViewController:self];
}

- (void) hideContentController: (UIViewController*) child {
    [child willMoveToParentViewController:nil];
    [child.view removeFromSuperview];
    [child removeFromParentViewController];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideContentController:self.playVC];
    self.playVC = nil;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
