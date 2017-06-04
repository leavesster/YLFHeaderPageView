//
//  ViewController.m
//  SwapScroll
//
//  Created by leavesster on 2017/6/2.
//  Copyright © 2017年 leavesster. All rights reserved.
//

#import "YLFDemoViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <YLFHeaderPageView/YLFHeaderPageView.h>

@interface YFDemoViewController ()<UITableViewDelegate, UITableViewDataSource,YLFHeaderPageViewProtocol>

@property (nonatomic, strong) YLFHeaderPageView *pagingView;

@property (nonatomic, assign) NSUInteger hover;
@property (nonatomic, assign) NSUInteger pullDwon;
@end

@implementation YFDemoViewController

- (instancetype)initWithHover:(NSUInteger)hover pullDown:(NSUInteger)pullDwon
{
    if (self = [super init]) {
        _hover = hover;
        _pullDwon = pullDwon;
    }
    return self;
}

static NSString * reuseIdentifier = @"tableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    header.backgroundColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 50)];
    label.text = [NSString stringWithFormat:@"%@\n%@", DemoHoverOverStyle[self.hover], DemoPullDownStyle[self.pullDwon]];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    [header addSubview:label];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    [back setTitle:@"backToPreviousVC" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToPreviousVC) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(0, 100, self.view.bounds.size.width, 50);
    back.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [header addSubview:back];
    
    UIView *segment = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    segment.backgroundColor = [UIColor orangeColor];
    YLFHeaderPageView *pagingView = [[YLFHeaderPageView alloc] initWithFrame:self.view.bounds header:header segmentView:segment manager:self];
    pagingView.hoverOverStyle = _hover;
    pagingView.pulldownStyle = _pullDwon;
    pagingView.headerMinSpace = 44;
    [self.view addSubview:pagingView];
    self.pagingView = pagingView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)backToPreviousVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIScrollView *)scrollViewForCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UITableView *tableV = [[UITableView alloc] initWithFrame:cell.bounds];
    
    if (self.pullDwon == YLFHeaderPageViewPullDownStyleNone) {
        __weak typeof(tableV)weakTableV = tableV;
        tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakTableV.mj_header endRefreshing];
            });
        }];
    }
    tableV.backgroundColor = [self randomColor];
    [tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.tag = indexPath.item;
    return tableV;
}

- (NSInteger)scrollViewCount
{
    return 4;
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [self randomColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld - %ld", (long)tableView.tag, (long)indexPath.row];
    return cell;
}

- (UIColor *)randomColor
{
    CGFloat redLevel    = rand() / (float) RAND_MAX;
    CGFloat greenLevel  = rand() / (float) RAND_MAX;
    CGFloat blueLevel   = rand() / (float) RAND_MAX;
    
    UIColor *randomColor = [UIColor colorWithRed: redLevel green: greenLevel blue: blueLevel alpha: 1.0];
    return randomColor;
}


@end
