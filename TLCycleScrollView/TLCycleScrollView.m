//
//  TLCycleScrollView.m
//  TLCycleScrollView
//
//  Created by andezhou on 15/8/3.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLCycleScrollView.h"
#import "UIImageView+SDWebImage.h"
@interface TLCycleScrollView ()

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, strong) UIImageView *imgLeft, *imgCenter, *imgRight;

@end

@implementation TLCycleScrollView

#pragma mark -
#pragma mark lifecycle
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configSetting];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSetting];
    }
    return self;
}

- (void)configSetting {
    self.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.delegate = self;
    
    [self addSubview:self.imgLeft];
    [self addSubview:self.imgCenter];
    [self addSubview:self.imgRight];
    
    _allowCycle = YES;
    _curPage = 0;
}

- (void)setCycleDataSource:(id<TLCycleScrollViewDatasource>)cycleDataSource
{
    _cycleDataSource = cycleDataSource;
    
    [self reloadData];
}

#pragma mark -
#pragma mark init methods
- (UIImageView *)imgLeft {
    if (!_imgLeft) {
        _imgLeft = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imgLeft;
}

- (UIImageView *)imgRight {
    if (!_imgRight) {
        _imgRight = [[UIImageView alloc] initWithFrame:CGRectOffset(self.bounds, self.bounds.size.width * 2, 0)];
    }
    return _imgRight;
}

- (UIImageView *)imgCenter {
    if (!_imgCenter) {
        _imgCenter = [[UIImageView alloc] initWithFrame:CGRectOffset(self.bounds, self.bounds.size.width, 0)];
    }
    return _imgCenter;
}

#pragma mark -
#pragma mark 刷新视图
- (void)reloadData {
    // 1.获取总的页数
    _totalPages = [_cycleDataSource numberOfSectionsInCycleScrollView:self];
    if (_totalPages == 0) return;
    
    // 2.加载视图
    [self setInfoByCurrentImageIndex:_curPage];
    [self setContentOffset:CGPointMake(self.frame.size.width, 0)];
}

- (void)loadData {
    CGFloat viewWidth = self.bounds.size.width;
    
    // 1.判断滑动方向，得到当前_curPage
    if (self.contentOffset.x > viewWidth) { //向左滑动
        _curPage = (_curPage + 1) % _totalPages;
    }
    else if (self.contentOffset.x < viewWidth) { //向右滑动
        _curPage = (_curPage - 1 + _totalPages) % _totalPages;
    }

    // 2.跟新imggeView对应的图片
    [self setInfoByCurrentImageIndex:_curPage];
    [self setContentOffset:CGPointMake(self.frame.size.width, 0)];
}

- (void)setInfoByCurrentImageIndex:(NSInteger)page {
    NSInteger pre = ((_curPage - 1 + _totalPages) % _totalPages);
    NSInteger last = ((_curPage + 1) % _totalPages);
    
    // 更新图片
    [_imgLeft downloadImage:[_cycleDataSource cycleScrollView:self pageAtIndex:pre] place:nil];
    [_imgCenter downloadImage:[_cycleDataSource cycleScrollView:self pageAtIndex:page] place:nil];
    [_imgRight downloadImage:[_cycleDataSource cycleScrollView:self pageAtIndex:last] place:nil];
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.scrollEnabled)  return;
    
    [self loadData];

    [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
}

@end
