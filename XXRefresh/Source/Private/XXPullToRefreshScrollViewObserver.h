//
//  XXPullToRefreshScrollViewObserver.h
//  XXKit
//
//  Created by Shawn on 2015/5/19.
//  Copyright © 2015年 XXKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXPullToRefreshDefine.h"

@class UIScrollView;
@class XXPullToRefreshItem;

@interface XXPullToRefreshScrollViewObserver : NSObject

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

@property (nonatomic, readonly, unsafe_unretained) UIScrollView * scrollView;

@property (nonatomic, readonly) XXPullToRefreshItem * headerRefreshItem;

@property (nonatomic, readonly) XXPullToRefreshItem * footerRefreshItem;

#pragma mark - 

- (void)headerBeginRefresh;

- (void)headerEndRefreshOnSuccess:(BOOL)success;

- (void)footerBeginRefresh;

- (void)footerEndRefreshOnSuccess:(BOOL)success;

#pragma mark -

- (void)checkAndInvokeHeaderManagerMethod;

- (void)removeHeaderRefresh;

- (void)checkAndInvokeFooterManagerMethod;

- (void)removeFooterRefresh;

@end

@interface XXPullToRefreshItem : NSObject

- (instancetype)initWithObserver:(XXPullToRefreshScrollViewObserver *)observer;

@property (nonatomic, readonly, weak) XXPullToRefreshScrollViewObserver * observer;

@property (nonatomic, weak) id target;

@property (nonatomic) SEL action;

@property (nonatomic, weak) UIView<XXPullToRefreshProtocol> * view;

@property (nonatomic, copy) XXPullToRefreshCompletion completion;

@property (nonatomic) XXPullToRefreshViewState currentState;

- (void)invocationRefreshAction;

@end
