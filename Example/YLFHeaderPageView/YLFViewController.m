//
//  YLFViewController.m
//  YLFHeaderPageView
//
//  Created by leavesster on 06/03/2017.
//  Copyright (c) 2017 leavesster. All rights reserved.
//

#import "YLFViewController.h"
#import "YLFDemoViewController.h"
#import <YLFHeaderPageView/YLFHeaderPageView.h>

@interface YLFViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)   NSMutableArray        *styleGroup;
@property (nonatomic, copy)     NSArray               *hoverOverStyle;
@property (nonatomic, copy)     NSArray               *pullDownStyle;
@property (nonatomic, strong)   UITableView           *tableView;

@end

@implementation YLFViewController

static NSString *reuseIdentifier = @"reuseIdentifier";
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"YLFHeaderPageView Demo List";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.hoverOverStyle = DemoHoverOverStyle;
    self.pullDownStyle = DemoPullDownStyle;
    
    self.styleGroup = [NSMutableArray arrayWithCapacity:9];
    for (NSString *hover in self.hoverOverStyle) {
        for (NSString *pull in self.pullDownStyle) {
            [self.styleGroup addObject:@[hover , pull]];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.styleGroup count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSArray *style = self.styleGroup[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Hover:%@ PullDown:%@", [[style firstObject] stringByReplacingOccurrencesOfString:@"HoverOverStyle" withString:@""], [[style lastObject] stringByReplacingOccurrencesOfString:@"PullDownStyle" withString:@""]];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *style = self.styleGroup[indexPath.row];
    NSUInteger hover = [self.hoverOverStyle indexOfObject:style[0]];
    NSUInteger pull = [self.pullDownStyle indexOfObject:style[1]];
    YFDemoViewController *demoVC = [[YFDemoViewController alloc] initWithHover:hover pullDown:pull];
    [self.navigationController pushViewController:demoVC animated:YES];
}
@end
