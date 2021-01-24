//
//  "XXPullToRefreshDefine.h
//  XXKit
//
//  Created by Shawn on 2015/5/19.
//  Copyright © 2015年 XXKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XXPullToRefreshViewState) {
    XXPullToRefreshViewStateNormal = 0,    //普通状态
    XXPullToRefreshViewStatePulling,       //超过临界的下拉状态，松开就会触发刷新
    XXPullToRefreshViewStateLoading,       //加载中的状态
};

typedef NS_ENUM(NSUInteger, XXPullToRefreshViewType) {
    XXPullToRefreshViewTypeHeader = 0,
    XXPullToRefreshViewTypeFooter,
};


typedef void (^XXPullToRefreshCompletion)(UIScrollView * scrollView);

/**
 如果自定义的下拉刷新的 view 的类 需要实现这个协议 如果想降低类的关联 可以给原有的类 实现一个 category 来实现协议对应的方法
 */
@protocol XXPullToRefreshProtocol <NSObject>

@required

/**
 状态发生改变的时候回掉时候调用

 @param state 状态
 */
- (void)setPullToRefreshState:(XXPullToRefreshViewState)state;

@optional

/**
 view 的高度为多少,init 之后会回掉设置高度 如果没有实现 默认下拉刷新返回 75 上拉 50

 @return view 的高度
 */
- (CGFloat)pullToRefreshViewHeight;

/**
 下拉或者上提的时候 修改状态的阀值 比如下拉如果 scrollview 的 contentOffset.y 大于这个值就修改状态 如果不实现 默认下拉刷新是 75 上提加载更多是 50

 @return 高度
 */
- (CGFloat)pullToRefreshStateChangeOffsetHeight;

/**
 scrollview 的滚动的偏移量,如果需要根据移动的偏移量来做动画效果可以实现这个方法

 @param point scrollview contentOffset
 */
- (void)pullToRefreshScrollViewDidScrollToOffset:(CGPoint)point;

/**
 这个方法是由scrollview写的扩展方法回掉过来 比如请求结束 如果是请求成功 success 传递 YES 请求失败 succes 传递 NO

 @param success 如果是请求成功 success 传递 YES 请求失败 succes 传递 NO
 */
- (void)pullToRefreshFinishRefreshOnSuccess:(BOOL)success;


- (void)pullToRefreshManagerByScrollView:(UIScrollView *)scrollView type:(XXPullToRefreshViewType)type;

- (void)pullToRefreshUnManagerByScrollView:(UIScrollView *)scrollView type:(XXPullToRefreshViewType)type;

/**
 contentSize变化的时候回掉 可以修改footerView的 frame

 @param scrollView scrollView
 */
- (void)contentSizeDidChangeWithScrollView:(UIScrollView *)scrollView;

- (void)contentInsetDidChangeWithScrollView:(UIScrollView *)scrollView;

@end




