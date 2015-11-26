//
//  AllListPlayViewController.m
//  GoTravel
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 小辉╰つ. All rights reserved.
//

#import "AllListPlayViewController.h"
#import "LocalTourismTableViewController.h"
#import "FreeLineTableViewController.h"

@interface AllListPlayViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UISegmentedControl *allListSegmen;
@property (nonatomic, strong) UIScrollView *allListScrollview;
@property (nonatomic, strong) LocalTourismTableViewController *localTableView;
@property (nonatomic, strong) FreeLineTableViewController *freeTableView;
@end

@implementation AllListPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadScrollviewAndSegmen];
    [self loadTableView];
    
    
}
#pragma mark - 初始化ScrollviewAndSegmen
- (void)loadScrollviewAndSegmen
{
    self.allListSegmen = [[UISegmentedControl alloc] initWithItems:@[@"超值自由行", @"精彩当地游"]];
    self.navigationItem.titleView = self.allListSegmen;
    [self.allListSegmen addTarget:self action:@selector(segmenClicked:) forControlEvents:(UIControlEventValueChanged)];
    
    self.allListScrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.allListScrollview.contentSize = CGSizeMake(self.view.frame.size.width * 2, 0);
    
    self.allListScrollview.pagingEnabled = YES;
    self.allListScrollview.bounces = NO;
    self.allListScrollview.delegate = self;
    self.allListSegmen.selectedSegmentIndex = 0;
    [self.view addSubview:self.allListScrollview];
}
#pragma mark - 初始化tableView
- (void)loadTableView
{
    self.localTableView = [[LocalTourismTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addTableview:self.localTableView.tableView index:0];
    self.freeTableView = [[FreeLineTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addTableview:self.freeTableView.tableView index:1];
    self.allListScrollview.contentSize = CGSizeMake(2*self.view.frame.size.width, CGRectGetHeight(self.freeTableView.tableView.frame));
}
- (void)addTableview:(UITableView *)tableView index:(NSInteger)index
{
    tableView.frame = CGRectMake(index * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.allListScrollview addSubview:tableView];
    
}
#pragma mark - 实现segmen点击方法
- (void)segmenClicked:(UISegmentedControl *)segmen
{
    switch (segmen.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1:
            
            break;
        default:
            break;
    }
}
#pragma mark - 实现Scrollview代理方法
//不管什么情况只要UIScrollView动了 就会触发这个方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"滚动中");
}
//将要开始拖拽的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"正在开始拽");
}
//将要开始减速的时候
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"将要开始减速");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"结束减速");
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"结束拖拽");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
