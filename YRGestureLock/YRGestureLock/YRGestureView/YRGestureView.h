//
//  YRGestureView.h
//  YRGestureLock
//
//  Created by 王煜仁 on 2017/4/11.
//  Copyright © 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YRGestureView;

@protocol YRGestureViewDelegate <NSObject>

@optional
- (void)gestureView:(YRGestureView *)gestureView didFinishPath:(NSString *)path;

@end

@interface YRGestureView : UIView
@property (nonatomic, assign) id<YRGestureViewDelegate> delegate;
@end
