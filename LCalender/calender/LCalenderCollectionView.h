//
//  LCalenderCollectionView.h
//  LCalender
//
//  Created by 李姝睿 on 2017/3/9.
//  Copyright © 2017年 李姝睿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCalenderCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSIndexPath *startIndexPath;

@end
