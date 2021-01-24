//
//  ViewController.m
//  XXRefresh
//
//  Created by Shawn on 2019/5/15.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+XXPullToRefresh.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView addHeaderRefreshWithCompletion:^(UIScrollView *scrollView) {
        NSLog(@"mark");
    }];
    [self.tableView addFooterRefreshWithCompletion:^(UIScrollView *scrollView) {
        NSLog(@"mark2");
    }];
}


@end
