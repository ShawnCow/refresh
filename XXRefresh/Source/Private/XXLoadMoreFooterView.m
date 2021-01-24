//
//  XXLoadMoreFooterView.m
//  XXKit
//
//  Created by Shawn on 2015/5/19.
//  Copyright © 2015年 XXKit. All rights reserved.
//

#import "XXLoadMoreFooterView.h"
#import "UIScrollView+XXPullToRefresh.h"

@interface XXLoadMoreFooterView ()

@property (nonatomic, weak) UILabel * infoLabel;

@property (nonatomic, weak) UIActivityIndicatorView * activityIndicatorView;

@property (nonatomic, strong) UIGestureRecognizer *tapGestureRecogizer;

@end

@implementation XXLoadMoreFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UILabel * label = [[UILabel alloc]initWithFrame:self.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"点击加载更多";
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor colorWithRed:189./255. green:189./255. blue:189./255. alpha:1.];
        [self addSubview:label];
        self.infoLabel = label;
        
        UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:activityIndicatorView];
        activityIndicatorView.hidesWhenStopped = YES;
        [activityIndicatorView stopAnimating];
        [self addSubview:activityIndicatorView];
        self.activityIndicatorView = activityIndicatorView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.activityIndicatorView.center = CGPointMake(self.bounds.size.width/ 2, self.bounds.size.height / 2);
}

- (void)tap:(UIGestureRecognizer *)ges
{
    
}

- (void)setPullToRefreshState:(XXPullToRefreshViewState)state
{
    switch (state) {
        case XXPullToRefreshViewStateNormal:
        {
            self.infoLabel.text = @"点击加载更多";
            [self.activityIndicatorView stopAnimating];
            self.infoLabel.hidden = NO;
        }
            break;
        case XXPullToRefreshViewStatePulling:
        {
            self.infoLabel.text = @"松开即可加载更多...";
        }
            break;
        case XXPullToRefreshViewStateLoading:
        {
            self.infoLabel.hidden = YES;
            [self.activityIndicatorView startAnimating];
        }
        default:
            break;
    }
}

- (void)contentSizeDidChangeWithScrollView:(UIScrollView *)scrollView
{
    self.frame = CGRectMake(0, scrollView.contentInset.bottom + scrollView.contentSize.height, scrollView.bounds.size.width, 50);
}

- (void)pullToRefreshManagerByScrollView:(UIScrollView *)scrollView type:(XXPullToRefreshViewType)type
{
    [scrollView addSubview:self];
    self.frame = CGRectMake(0, scrollView.contentInset.bottom + scrollView.contentSize.height, scrollView.bounds.size.width, 50);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if (self.tapGestureRecogizer) {
        [self removeGestureRecognizer:self.tapGestureRecogizer];
    }
    self.tapGestureRecogizer = [[UITapGestureRecognizer alloc]initWithTarget:scrollView action:@selector(footerBeginRefresh)];
    [self addGestureRecognizer:self.tapGestureRecogizer];
}

- (void)pullToRefreshUnManagerByScrollView:(UIScrollView *)scrollView type:(XXPullToRefreshViewType)type
{
    [self removeFromSuperview];
}

@end
