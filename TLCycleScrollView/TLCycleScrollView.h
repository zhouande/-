//
//  TLCycleScrollView.h
//  TLCycleScrollView
//
//  Created by andezhou on 15/8/3.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TLCycleScrollView;

@protocol TLCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(TLCycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol TLCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfSectionsInCycleScrollView:(TLCycleScrollView *)scrollView;
- (NSString *)cycleScrollView:(TLCycleScrollView *)scrollView pageAtIndex:(NSInteger)index;

@end

@interface TLCycleScrollView : UIScrollView <UIScrollViewDelegate>

// 数据源/代理方法
@property (assign, nonatomic) id<TLCycleScrollViewDatasource> cycleDataSource;
@property (assign, nonatomic) id<TLCycleScrollViewDelegate> cycleDelegate;

// 是否允许无限循环 默认YES
@property (assign, nonatomic) BOOL allowCycle;

// 当前显示的位置
@property (nonatomic, assign) NSInteger curPage;



@end
