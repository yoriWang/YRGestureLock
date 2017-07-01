//
//  ViewController.m
//  YRGestureLock
//
//  Created by 王煜仁 on 2017/4/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "ViewController.h"
#import "YRGestureView.h"
#import "MainViewController.h"

@interface ViewController ()<YRGestureViewDelegate> {
    NSString *_gestureKey;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lockImage2.jpg"]];
    _gestureKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"yrLock"];
    
    YRGestureView *yrView = [[YRGestureView alloc] init];
    yrView.delegate = self;
    yrView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:yrView];
}

- (void)gestureView:(YRGestureView *)gestureView didFinishPath:(NSString *)path {
    NSLog(@"绘制锁屏图案的密码为:---->%@", path);
    
    if ([path isEqualToString:_gestureKey]) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码正确" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            MainViewController *mainVC = [[MainViewController alloc] init];
            mainVC.view.backgroundColor = [UIColor whiteColor];
            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
//            mainVC.title = @"解锁后的主界面";
//            [self presentViewController:naVC animated:YES completion:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = naVC;
        }];
        
        [alertControl addAction:confirmAction];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    } else {
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码错误" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}


@end
