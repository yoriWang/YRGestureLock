//
//  MainViewController.m
//  YRGestureLock
//
//  Created by 王煜仁 on 2017/4/13.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "MainViewController.h"
#import "GestureLockViewController.h"

int const btnCount1 = 3;
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
CGFloat const btnH1 = 30.f;
CGFloat const margin1 = 15.f;


@interface MainViewController ()
@property (nonatomic, strong) NSMutableArray *btnTitleArray;
@end

@implementation MainViewController

- (NSMutableArray *)btnTitleArray {
    
    if (!_btnTitleArray) {
        self.btnTitleArray = [[NSMutableArray alloc] initWithObjects:@"创建手势密码", @"清除手势密码", @"返回", nil];
    }
    return _btnTitleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"这是主界面";
    [self setupButton];
    
}

- (void)setupButton {
    
    CGFloat btnW = kScreenWidth / 3;
    CGFloat btnX = btnW;
    CGFloat subValue = btnH1 + margin1;
    
    for (int i = 0; i < btnCount1; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        CGFloat btnY = self.view.center.y - btnH1 / 2 + (i - 1) * subValue;
        [btn setTitle:self.btnTitleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didCilckedButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH1);
        btn.layer.borderWidth = 1.f;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        [self.view addSubview:btn];
    }
    
}

- (void)didCilckedButton:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0: {//设置手势
            GestureLockViewController *glVC = [[GestureLockViewController alloc] init];
            [self.navigationController pushViewController:glVC animated:YES];
            break;
        }
        case 1: {//清除手势
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"yrLock"];
            [defaults synchronize];
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"手势清除成功" preferredStyle:UIAlertControllerStyleAlert];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertControl animated:YES completion:nil];
            break;
        }
        case 2://返回
            
            break;
        
        default:
            break;
    }
    
}

@end
