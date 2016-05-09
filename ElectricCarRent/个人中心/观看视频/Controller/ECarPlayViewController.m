//
//  ECarPlayViewController.m
//  ElectricCarRent
//
//  Created by 彭懂 on 16/2/18.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "ECarPlayViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ECarPlayViewController () <AVPlayerViewControllerDelegate>

@property (nonatomic, strong) AVPlayerViewController * playerController;
@property (nonatomic, strong) AVPlayer               * player;
@property (nonatomic, strong) AVAudioSession         * session;
@property (nonatomic, strong) NSString               * urlString;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end
/**
 可播放：AVPlayerItemNewAccessLogEntryNotification
 暂停了：AVPlayerItemPlaybackStalledNotification
 */
@implementation ECarPlayViewController

- (instancetype)initWithURLString:(NSString *)url
{
    self = [super init];
    if (self) {
        self.urlString = url;
    }
    return self;
}

- (void)dealloc
{
//    [self removeObserver:self forKeyPath:@"AVPlayerItemNewAccessLogEntryNotification"];
//    [self removeObserver:self forKeyPath:@"AVPlayerItemPlaybackStalledNotification"];
    [self.player removeObserver:self forKeyPath:@"status" context:nil];
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.frame = CGRectMake(0, 0, 200, 200);
        _activityView.center = self.view.center;
    }
    return _activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNotification];
    [self createPlayerView];
}

- (void)createNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStalledNotification) name:@"AVPlayerItemPlaybackStalledNotification" object:nil];
}

- (void)playbackStalledNotification
{
    [self.activityView startAnimating];
    __block AVPlayer *weekPlayer = self.player;
    weak_Self(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weekPlayer play];
        [weakSelf.activityView stopAnimating];
    });
}

- (void)createPlayerView
{
    self.session = [AVAudioSession sharedInstance];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.urlString]];
    self.playerController = [[AVPlayerViewController alloc] init];
    self.playerController.player = self.player;
    self.playerController.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerController.delegate = self;
    self.playerController.allowsPictureInPicturePlayback = YES;    // 是否允许双层播放
    self.playerController.showsPlaybackControls = YES;
    self.playerController.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.playerController.view.frame = self.view.bounds;
    [self.view addSubview:self.playerController.view];
    [self addChildViewController:self.playerController];
    [self.playerController willMoveToParentViewController:self];
    [self.parentViewController didMoveToParentViewController:self];
    [self.playerController.player play];
    
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
    
    [self.player addObserver:self
               forKeyPath:@"status"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayer *playerItem = (AVPlayer*)object;
        if (playerItem.status == AVPlayerStatusReadyToPlay) {
            [self.activityView stopAnimating];
        }
    }
}

#pragma mark - AVPlayerViewControllerDelegate
- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController {
    return true;
}

@end
