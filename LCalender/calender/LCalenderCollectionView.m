//
//  LCalenderCollectionView.m
//  LCalender
//
//  Created by 李姝睿 on 2017/3/9.
//  Copyright © 2017年 李姝睿. All rights reserved.
//

#import "LCalenderCollectionView.h"
#import "LCalendarCollectionViewCell.h"
#import "LCalenderCollectionReusableView.h"
#import "LCalendarModel.h"

@implementation LCalenderCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.scrollEnabled = YES;
        
        [self registerNib:[UINib nibWithNibName:@"LCalendarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LCalendarCollectionViewCell"];
        [self registerNib:[UINib nibWithNibName:@"LCalenderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCalenderCollectionReusableView"];
        
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    self.startIndexPath = indexPath;
    LCalendarHeaderModel *header = _dataArray[indexPath.section];
    LCalendarModel *model = header.calendarModels[indexPath.item];
    if (model.type != LCalendarModelTypeBefore && model.day > 0) {
        self.scrollEnabled = NO;
        model.isSelecte = ! model.isSelecte;
    }
    [self reloadData];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    
    LCalendarHeaderModel *startH = _dataArray[_startIndexPath.section];
    LCalendarModel *startModel = startH.calendarModels[_startIndexPath.item];
    
    
    if (_startIndexPath.section == indexPath.section) {
        for (NSInteger i = _startIndexPath.item + 1; i <= indexPath.item; i ++) {
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:i inSection:_startIndexPath.section];
            LCalendarHeaderModel *header = _dataArray[indexP.section];
            LCalendarModel *model = header.calendarModels[indexP.item];
            if (model.day > 0 && model.type != LCalendarModelTypeBefore) {
                model.isSelecte = startModel.isSelecte;
            }
        }
    } else {
        for (NSInteger i = 0; i <= indexPath.item; i ++) {
            NSIndexPath *indexP = [NSIndexPath indexPathForItem:i inSection:indexPath.section];
            LCalendarHeaderModel *header = _dataArray[indexP.section];
            LCalendarModel *model = header.calendarModels[indexP.item];
            if (model.day > 0 && model.type != LCalendarModelTypeBefore) {
                model.isSelecte = startModel.isSelecte;
            }
        }
    }
    
    [self reloadData];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.scrollEnabled = YES;
}


#pragma mark - collectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    LCalendarHeaderModel *headerModel = _dataArray[section];
    return headerModel.calendarModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCalendarCollectionViewCell" forIndexPath:indexPath];
    if (cell) {
        LCalendarHeaderModel *headerModel = _dataArray[indexPath.section];
        LCalendarModel *calendarModel = headerModel.calendarModels[indexPath.row];
        cell.dayLabel.text = @"";
        cell.lunarLabel.text = @"";
        cell.backgroundColor = [UIColor whiteColor];
        
        if (calendarModel.day > 0) {
            cell.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)calendarModel.day];
            if (calendarModel.holiday.length) {
                cell.dayLabel.text = calendarModel.holiday;
            }
            cell.lunarLabel.text = calendarModel.lunarCalendar;
            
            if (calendarModel.isSelecte) {
                cell.backgroundColor = [UIColor magentaColor];
            } else {
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
        if (calendarModel.type == LCalendarModelTypeBefore) {
            cell.dayLabel.textColor = [UIColor lightGrayColor];
            cell.lunarLabel.textColor = [UIColor lightGrayColor];
        } else {
            cell.dayLabel.textColor = [UIColor blackColor];
            cell.lunarLabel.textColor = [UIColor blackColor];
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        LCalenderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"LCalenderCollectionReusableView" forIndexPath:indexPath];
        LCalendarHeaderModel *headerModel = _dataArray[indexPath.section];
        header.monthLable.text = headerModel.yearAndMonth;
        return header;
    }
    return nil;
}


@end
