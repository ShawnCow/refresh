//
//  XXPullToRefreshView.m
//  DaRen
//
//  Created by Shawn on 2017/3/16.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import "XXPullToRefreshView.h"

@implementation XXPullToRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupRefreshHeaderView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setupRefreshHeaderView];
    }
    return self;
}

- (void)_setupRefreshHeaderView
{
    NSString *budlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"XXRefreshBundle" ofType:@"bundle"];
    NSBundle *bulde = [NSBundle bundleWithPath:budlePath];
    self.backgroundColor = [UIColor clearColor];
    UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xx_refresh_arrow" inBundle:bulde compatibleWithTraitCollection:nil]];
    [self addSubview:imgView];
    self.arrowImageView = imgView;
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor colorWithRed:49./255. green:49./255. blue:49./255. alpha:1.];
    titleLabel.backgroundColor =[UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel * dateLabel = [UILabel new];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dateLabel];
    self.dateLabel = dateLabel;
    [self _layoutSubviews];
    
    UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView stopAnimating];
    [self addSubview:activityIndicatorView];
    self.activityIndicatorView = activityIndicatorView;
}

- (void)_layoutSubviews
{
    float labelWidth = 150;
    CGRect frame = self.titleLabel.frame;
    frame.origin.y = (self.bounds.size.height - 20 * 2)/2;
    frame.origin.x = self.bounds.size.width / 2 - labelWidth/2 + self.arrowImageView.frame.size.width / 2;
    frame.size.height = 20;
    frame.size.width = labelWidth;
    self.titleLabel.frame = frame;
    
    frame = self.dateLabel.frame;
    frame.origin.x = self.titleLabel.frame.origin.x;
    frame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    frame.size.width = labelWidth;
    frame.size.height = 20;
    self.dateLabel.frame = frame;
    
    frame = self.arrowImageView.frame;
    frame.origin.y = self.bounds.size.height/2 - frame.size.height / 2;
    frame.origin.x = self.titleLabel.frame.origin.x - frame.size.width;
    self.arrowImageView.frame = frame;
    
    self.activityIndicatorView.center = self.arrowImageView.center;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self _layoutSubviews];
}

- (void)setLastRefreshDate:(NSDate *)lastRefreshDate
{
    if ([lastRefreshDate isEqualToDate:_lastRefreshDate]) {
        return;
    }
    _lastRefreshDate = lastRefreshDate;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:MM:ss"];
    NSString * dateString = [formatter stringFromDate:_lastRefreshDate];
    self.dateLabel.text = [NSString stringWithFormat:@"上次刷新:%@",dateString];
}

- (void)setPullToRefreshState:(XXPullToRefreshViewState)state
{
    if (state == XXPullToRefreshViewStateNormal) {
        self.titleLabel.text = @"下拉可以刷新";
        self.arrowImageView.hidden = NO;
        [self.activityIndicatorView stopAnimating];
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }];
    }else if (state == XXPullToRefreshViewStatePulling)
    {
        self.titleLabel.text = @"松开可以刷新";
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImageView.transform =  CGAffineTransformMakeRotation(- M_PI);
        }];
    }else if (state == XXPullToRefreshViewStateLoading)
    {
        self.titleLabel.text = @"正在加载中...";
        [self.activityIndicatorView startAnimating];
        self.arrowImageView.hidden = YES;
    }
}

- (void)pullToRefreshFinishRefreshOnSuccess:(BOOL)success
{
    if (success) {
        self.lastRefreshDate = [NSDate date];
    }
}

- (void)pullToRefreshManagerByScrollView:(UIScrollView *)scrollView type:(XXPullToRefreshViewType)type
{
    self.frame = CGRectMake(0, -75, scrollView.bounds.size.width, 75);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [scrollView addSubview:self];
}

- (void)pullToRefreshUnManagerByScrollView:(UIScrollView *)scrollView type:(XXPullToRefreshViewType)type
{
    [self removeFromSuperview];
}

@end
