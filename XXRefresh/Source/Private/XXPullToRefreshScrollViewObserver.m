//
//  XXPullToRefreshScrollViewObserver.m
//  XXKit
//
//  Created by Shawn on 2015/5/19.
//  Copyright © 2015年 XXKit. All rights reserved.
//

#import "XXPullToRefreshScrollViewObserver.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface XXPullToRefreshScrollViewObserver ()

@property (nonatomic) CGFloat contentInsetTopBeforeHeaderRefresh;
@property (nonatomic) CGFloat contentInsetBottomBeforeFooterRefresh;
@property (nonatomic) BOOL lockHeaderRefresh;
@property (nonatomic, copy) dispatch_block_t headerRefreshCompletion;
@property (nonatomic) BOOL lockFooterRefresh;
@property (nonatomic, copy) dispatch_block_t footerRefreshCompletion;
@property (nonatomic, readonly) BOOL observerOn;

@end

@implementation XXPullToRefreshScrollViewObserver

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (scrollView == nil) {
#ifdef DEBUG
        if (scrollView == nil) {
            NSException * ex = [NSException exceptionWithName:@"XXPullToRefreshExceptionName" reason:@"scroll view is null" userInfo:nil];
            [ex raise];
        }
#endif
        return nil;
    }
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _headerRefreshItem = [[XXPullToRefreshItem alloc]initWithObserver:self];
        _footerRefreshItem = [[XXPullToRefreshItem alloc]initWithObserver:self];
        [self registerObserver];
    }
    return self;
}

- (void)dealloc
{
    [self unregisterObserver];
    _scrollView = nil;
}

- (void)registerObserver
{
    if (self.observerOn) {
        return;
    }
    _observerOn = YES;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
}

