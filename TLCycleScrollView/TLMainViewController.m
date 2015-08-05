//
//  ViewController.m
//  TLCycleScrollView
//
//  Created by andezhou on 15/8/3.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLMainViewController.h"
#import "TLCycleScrollView.h"

@interface TLMainViewController () <TLCycleScrollViewDatasource, TLCycleScrollViewDelegate>
@property (nonatomic, strong) TLCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *dataList;@end

@implementation TLMainViewController

#pragma mark -
#pragma mark init methods
- (TLCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[TLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
        _cycleScrollView.cycleDataSource = self;
        _cycleScrollView.cycleDelegate = self;
    }
    return _cycleScrollView;
}

#pragma mark -
#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片复用";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _dataList = [NSMutableArray array];
    
    NSData *reply = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]];
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reply options:NSJSONReadingMutableLeaves error:&error];
    NSArray *data = [dict objectForKey:@"images"];
    
    for (NSDictionary *dict in data) {
        [_dataList addObject:dict[@"image"]];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cycleScrollView];
    
    // Do any additional setup after loading the view.
}


#pragma mark -
#pragma mark TLScrollViewDelegate
- (NSInteger)numberOfSectionsInCycleScrollView:(TLCycleScrollView *)scrollView {
    return _dataList.count;
}

- (NSString *)cycleScrollView:(TLCycleScrollView *)scrollView pageAtIndex:(NSInteger)index {
    return _dataList[index];
}
@end
