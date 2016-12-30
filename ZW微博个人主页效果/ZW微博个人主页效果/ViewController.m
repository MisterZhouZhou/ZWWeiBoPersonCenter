//
//  ViewController.m
//  ZW微博个人主页效果
//
//  Created by rayootech on 2016/12/29.
//  Copyright © 2016年 gmjr. All rights reserved.
//

#import "ViewController.h"
#import "JYPagingView.h"
#import "ArtTableViewController.h"

@interface ArtNavView : UIView

@property (nonatomic, strong) UIButton *leftBut;

@end

@implementation ArtNavView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void) configUI {
    /*
     * 只是做一个简单示例，要加分割线或其它变化，自行扩展即可
     */
    self.backgroundColor = [UIColor colorWithWhite:1 alpha: 0];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
    but.frame = CGRectMake(0, 22, 44, 44);
    UIImage *buttonimage = [UIImage imageNamed:@"barbuttonicon_back"];
    [but setImage:buttonimage forState:UIControlStateNormal];
    but.tintColor = [UIColor colorWithWhite:0 alpha: 1];
    self.leftBut = but;
    [self addSubview:but];
}

- (void)changeAlpha:(CGFloat)alpha {
    
    self.backgroundColor = [UIColor colorWithWhite:1 alpha: alpha];
    self.leftBut.tintColor = [UIColor colorWithWhite:(1 - alpha) alpha:1];
}

@end


@interface ViewController ()<HHHorizontalPagingViewDelegate>
@property (nonatomic, strong) HHHorizontalPagingView *pagingView;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) ArtNavView *navView;
@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRed:242./255. green:242./255. blue:242./255. alpha:1.0];
    self.pagingView.backgroundColor = [UIColor whiteColor];
    [self.pagingView reload];
    
    /* 需要设置self.edgesForExtendedLayout = UIRectEdgeNone; 最好自定义导航栏
     * 在代理 - (void)pagingView:(HHHorizontalPagingView *)pagingView scrollTopOffset:(CGFloat)offset
     *做出对应处理来改变 背景色透明度
     */
    self.navView = [[ArtNavView alloc] init];
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.navView.frame = CGRectMake(0, 0, size.width, 64);
    [self.view addSubview:self.navView];
    [self.navView.leftBut addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void) back
{
    
}


- (void)viewWillAppear:(BOOL)animated{
    // 设置导航栏背景为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    // 隐藏导航栏底部黑线
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    // 当都设置为nil的时候，导航栏会使用默认的样式，即还原导航栏样式
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;

//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


#pragma mark - 懒加载
- (HHHorizontalPagingView *)pagingView{
    if (!_pagingView) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        _pagingView = [[HHHorizontalPagingView alloc] initWithFrame:CGRectMake(0,44, size.width, size.height-44) delegate:self];
        _pagingView.segmentTopSpace = 20;
        //添加下拉刷新（效果不好）
//        _pagingView.allowPullToRefresh = YES;
        _pagingView.segmentView.backgroundColor = [UIColor colorWithRed:242./255. green:242./255. blue:242./255. alpha:1.0];
        _pagingView.maxCacheCout = 5.;
        _pagingView.isGesturesSimulate = YES;
        [self.view addSubview:_pagingView];
    }
    return _pagingView;
}


- (void)showText:(NSString *)str{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate: self  cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
#pragma clang diagnostic pop
}

#pragma mark -  HHHorizontalPagingViewDelegate
#pragma mark  下方左右滑UIScrollView的滚动视图个数
- (NSInteger)numberOfSectionsInPagingView:(HHHorizontalPagingView *)pagingView{
    return 2;
}

#pragma mark 可滚动的视图控制器
- (UIScrollView *)pagingView:(HHHorizontalPagingView *)pagingView viewAtIndex:(NSInteger)index{
    ArtTableViewController *vc = [[ArtTableViewController alloc] init];
    [self addChildViewController:vc];
    vc.index = index;
    //添加下拉刷新（效果不好）
//    vc.allowPullToRefresh = YES;
//    vc.pullOffset = self.pagingView.pullOffset;
    vc.fillHight = self.pagingView.segmentTopSpace ;
    return (UIScrollView *)vc.view;
}

