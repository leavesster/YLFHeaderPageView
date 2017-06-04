//
//  YLFHeaderPageView.m
//  SwapScroll
//
//  Created by yleaf on 2017/6/2.
//  Copyright © 2017年 yleaf. All rights reserved.
//

#import "YLFHeaderPageView.h"
#import <KVOController/KVOController.h>

@interface YLFHeaderPageView ()<UICollectionViewDelegate, UICollectionViewDataSource>

//固有高度
@property (nonatomic, assign)   CGFloat         headerHeight;
@property (nonatomic, assign)   CGFloat         startOffsetY;
@property (nonatomic, assign)   CGFloat         criPointY;

@property (nonatomic, weak)     UIScrollView    *currentScrollView;

@end

@implementation YLFHeaderPageView

static void *PagingViewScrollContext = &PagingViewScrollContext;
static void *PagingViewInsetContext  = &PagingViewInsetContext;

NSString * const HeaderPagingCell = @"kPagingCellIdentifier";

- (instancetype)initWithFrame:(CGRect)frame
                       header:(UIView *)headerView
                  segmentView:(UIView *)segmentView
                      manager:(id<YLFHeaderPageViewProtocol>)manager
{
    if (self = [super initWithFrame:frame]) {
        
        _headerView                         = headerView;
        _segmentView                        = segmentView;
        _mananger                           = manager;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing          = 0.0;
        layout.minimumInteritemSpacing     = 0.0;
        layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize                    = frame.size;
        
        _pagingView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _pagingView.delegate = self;
        _pagingView.dataSource = self;
        _pagingView.backgroundColor = [UIColor clearColor];
        _pagingView.pagingEnabled = YES;
        _pagingView.bounces = NO;
        [_pagingView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:HeaderPagingCell];
        _pagingView.scrollsToTop = NO;
        [self addSubview:_pagingView];
        _headerHeight = CGRectGetHeight(_headerView.frame);
        _headerView.frame = (CGRect){CGPointZero, _headerView.frame.size};
        [self addSubview:_headerView];
        _segmentView.frame = (CGRect){CGPointMake(0, CGRectGetMaxY(_headerView.frame)), _segmentView.frame.size};
        [self addSubview:_segmentView];
    }
    return self;
}

#pragma mark - Properties

- (void)setHeaderMinSpace:(CGFloat)headerMinSpace
{
    if (self.hoverOverStyle & YLFHeaderPageViewHoverOverStyleHeader) {
        _headerMinSpace = headerMinSpace;
    }
}

//起始位置
- (CGFloat)startOffsetY
{
    if (!_startOffsetY) {
        _startOffsetY = -self.headerHeight - CGRectGetHeight(self.segmentView.frame);
    }
    return _startOffsetY;
}

//临界点，Offset再增加，开始悬停；减少，开始下拉出现
- (CGFloat)criPointY
{
    if (!_criPointY) {
        _criPointY = -self.headerMinSpace - CGRectGetHeight(self.segmentView.frame);
    }
    return _criPointY;
}

#pragma mark - UICollectionView Delegate and DataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HeaderPagingCell forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIScrollView *scrollView = [self.mananger scrollViewForCell:cell atIndexPath:indexPath];
    [self handleScrollView:scrollView atIndexPath:indexPath];
    [cell.contentView addSubview:scrollView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIScrollView *scrollView in [cell.contentView subviews]) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            [self handleScrollView:scrollView atIndexPath:indexPath];
            [self addObserverForScrollView:scrollView];
            self.currentScrollView = scrollView;
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [self.mananger scrollViewCount];
}

#pragma mark - PagingView

- (void)handleScrollView:(UIScrollView *)scrollView atIndexPath:(NSIndexPath *)indexPath
{
    scrollView.contentInset = UIEdgeInsetsMake(self.headerHeight + CGRectGetHeight(self.segmentView.frame), 0, scrollView.contentInset.bottom, 0);
    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, fmaxf(scrollView.contentOffset.y, self.startOffsetY));
    
    CGFloat segmentY = CGRectGetMaxY(self.segmentView.frame);
    if (segmentY <= 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, fmaxf(scrollView.contentOffset.y, 0));
    }
    else if (segmentY <= self.headerMinSpace + CGRectGetHeight(self.segmentView.frame)) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, fmaxf(scrollView.contentOffset.y, -segmentY));
    }
    else if (segmentY > self.headerMinSpace + CGRectGetHeight(self.segmentView.frame)) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -segmentY);
    }
}

#pragma mark - Observer

- (void)addObserverForScrollView:(UIScrollView *)scrollView
{
    [self.KVOController observe:scrollView keyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (object != self.currentScrollView) {
            return;
        }
        
        CGFloat newOffsetY          = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        CGRect  headerFrame         = self.headerView.frame;
        CGRect  segmentFrame        = self.segmentView.frame;
        CGFloat segmentHeight       = CGRectGetHeight(segmentFrame);
        
        //顶部下拉
        if (newOffsetY < self.startOffsetY){
            switch (self.pulldownStyle) {
                case YLFHeaderPageViewPullDownStyleNone:
                {
                    headerFrame.origin.y = 0;
                    headerFrame.size.height = self.headerHeight;
                }
                    break;
                case YLFHeaderPageViewPullDownStyleDown:
                {
                    headerFrame.origin.y = -newOffsetY - segmentHeight - self.headerHeight;
                    headerFrame.size.height = self.headerHeight;
                }
                    break;
                case YLFHeaderPageViewPullDownStyleStretch:
                {
                    headerFrame.origin.y = 0;
                    headerFrame.size.height = -newOffsetY - segmentHeight;
                }
                    break;
            }
        }
        //全部展示与部分悬停之间状态,保持整体上移即可
        else if (newOffsetY < self.criPointY) {
            headerFrame.origin.y = self.startOffsetY - newOffsetY;
            headerFrame.size.height = self.headerHeight;
        }
        //悬停逻辑
        else if (newOffsetY >= self.criPointY && self.hoverOverStyle | (YLFHeaderPageViewHoverOverStyleSegment & YLFHeaderPageViewHoverOverStyleHeader)){
            headerFrame.origin.y = - self.headerHeight + self.headerMinSpace;
            headerFrame.size.height = self.headerHeight;
        }
        //渐渐向上移动消失,保证在顶上即可，不再继续增加
        else if (newOffsetY >= self.criPointY) {
            headerFrame.origin.y = fmaxf(self.startOffsetY - newOffsetY, -segmentHeight - self.headerHeight);
            headerFrame.size.height = self.headerHeight;
        }
        segmentFrame.origin.y = CGRectGetMaxY(headerFrame);
        self.headerView.frame = headerFrame;
        self.segmentView.frame = segmentFrame;
    }];
}

#pragma mark - HitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self.headerView) {
        return self.currentScrollView;
    }
    return view;
}
@end
