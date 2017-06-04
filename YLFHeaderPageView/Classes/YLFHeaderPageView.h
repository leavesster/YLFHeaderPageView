//
//  YLFHeaderPageView.h
//  SwapScroll
//
//  Created by yleaf on 2017/6/2.
//  Copyright © 2017年 yleaf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, YLFHeaderPageViewHoverOverStyle){
    YLFHeaderPageViewHoverOverStyleNone          = 0,
    YLFHeaderPageViewHoverOverStyleSegment       = 1<<0, //只悬停segment
    YLFHeaderPageViewHoverOverStyleHeader        = 1<<1, //不仅悬停segment，而且还悬停一部分header，需要配置headerMinSpace参数
};

typedef NS_ENUM(NSUInteger, YLFHeaderPageViewPullDownStyle){
    YLFHeaderPageViewPullDownStyleNone               = 0,    //不拉伸header,保持不不动
    YLFHeaderPageViewPullDownStyleDown               = 1,    //不拉伸，一起下移
    YLFHeaderPageViewPullDownStyleStretch            = 2,    //header拉伸，占满
};


@protocol YLFHeaderPageViewProtocol <NSObject>

- (UIScrollView *)scrollViewForCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)scrollViewCount;

@end

@interface YLFHeaderPageView : UIView

@property (nonatomic, assign) CGFloat         headerMinSpace;

@property (nonatomic, strong) UIView            *headerView;
@property (nonatomic, strong) UIView            *segmentView;
@property (nonatomic, strong) UICollectionView  *pagingView;

@property (nonatomic, weak)     id<YLFHeaderPageViewProtocol>          mananger;
@property (nonatomic, assign)   YLFHeaderPageViewHoverOverStyle        hoverOverStyle;
@property (nonatomic, assign)   YLFHeaderPageViewPullDownStyle         pulldownStyle;

/**
 实例化方法

 @param frame 控件整体 frame
 @param headerView 伪造的tableHeaderView
 @param segmentView SegmentView 选择index按钮类
 @param manager 返回底部滚动试图内容Manager
 @return 控件本身
 */
- (instancetype)initWithFrame:(CGRect)frame
                       header:(UIView *)headerView
                  segmentView:(UIView *)segmentView
                      manager:(id<YLFHeaderPageViewProtocol>)manager;

- (void)handleScrollView:(UIScrollView *)scrollView atIndexPath:(NSIndexPath *)indexPath;


@end
