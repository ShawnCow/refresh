//
//  UIScrollView+XXPullToRefresh.m
//  XXKit
//
//  Created by Shawn on 2015/5/19.
//  Copyright © 2015年 XXKit. All rights reserved.
//

#import "UIScrollView+XXPullToRefresh.h"
#import "XXPullToRefreshScrollViewObserver.h"
#import <objc/runtime.h>

@interface XXPullToRerefreshTapGestureRecognizer : UITapGestureRecognizer

@end

@implementation XXPullToRerefreshTapGestureRecognizer

@end

@implementation UIScrollView (XXPullToRefresh)

#pragma mark - XXPullToRefreshObserver

static const char * XXScrollViewObserverKey            = "XXScrollViewObserverKey";

- (XXPullToRefreshScrollViewObserver *)scrollViewObserverInitIfNeed:(BOOL)need{
    
    XXPullToRefreshScrollViewObserver * observer =  objc_getAssociatedObject(self, &XXScrollViewObserverKey);
    if (observer == nil && need) {
        observer = [[XXPullToRefreshScrollViewObserver alloc]initWithScrollView:self];
        objc_setAssociatedObject(self, &XXScrollViewObserverKey, observer, OBJC_ASSOCIATION_RETAIN);
    }
    return observer;
}

#pragma mark -  Public Api

- (void)addHeaderRefreshWithView:(UIView<XXPullToRefreshProtocol> *)view target:(id)target action:(SEL)action
{
    XXPullToRefreshScrollViewObserver *observer = [self scrollViewObserverInitIfNeed:YES];
    observer.headerRefreshItem.target = target;
    observer.headerRefreshItem.action = action;
    observer.headerRefreshItem.view = view;
    [observer checkAndInvokeHeaderManagerMethod];
}

- (void)addHeaderRefreshWithTarget:(id)target action:(SEL)action
{
    XXPullToRefreshScrollViewObserver *observer = [self scrollViewObserverInitIfNeed:NO];
    XXPullToRefreshItem *headerItem = observer.headerRefreshItem;
    UIView<XXPullToRefreshProtocol> *view = headerItem.view;
    if (view == nil) {
        view = [NSClassFromString(@"XXPullToRefreshView") new];
    }
    [self addHeaderRefreshWithView:view target:target action:action];
}

- (void)addHeaderRefreshWithView:(UIView<XXPullToRefreshProtocol> *)view completion:(XXPullToRefreshCompletion)completion
{
    XXPullToRefreshScrollViewObserver *observer = [self scrollViewObserverInitIfNeed:YES];
    XXPullToRefreshItem *headerItem = observer.headerRefreshItem;
    headerItem.completion = completion;
    headerItem.view = view;
    [observer checkAndInvokeHeaderManagerMethod];
}

- (void)addHeaderRefreshWithCompletion:(XXPullToRefreshCompletion)completion
{
    XXPullToRefreshScrollViewObserver *observer = [self scrollViewObserverInitIfNeed:NO];
    XXPullToRefreshItem *headerItem = observer.headerRefreshItem;
    UIView<XXPullToRefreshProtocol> *view = headerItem.view;
    if (view == nil) {
        view = [NSClassFromString(@"XXPullToRefreshView") new];
    }
    [self addHeaderRefreshWithView:view completion:completion];
}

- (void)headerBeginRefresh
{
    [[self scrollViewObserverInitIfNeed:NO]headerBeginRefresh];
}

- (void)headerEndRefreshOnSuccess:(BOOL)success
{
    XXPullToRefreshScrollViewObserver * observer = [self scrollViewObserverInitIfNeed:NO];
    [observer headerEndRefreshOnSuccess:success];
}

- (void)removeHeaderRefresh
{
    XXPullToRefreshScrollViewObserver * observer = [self scrollViewObserverInitIfNeed:NO];
    [observer removeHeaderRefresh];
}

- (UIView<XXPullToRefreshProtocol> *)headerRefreshView
{
    return [[[self scrollViewObserverInitIfNeed:NO]headerRefreshItem]view];
}

- (XXPullToRefreshViewState)headerPullRefreshState
{
    return [[[self scrollViewObserverInitIfNeed:NO] headerRefreshItem] currentState];
}

#pragma mark - footer

