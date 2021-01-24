//
//  XXPullToRefreshView.h
//  DaRen
//
//  Created by Shawn on 2017/3/16.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXPullToRefreshDefine.h"

@interface XXPullToRefreshView : UIView<XXPullToRefreshProtocol>

@property (nonatomic, weak) UIImageView * arrowImageView;

@property (nonatomic, weak) UIActivityIndicatorView * activityIndicatorView;

@property (nonatomic, weak) UILabel * titleLabel;

@property (nonatomic, weak) UILabel * dateLabel;

@property (nonatomic, strong) NSDate * lastRefreshDate;

@end
