//
//  GestureLockViewController.m
//  YRGestureLock
//
//  Created by 王煜仁 on 2017/4/13.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "GestureLockViewController.h"
#import "YRGestureView.h"

@interface GestureLockViewController ()<YRGestureViewDelegate>
@property (nonatomic, strong) NSMutableArray *gestureKeyArray;//存放两次手势密码，便于比较
@end

@implementation GestureLockViewController

- (NSMutableArray *)gestureKeyArray {
    
    if (!_gestureKeyArray) {
        self.gestureKeyArray = [[NSMutableArray alloc] init];
    }
    return _gestureKeyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置手势密码";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lockImage.jpg"]];
    YRGestureView *yrView = [[YRGestureView alloc] init];
    yrView.delegate = self;
    yrView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:yrView];
}

#pragma mark - YRGestureView Delegate
- (void)gestureView:(YRGestureView *)gestureView didFinishPath:(NSString *)path {
    
    [self.gestureKeyArray addObject:path];
    if (self.gestureKeyArray.count == 2) {
        NSString *key1 = _gestureKeyArray[0];
        NSString *key2 = _gestureKeyArray[1];
        if ([key1 isEqualToString:key2]) {
            
            [self alertViewWithTitle:@"提示" message:@"设置成功" block:^{
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:path forKey:@"yrLock"];
                [defaults synchronize];
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        } else {
            [self alertViewWithTitle:@"提示" message:@"你输入的与上一次不一致，请重新设置" block:^{}];
            [self.gestureKeyArray removeLastObject];
        }
    } else if (self.gestureKeyArray.count == 1) {
        [self alertViewWithTitle:@"提示" message:@"请再一次设置" block:^{}];
    }
}

- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message block:(void(^)())block{
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    
    [alertControl addAction:confirmAction];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}

@end