- (void)addFooterRefreshWithView:(UIView<XXPullToRefreshProtocol> *)view target:(id)target action:(SEL)action
{
    XXPullToRefreshScrollViewObserver *observer = [self scrollViewObserverInitIfNeed:YES];
    observer.footerRefreshItem.target = target;
    observer.footerRefreshItem.action = action;
    observer.footerRefreshItem.view = view;
    [observer checkAndInvokeFooterManagerMethod];
}

- (void)addFooterRefreshWithTarget:(id)target action:(SEL)action
{
    XXPullToRefreshScrollViewObserver *observer = [self scrollViewObserverInitIfNeed:NO];
    XXPullToRefreshItem *footerItem = observer.footerRefreshItem;
    UIView<XXPullToRefreshProtocol> *view = footerItem.view;
    if (view == nil) {
        view = [NSClassFromString(@"XXLoadMoreFooterView") new];
    }
    [self addFooterRefreshWithView:view target:target action:action];
}

- (void)addFooterRefreshWithCompletion:(XXPullToRefreshCompletion)completion
{
    XXPullToRefreshScrollViewObserver *observer = [self scrollViewObserverInitIfNeed:NO];
    XXPullToRefreshItem *footerItem = observer.footerRefreshItem;
    UIView<XXPullToRefreshProtocol> *view = footerItem.view;
    if (view == nil) {
        view = [NSClassFromString(@"XXLoadMoreFooterView") new];
    }
    [self addFooterRefreshWithView:view completion:completion];
}

- (void)addFooterRefreshWithView:(UIView<XXPullToRefreshProtocol> *)view completion:(XXPullToRefreshCompletion)completion
{
    XXPullToRefreshScrollViewObserver *observer = [self scrollViewObserverInitIfNeed:YES];
    XXPullToRefreshItem *footerItem = observer.footerRefreshItem;
    footerItem.completion = completion;
    footerItem.view = view;
    [observer checkAndInvokeFooterManagerMethod];
}

- (void)footerEndRefreshOnSuccess:(BOOL)success
{
    XXPullToRefreshScrollViewObserver * observer = [self scrollViewObserverInitIfNeed:YES];
    [observer footerEndRefreshOnSuccess:success];
}

- (void)footerBeginRefresh
{
    [[self scrollViewObserverInitIfNeed:NO]footerBeginRefresh];
}

- (void)removeFooterRefresh
{
    XXPullToRefreshScrollViewObserver * observer = [self scrollViewObserverInitIfNeed:YES];
    [observer removeFooterRefresh];
}

- (UIView<XXPullToRefreshProtocol> *)footerRefreshView
{
    return [[[self scrollViewObserverInitIfNeed:NO]footerRefreshItem]view];
}

- (XXPullToRefreshViewState)footerPullRefreshState
{
    return [[[self scrollViewObserverInitIfNeed:NO] footerRefreshItem] currentState];
}

@end

@implementation UIScrollView (PullToRefreshDeprecated)

- (void)addHeaderRefreshViewClass:(Class)viewClass target:(id)target action:(SEL)action
{
    UIView<XXPullToRefreshProtocol> * headerView = [[viewClass alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 75)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:headerView];
    [self addHeaderRefreshWithView:headerView target:target action:action];
}

- (void)addHeaderRefreshViewClass:(Class)viewClass completion:(XXPullToRefreshCompletion)completion
{
    UIView<XXPullToRefreshProtocol> * headerView = [[viewClass alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 75)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:headerView];
    [self addHeaderRefreshWithView:headerView completion:completion];
}

- (void)addFooterRefreshViewClass:(Class)viewClass target:(id)target action:(SEL)action {
    UIView<XXPullToRefreshProtocol> * footerView = [[viewClass alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 50)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:footerView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerBeginRefresh)];
    [footerView addGestureRecognizer:tap];
    [self addFooterRefreshWithView:footerView target:target action:action];
}

- (void)addFooterRefreshViewClass:(Class)viewClass completion:(XXPullToRefreshCompletion)completion
{
    UIView<XXPullToRefreshProtocol> * footerView = [[viewClass alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 50)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:footerView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerBeginRefresh)];
    [footerView addGestureRecognizer:tap];
    [self addFooterRefreshWithView:footerView completion:completion];
}

@end