#pragma mark headerView 的高 设置
- (CGFloat)headerHeightInPagingView:(HHHorizontalPagingView *)pagingView{
    return 200;
}


#pragma mark - 头视图
- (UIView *)headerViewInPagingView:(HHHorizontalPagingView *)pagingView{
    
    __weak typeof(self)weakSelf = self;
    UIView *headerView = [[UIView alloc] init];
    UIImage *image = [UIImage imageNamed:@"headerImage"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [headerView addSubview:imageView];
    
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.topConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [headerView addConstraint:self.topConstraint];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    headerView.backgroundColor = [UIColor orangeColor];
    [headerView whenTapped:^{
        [weakSelf showText:@"headerView click"];
    }];
    
    //红色view
    UIView *view = [[UIView alloc] init];
    [headerView addSubview:view];
    view.backgroundColor = [UIColor redColor];
    view.frame = CGRectMake(50, 20, 200, 150);
    view.tag = 1000;
    
    [view whenTapped:^{
        [weakSelf showText:@"redView click"];
    }];
    
    //灰色view
    UIView *view1 = [[UIView alloc] init];
    [view addSubview:view1];
    view1.tag = 1001;
    view1.backgroundColor = [UIColor grayColor];
    view1.frame = CGRectMake(50, 25, 100, 100);
    
    
    [view1 whenTapped:^{
        [weakSelf showText:@"grayView click"];
    }];
    
    self.topConstraint.constant = - self.pagingView.pullOffset;
    return headerView;
}


#pragma mark -下拉放大图 、设置导航透明度 时调用
- (void)pagingView:(HHHorizontalPagingView*)pagingView scrollTopOffset:(CGFloat)offset{
    if (offset > 0) {
        return;
    }
    self.topConstraint.constant = offset;
    
    NSLog(@"%f",offset);
    if (offset >= -20 - 36) { // > 0 代表已经只顶了
        [self.navView changeAlpha:1];
        return;
    }
    
    NSLog(@"22==>%f",offset);
    CGFloat fm = self.pagingView.pullOffset - 20.0 -36;
    CGFloat fz = - 20 -36  - offset;
    float al = 1.0 - fz / fm;
    al = al <= 0.05 ? 0 : al;
    al = al >= 0.95 ? 1 : al;
    NSLog(@"22==>%f",al);
    //       NSLog(@"__ %f  __  %f __ %lf",offset,self.pagingView.pullOffset, al);
    [self.navView changeAlpha:al];
}



#pragma mark segmentButton 高
- (CGFloat)segmentHeightInPagingView:(HHHorizontalPagingView *)pagingView{
    return 36.;
}

#pragma mark segmentButton 标题数组
- (NSArray<UIButton*> *)segmentButtonsInPagingView:(HHHorizontalPagingView *)pagingView{
    
    NSMutableArray *buttonArray = [NSMutableArray array];
    for(int i = 0; i < 2; i++) {
        UIButton *segmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [segmentButton setBackgroundImage:[UIImage imageNamed:@"Home_title_line"] forState:UIControlStateNormal];
        [segmentButton setBackgroundImage:[UIImage imageNamed:@"Home_title_line_select"] forState:UIControlStateSelected];
        NSString *str = i == 5 ? @"返回" : [NSString stringWithFormat:@"view%@",@(i)];
        [segmentButton setTitle:str forState:UIControlStateNormal];
        [segmentButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        segmentButton.adjustsImageWhenHighlighted = NO;
        [buttonArray addObject:segmentButton];
    }
    return [buttonArray copy];
}

#pragma mark 点击segment触发的事件
- (void)pagingView:(HHHorizontalPagingView*)pagingView segmentDidSelected:(UIButton *)item atIndex:(NSInteger)selectedIndex{
    NSLog(@"%s",__func__);
//    if (selectedIndex == 5) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)pagingView:(HHHorizontalPagingView*)pagingView segmentDidSelectedSameItem:(UIButton *)item atIndex:(NSInteger)selectedIndex{
    NSLog(@"%s",__func__);
    
}

#pragma mark 视图切换完成时调用
- (void)pagingView:(HHHorizontalPagingView*)pagingView didSwitchIndex:(NSInteger)aIndex to:(NSInteger)toIndex{
    NSLog(@"%s \n %tu  to  %tu",__func__,aIndex,toIndex);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
