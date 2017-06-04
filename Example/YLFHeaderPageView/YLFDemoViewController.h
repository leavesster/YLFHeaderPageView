//
//  YFDemoViewController.h
//  YLFHeaderPageView
//
//  Created by leavesster on 2017/6/3.
//  Copyright © 2017年 leavesster. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DemoHoverOverStyle @[@"HoverOverStyleNone", @"HoverOverStyleSegment", @"HoverOverStyleHeader"]
#define DemoPullDownStyle @[@"PullDownStyleNone", @"PullDownStyleDown", @"PullDownStyleStretch"]

@interface YFDemoViewController : UIViewController

- (instancetype)initWithHover:(NSUInteger)hover pullDown:(NSUInteger)pullDwon;

@end
