//
//  LCalenderViewController.m
//  LCalender
//
//  Created by 李姝睿 on 2017/3/6.
//  Copyright © 2017年 李姝睿. All rights reserved.
//

#import "LCalenderViewController.h"
#import "LCalenderCollectionView.h"


#import "LCalendarManager.h"
#import "LCalendarModel.h"

@interface LCalenderViewController ()

@property (nonatomic, strong) LCalenderCollectionView *collectionView;

@end

@implementation LCalenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createReturnBtn];
    [self createCollectionView];
    [self initDataSource];
}

- (void)initDataSource {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LCalendarManager *manager = [[LCalendarManager alloc] initWithShowHoliday:YES showLunarCalendar:YES startDate:0];
        NSArray *array = [manager getCalendarDataSourceWithLimitMonth:12 type:LCalenderViewControllerTypeLater];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView.dataArray addObjectsFromArray:array];
            [self.collectionView reloadData];
        });
    });
}

- (void)createReturnBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 25, 40, 20);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(returnBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createCollectionView {
    NSInteger width = self.view.bounds.size.width / 7.0;
    NSInteger height = width * 1.1;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 70);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[LCalenderCollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) collectionViewLayout:flowLayout];
    [self.view addSubview:_collectionView];
}

- (void)returnBtnClick {
    NSMutableArray *array = [NSMutableArray array];
    for (LCalendarHeaderModel *header in _collectionView.dataArray) {
        for (LCalendarModel *model in header.calendarModels) {
            if (model.isSelecte) {
                [array addObject:model];
            }
        }
    }
    
    if (array.count > 0 && [self.delegate respondsToSelector:@selector(calendarSelectedCalendarModels:)]) {
        [self.delegate calendarSelectedCalendarModels:array];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