- (void)unregisterObserver
{
    if (self.observerOn == NO) {
        return;
    }
    _observerOn = NO;
    [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [_scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    [_scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state" context:nil];
}

- (void)headerBeginRefresh
{
    if (self.headerRefreshItem.currentState != XXPullToRefreshViewStateLoading) {
        float stateChangeOffset = self.scrollView.contentInset.top;
        if ([self.headerRefreshItem.view respondsToSelector:@selector(pullToRefreshStateChangeOffsetHeight)]) {
            stateChangeOffset  += [self.headerRefreshItem.view pullToRefreshStateChangeOffsetHeight];
        }else
        {
            stateChangeOffset  += 75;
        }
        if (stateChangeOffset != 0) {
            UIEdgeInsets insert = self.scrollView.contentInset;
            self.contentInsetTopBeforeHeaderRefresh = insert.top;
            insert.top += stateChangeOffset;
            self.lockHeaderRefresh = YES;
            [UIView animateWithDuration:0.35 animations:^{
                [self.scrollView setContentInset:insert];
                [self.scrollView setContentOffset:CGPointMake(0, - insert.top) animated:YES];
            } completion:^(BOOL finished) {
                self.lockHeaderRefresh = NO;
                if (self.headerRefreshCompletion) {
                    self.headerRefreshCompletion();
                    self.headerRefreshCompletion = nil;
                }
            }];
        }
        self.headerRefreshItem.currentState = XXPullToRefreshViewStateLoading;
    }
}

- (void)headerEndRefreshOnSuccess:(BOOL)success
{
    if (self.headerRefreshItem.currentState != XXPullToRefreshViewStateNormal) {
        __weak XXPullToRefreshScrollViewObserver *ws = self;
        self.headerRefreshCompletion = ^{
            ws.headerRefreshItem.currentState = XXPullToRefreshViewStateNormal;
            UIEdgeInsets contentInset = ws.scrollView.contentInset;
            contentInset.top = ws.contentInsetTopBeforeHeaderRefresh;
            [UIView animateWithDuration:0.35 animations:^{
                ws.scrollView.contentInset = contentInset;
            }];
        };
        if (self.lockHeaderRefresh == NO) {
            self.headerRefreshCompletion();
            self.headerRefreshCompletion = nil;
        }
        
        if ([self.headerRefreshItem.view respondsToSelector:@selector(pullToRefreshFinishRefreshOnSuccess:)]) {
            [self.headerRefreshItem.view pullToRefreshFinishRefreshOnSuccess:success];
        }
    }
}

- (void)footerBeginRefresh
{
    if (self.footerRefreshItem.currentState != XXPullToRefreshViewStateLoading) {
        float stateChangeOffset = self.scrollView.contentInset.top;
        if ([self.footerRefreshItem.view respondsToSelector:@selector(pullToRefreshStateChangeOffsetHeight)]) {
            stateChangeOffset  += [self.footerRefreshItem.view pullToRefreshStateChangeOffsetHeight];
        }else
        {
            stateChangeOffset  += 50;
        }
        
        if (stateChangeOffset != 0) {
            UIEdgeInsets insert = self.scrollView.contentInset;
            self.contentInsetBottomBeforeFooterRefresh = insert.bottom;
            insert.bottom += stateChangeOffset;
            [UIView animateWithDuration:0.25 animations:^{
                self.scrollView.contentInset = insert;
            }];
        }
        self.footerRefreshItem.currentState = XXPullToRefreshViewStateLoading;
    }
}

- (void)footerEndRefreshOnSuccess:(BOOL)success
{
    if (self.footerRefreshItem.currentState != XXPullToRefreshViewStateNormal) {
        self.footerRefreshItem.currentState = XXPullToRefreshViewStateNormal;
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.bottom = self.contentInsetBottomBeforeFooterRefresh;
        [UIView animateWithDuration:0.25 animations:^{
            [self.scrollView setContentInset:contentInset];
        }];
        if ([self.footerRefreshItem.view respondsToSelector:@selector(pullToRefreshFinishRefreshOnSuccess:)]) {
            [self.footerRefreshItem.view pullToRefreshFinishRefreshOnSuccess:success];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self _handleContentOffsetChange];
    }else if ([keyPath isEqualToString:@"state"])
    {
        [self _handleGestureStateChange];
    }else if ([keyPath isEqualToString:@"contentSize"])
    {
        [self _hanleContentSizeChange];
    }else if ([keyPath isEqualToString:@"contentInset"])
    {
        [self _handleContentInsetChangeWithChange:change];
    }
}

- (void)_handleContentOffsetChange
{
    if (self.headerRefreshItem.view && self.headerRefreshItem.currentState != XXPullToRefreshViewStateLoading && self.scrollView.isDragging == YES) {
        if ([self.headerRefreshItem.view respondsToSelector:@selector(pullToRefreshScrollViewDidScrollToOffset:)]) {
            [self.headerRefreshItem.view pullToRefreshScrollViewDidScrollToOffset:self.scrollView.contentOffset];
        }
        
        float stateChangeOffset = self.scrollView.contentInset.top;
        if ([self.headerRefreshItem.view respondsToSelector:@selector(pullToRefreshStateChangeOffsetHeight)]) {
            stateChangeOffset  += [self.headerRefreshItem.view pullToRefreshStateChangeOffsetHeight];
        }else
        {
            stateChangeOffset  += 75;
        }
        
        if (self.scrollView.contentOffset.y <= - (stateChangeOffset)) {
            self.headerRefreshItem.currentState = XXPullToRefreshViewStatePulling;
        }else
        {
            self.headerRefreshItem.currentState = XXPullToRefreshViewStateNormal;
        }
    }
    
    if (self.footerRefreshItem.view && self.footerRefreshItem.currentState != XXPullToRefreshViewStateLoading && self.scrollView.contentSize.height >= self.scrollView.bounds.size.height - 10) {
        if ([self.footerRefreshItem.view respondsToSelector:@selector(pullToRefreshScrollViewDidScrollToOffset:)]) {
            [self.footerRefreshItem.view pullToRefreshScrollViewDidScrollToOffset:self.scrollView.contentOffset];
        }
        
        float stateChangeOffset = self.scrollView.contentInset.top;
        if ([self.footerRefreshItem.view respondsToSelector:@selector(pullToRefreshStateChangeOffsetHeight)]) {
            stateChangeOffset  += [self.footerRefreshItem.view pullToRefreshStateChangeOffsetHeight];
        }else
        {
            stateChangeOffset  += 50;
        }
        
        float bottomOffsetY = self.scrollView.contentOffset.y + self.scrollView.bounds.size.height;
        if (bottomOffsetY > self.scrollView.contentSize.height + stateChangeOffset) {
            self.footerRefreshItem.currentState = XXPullToRefreshViewStatePulling;
        }else
        {
            self.footerRefreshItem.currentState = XXPullToRefreshViewStateNormal;
        }
    }
}

- (void)_handleGestureStateChange
{
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (self.headerRefreshItem.view && self.headerRefreshItem.currentState == XXPullToRefreshViewStatePulling) {
            [self headerBeginRefresh];
        }
        
        if (self.scrollView.contentSize.height >= self.scrollView.bounds.size.height - 10 && self.footerRefreshItem.view && self.footerRefreshItem.currentState == XXPullToRefreshViewStatePulling) {
            
            [self footerBeginRefresh];
        }
    }
}

- (void)_hanleContentSizeChange
{
    NSMutableArray *tempViews = [NSMutableArray array];
    if (self.headerRefreshItem.view) {
        [tempViews addObject:self.headerRefreshItem.view];
    }
    if (self.footerRefreshItem.view) {
        [tempViews addObject:self.footerRefreshItem.view];
    }
    for (id <XXPullToRefreshProtocol> view in tempViews) {
        
        if (view && [view respondsToSelector:@selector(contentSizeDidChangeWithScrollView:)]) {
            [view contentSizeDidChangeWithScrollView:self.scrollView];
        }
    }
}

- (void)_handleContentInsetChangeWithChange:(NSDictionary *)change
{
    NSMutableArray *tempViews = [NSMutableArray array];
    if (self.headerRefreshItem.view) {
        [tempViews addObject:self.headerRefreshItem.view];
    }
    if (self.footerRefreshItem.view) {
        [tempViews addObject:self.footerRefreshItem.view];
    }
    for (id <XXPullToRefreshProtocol> view in tempViews) {
        if (view && [view respondsToSelector:@selector(contentInsetDidChangeWithScrollView:)]) {
            [view contentInsetDidChangeWithScrollView:self.scrollView];
        }
    }
}

#pragma mark - check

- (void)checkAndInvokeHeaderManagerMethod
{
    UIView<XXPullToRefreshProtocol> *view = self.headerRefreshItem.view;
    if ([view respondsToSelector:@selector(pullToRefreshManagerByScrollView:type:)]) {
        [view pullToRefreshManagerByScrollView:self.scrollView type:XXPullToRefreshViewTypeHeader];
    }
}

- (void)removeHeaderRefresh
{
    XXPullToRefreshItem *headerItem = self.headerRefreshItem;
    headerItem.target = nil;
    headerItem.action = nil;
    headerItem.completion = nil;
    UIView <XXPullToRefreshProtocol> *view = headerItem.view;
    headerItem.view = nil;
    if ([view respondsToSelector:@selector(pullToRefreshUnManagerByScrollView:type:)] ) {
        [view pullToRefreshUnManagerByScrollView:self.scrollView type:XXPullToRefreshViewTypeHeader];
    }
}

- (void)checkAndInvokeFooterManagerMethod
{
    UIView<XXPullToRefreshProtocol> *view = self.footerRefreshItem.view;
    if ([view respondsToSelector:@selector(pullToRefreshManagerByScrollView:type:)]) {
        [view pullToRefreshManagerByScrollView:self.scrollView type:XXPullToRefreshViewTypeFooter];
    }
}

- (void)removeFooterRefresh
{
    XXPullToRefreshItem *footerItem = self.footerRefreshItem;
    footerItem.target = nil;
    footerItem.action = nil;
    footerItem.completion = nil;
    UIView <XXPullToRefreshProtocol> *view = footerItem.view;
    footerItem.view = nil;
    if ([view respondsToSelector:@selector(pullToRefreshUnManagerByScrollView:type:)] ) {
        [view pullToRefreshUnManagerByScrollView:self.scrollView type:XXPullToRefreshViewTypeFooter];
    }
}

@end

@implementation XXPullToRefreshItem

- (instancetype)initWithObserver:(XXPullToRefreshScrollViewObserver *)observer
{
    self = [super init];
    if (self) {
        _observer = observer;
    }
    return self;
}

- (void)invocationRefreshAction
{
    UIScrollView * scrollView = self.observer.scrollView;
    
    if (self.completion) {
        self.completion(scrollView);
    }
    
    if (self.target && self.action) {
        IMP imp = [self.target methodForSelector:self.action];
        void(* func)(id, SEL, UIScrollView *) = (void *)imp;
        func(self.target,self.action,scrollView);
    }
}

- (void)setCurrentState:(XXPullToRefreshViewState)currentState
{
    if (_currentState == currentState) {
        return;
    }
    _currentState = currentState;
    if (self.view) {
        [self.view setPullToRefreshState:_currentState];
        if (_currentState == XXPullToRefreshViewStateLoading) {
            [self invocationRefreshAction];
        }
    }
}

- (void)setView:(UIView<XXPullToRefreshProtocol> *)view
{
    if (_view == view) {
        return;
    }
    _view = view;
    if (_view) {
        [_view setPullToRefreshState:self.currentState];
    }
}

@end

