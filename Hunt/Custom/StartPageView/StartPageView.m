//
//  StartPageView.m
//  Hunt
//
//  Created by 杨明 on 2018/9/19.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "StartPageView.h"

@interface StartPageView ()<CAAnimationDelegate>

// 启动页图
@property (nonatomic,strong) UIImageView *imageView;
/* arr */
@property (nonatomic, strong) NSMutableArray *arrM;

@end

// 倒计时时间
static int const showtime = 2.6;

@implementation StartPageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIViewController *viewController = [[UIStoryboard
                                                 storyboardWithName:@"Launch Screen"
                                                 bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
        UIView *launchView = viewController.view;
        UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
        launchView.frame = [UIApplication sharedApplication].keyWindow.frame;
        [mainWindow addSubview:launchView];
        
        // 1.启动页图片
        self.frame = launchView.frame;
        [self addSubview:launchView];
        self.imageView = launchView.subviews.firstObject;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"StartGuide/合成 1_00073.png" ofType:nil];
        _imageView.image = [UIImage imageWithContentsOfFile:path];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        animation.duration = showtime;
        animation.repeatCount = 1;
        animation.delegate = self;
        
        //存放图片的数组
        self.arrM = [NSMutableArray array];
        for(int i = 0;i < 74 ;i++) {
            NSString *p = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"StartGuide/合成 1_000%02d.png",i] ofType:nil];
            UIImage *img = [UIImage imageWithContentsOfFile:p];
            CGImageRef cgimg = img.CGImage;
            [self.arrM addObject:(__bridge UIImage *)cgimg];
        }
        
        animation.values = self.arrM;
        
        [_imageView.layer addAnimation:animation forKey:nil];
        
    }
    return self;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
    [self removeProgress];
}

- (void)show {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

// 移除启动页面
- (void)removeProgress{
    
    
    [UIView animateWithDuration:1 animations:^{
//        self.imageView.transform = CGAffineTransformMakeScale(5, 5);
        self.imageView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.imageView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


@end
