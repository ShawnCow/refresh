//
//  UIScrollView+XXPullToRefresh.h
//  XXKit
//
//  Created by Shawn on 2015/5/19.
//  Copyright © 2015年 XXKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXPullToRefreshDefine.h"

@interface UIScrollView (XXPullToRefresh)

#pragma mark - header;

@property (nonatomic, readonly) UIView<XXPullToRefreshProtocol> * headerRefreshView;

@property (nonatomic, readonly) XXPullToRefreshViewState headerPullRefreshState;

- (void)addHeaderRefreshWithTarget:(id)target action:(SEL)action;

- (void)addHeaderRefreshWithView:(UIView<XXPullToRefreshProtocol> *)view target:(id)target action:(SEL)action;

- (void)addHeaderRefreshWithCompletion:(XXPullToRefreshCompletion)completion;

- (void)addHeaderRefreshWithView:(UIView<XXPullToRefreshProtocol> *)view completion:(XXPullToRefreshCompletion)completion;

- (void)headerBeginRefresh;

- (void)headerEndRefreshOnSuccess:(BOOL)success;

- (void)removeHeaderRefresh;

#pragma mark - footer

@property(nonatomic, readonly) UIView<XXPullToRefreshProtocol> * footerRefreshView;

@property (nonatomic, readonly) XXPullToRefreshViewState footerPullRefreshState;

- (void)addFooterRefreshWithTarget:(id)target action:(SEL)action;

- (void)addFooterRefreshWithView:(UIView<XXPullToRefreshProtocol>*)view target:(id)target action:(SEL)action;

- (void)addFooterRefreshWithCompletion:(XXPullToRefreshCompletion)completion;

- (void)addFooterRefreshWithView:(UIView<XXPullToRefreshProtocol> *)view completion:(XXPullToRefreshCompletion)completion;

- (void)footerBeginRefresh;

- (void)footerEndRefreshOnSuccess:(BOOL)success;

- (void)removeFooterRefresh;

@end

@interface UIScrollView (PullToRefreshDeprecated)

- (void)addHeaderRefreshViewClass:(Class)viewClass target:(id)target action:(SEL)action DEPRECATED_MSG_ATTRIBUTE("init view by developer and use addHeaderRefreshWithView:target:action");

- (void)addHeaderRefreshViewClass:(Class)viewClass completion:(XXPullToRefreshCompletion)completion DEPRECATED_MSG_ATTRIBUTE("init view by developer and use addHeaderRefreshWithView:completion");

- (void)addFooterRefreshViewClass:(Class)viewClass target:(id)target action:(SEL)action DEPRECATED_MSG_ATTRIBUTE("init view by developer and use addFooterRefreshWithView:target:action");

- (void)addFooterRefreshViewClass:(Class)viewClass completion:(XXPullToRefreshCompletion)completion  DEPRECATED_MSG_ATTRIBUTE("init view by developer and use addFooterRefreshWithCompletion:completion");;

@end
