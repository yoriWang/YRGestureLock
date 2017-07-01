//
//  YRGestureView.m
//  YRGestureLock
//
//  Created by 王煜仁 on 2017/4/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "YRGestureView.h"

CGFloat const btnCount = 9;
CGFloat const btnW = 74;
CGFloat const btnH = 74;
CGFloat const viewY = 200;
int const columnCount = 3;
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface YRGestureView ()
@property (nonatomic, strong) NSMutableArray *selectedBtnArray;//存放被选中的按钮的数组
@property (nonatomic, assign) CGPoint currentPoint;
@end

@implementation YRGestureView

- (NSMutableArray *)selectedBtnArray {
    
    if (!_selectedBtnArray) {
        self.selectedBtnArray = [[NSMutableArray alloc] init];
    }
    return _selectedBtnArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addButton];
    }
    return self;
}

//按钮布局
- (void)addButton {
    
    CGFloat height = 0;
    for (int i = 0; i < btnCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 1;
        btn.layer.cornerRadius = btnW / 2;
        //设置默认的图片
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_selected"] forState:UIControlStateNormal];
        //关闭用户的手势交互
        btn.userInteractionEnabled = NO;
        //设置选中的图片
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_normal"] forState:UIControlStateSelected];
        //九宫格布局
        int row = i / columnCount;//第几行
        int col = i % columnCount;//第几列
//        NSLog(@"手势view的frame为--->%@", NSStringFromCGRect(self.frame));
        //边距
        CGFloat margin = (kScreenWidth - columnCount * btnW) / (columnCount + 1);
        //计算X轴
        CGFloat btnX = margin + col * (btnW + margin);
        //计算Y轴
        CGFloat btnY = row * (btnW + margin);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        height = btnH + btnY;
//        btn.backgroundColor = [UIColor grayColor];
        [self addSubview:btn];
    }
    self.frame = CGRectMake(0, viewY, kScreenWidth, height);
    
}

#pragma mark - 私有方法
- (CGPoint)pointWithTouch:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return point;
}

- (UIButton *)buttonWithPoint:(CGPoint)point {
    
    for (UIButton *btn in self.subviews) {
        //
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}

#pragma mark - 触摸的方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取触摸的点
    CGPoint point = [self pointWithTouch:touches];
    //根据触摸的点拿到按钮
    UIButton *btn = [self buttonWithPoint:point];
    //设置按钮状态
    if (btn && !btn.selected) {
        btn.selected = YES;
        [self.selectedBtnArray addObject:btn];//往数组或者字典中添加对象的时候，要判断这个对象是否存在
    } else {
        NSLog(@"你没有触摸到按钮");
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取触摸的点
    CGPoint point = [self pointWithTouch:touches];
    //根据触摸的点拿到按钮
    UIButton *btn = [self buttonWithPoint:point];
    //设置按钮状态
    if (btn && !btn.selected) {
        btn.selected = YES;
        [self.selectedBtnArray addObject:btn];//往数组或者字典中添加对象的时候，要判断这个对象是否存在
    } else {
        self.currentPoint = point;
    }
    [self setNeedsDisplay];//当视图发生变化后，调用drawRect方法
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_selectedBtnArray.count == 0) return;
    
    if ([self.delegate respondsToSelector:@selector(gestureView:didFinishPath:)]) {
        NSMutableString *path = [NSMutableString string];
        for (UIButton *btn in self.selectedBtnArray) {
            [path appendFormat:@"%ld", (long)btn.tag];
        }
        [self.delegate gestureView:self didFinishPath:path];
    }
    
    //清空按钮的选中状态
    //makeObjectsPerformSelector 向数组内的每一个对象发送方法 setSelected: 方法参数为NO
    [self.selectedBtnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(UIButton *)obj setSelected:NO];
    }];
//    [self.selectedBtnArray makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    //清空数组
    [self.selectedBtnArray removeAllObjects];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
#pragma mark - 绘图
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.selectedBtnArray.count == 0) {
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 8.f;
    path.lineJoinStyle = kCGLineJoinRound;
    //设置线条颜色
    [[UIColor colorWithRed:32 / 255.0 green:210 / 255.0 blue:254 / 255.0 alpha:0.5f] set];
    //遍历按钮
    for (int i = 0; i < self.selectedBtnArray.count; i++) {
        UIButton *btn = _selectedBtnArray[i];
        if (i == 0) {//设置起点
            [path moveToPoint:btn.center];
        } else {//开始连线
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:self.currentPoint];
    //画出线条
    [path stroke];
    
}

@end
