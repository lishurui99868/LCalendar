//
//  LCalendarManager.h
//  LCalender
//
//  Created by 李姝睿 on 2017/3/7.
//  Copyright © 2017年 李姝睿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCalenderViewController.h"

@interface LCalendarManager : NSObject

- (instancetype)initWithShowHoliday:(BOOL)isHoliday showLunarCalendar:(BOOL)isLunar startDate:(NSInteger)startDate;

// 获取数据源
- (NSArray *)getCalendarDataSourceWithLimitMonth:(NSInteger)limitMonth type:(LCalenderViewControllerType)type;

@end
