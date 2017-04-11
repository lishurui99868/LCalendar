//
//  LCalendarManager.m
//  LCalender
//
//  Created by 李姝睿 on 2017/3/7.
//  Copyright © 2017年 李姝睿. All rights reserved.
//

#import "LCalendarManager.h"
#import "LLunarCalendarManager.h"

@interface LCalendarManager ()

@property (nonatomic, strong) NSDate *today;
@property (nonatomic, strong) NSDateComponents *todayComponents;
@property (nonatomic, strong) NSCalendar *greCalendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) LLunarCalendarManager *lunarManager;
@property (nonatomic, assign) BOOL isShowHoliday;
@property (nonatomic, assign) BOOL isShowLunar;
@property (nonatomic, assign) NSInteger startDate;

@end
@implementation LCalendarManager

- (instancetype)initWithShowHoliday:(BOOL)isHoliday showLunarCalendar:(BOOL)isLunar startDate:(NSInteger)startDate {
    if (self = [super init]) {
        _greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _today = [NSDate date];
        _todayComponents = [self dateToComponents:_today];
        _dateFormatter = [[NSDateFormatter alloc] init];
        _lunarManager = [[LLunarCalendarManager alloc] init];
        _isShowLunar = isLunar;
        _isShowHoliday = isHoliday;
        _startDate = startDate;
    }
    return self;
}


- (NSArray *)getCalendarDataSourceWithLimitMonth:(NSInteger)limitMonth type:(LCalenderViewControllerType)type {
    NSMutableArray *results = [NSMutableArray array];
    NSDateComponents *componets = [self dateToComponents:_today];
    componets.day = 1;
    if (type == LCalenderViewControllerTypeLater) {
        componets.month -= 1;
    } else if (type == LCalenderViewControllerTypeBefore) {
        componets.month -= limitMonth;
    } else {
        componets.month -= (limitMonth + 1) / 2;
    }
    for (NSInteger i = 0; i < limitMonth; i ++) {
        componets.month ++;
        LCalendarHeaderModel *headerModel = [[LCalendarHeaderModel alloc] init];
        NSDate *date = [self componentsToDate:componets];
        [_dateFormatter setDateFormat:@"yyyy年MM月"];
        headerModel.yearAndMonth = [_dateFormatter stringFromDate:date];
        headerModel.calendarModels = [self getCalendarItemArrayWithDate:date section:i];
        [results addObject:headerModel];
    }
    return results;
}
// 得到每一天的数据源
- (NSArray *)getCalendarItemArrayWithDate:(NSDate *)date section:(NSInteger)section {
    NSMutableArray *results = [NSMutableArray array];
    NSInteger totalDays = [self numberOfDaysInCurrentMonth:date];
    NSInteger firstDay = [self startDayOfWeek:date];
    
    NSDateComponents *components = [self dateToComponents:date];
    // 判断一个月有多少行
    NSInteger tempDay = totalDays + (firstDay - 1);
    NSInteger column = 0;
    if (tempDay % 7 == 0) {
        column = tempDay / 7;
    } else {
        column = tempDay / 7 + 1;
    }
    components.day = 0;
    for (NSInteger i = 0; i < column; i ++) {
        for (NSInteger j = 0; j < 7; j ++) {
            if (i == 0 && j < firstDay - 1) {
                LCalendarModel *calendarModel = [[LCalendarModel alloc] init];
                calendarModel.year = 0;
                calendarModel.month = 0;
                calendarModel.day = 0;
                calendarModel.lunarCalendar = @"";
                calendarModel.holiday = @"";
                calendarModel.week = -1;
                calendarModel.dateInterval = -1;
                [results addObject:calendarModel];
                continue;
            }
            components.day += 1;
            if (components.day == totalDays + 1) {
                i = column; // 家属外层循环
                break;
            }
            LCalendarModel *calendarModel = [[LCalendarModel alloc] init];
            calendarModel.year = components.year;
            calendarModel.month = components.month;
            calendarModel.day = components.day;
            calendarModel.week = j;
            NSDate *date = [self componentsToDate:components];
            calendarModel.dateInterval = [self dateToInterval:date];
            [self setLunarCalendarAndHolidayWithComponents:components date:date calenderModel:calendarModel];
            [results addObject:calendarModel];
        }
    }
    return results;
}
// 计算一个月有多少天
- (NSUInteger)numberOfDaysInCurrentMonth:(NSDate *)date {
    return [_greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}
// 确定这个月的第一天是星期几
- (NSUInteger)startDayOfWeek:(NSDate *)date {
    NSDate *startDate = nil;
    BOOL result = [_greCalendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:date];
    if (result) {
        return [_greCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:startDate];
    }
    return 0;
}
// 日期转时间戳
- (NSInteger)dateToInterval:(NSDate *)date {
    return (long)[date timeIntervalSince1970];
}
#pragma mark 农历和节假日
- (void)setLunarCalendarAndHolidayWithComponents:(NSDateComponents *)components date:(NSDate *)date calenderModel:(LCalendarModel *)calendarModel {
    if (components.year == _todayComponents.year && components.month == _todayComponents.month && components.day == _todayComponents.day) {
        calendarModel.holiday = @"今天";
        calendarModel.type = LCalendarModelTypeToday;
    } else {
        if ([date compare:_today] == 1) {
            calendarModel.type = LCalendarModelTypeLatter;
        } else {
            calendarModel.type = LCalendarModelTypeBefore;
        }
    }
    if (components.month == 1 && components.day == 1) {
        calendarModel.holiday = @"元旦";
    } else if (components.month == 2 && components.day == 14) {
        calendarModel.holiday = @"情人节";
    } else if (components.month == 3 && components.day == 8) {
        calendarModel.holiday = @"妇女节";
    } else if (components.month == 4 && components.day == 1) {
        calendarModel.holiday = @"愚人节";
    } else if (components.month == 4 && (components.day == 4 || components.day == 5 || components.day == 6)) {
        if ([LLunarCalendarManager isQingMingholidayWithYear:components.year month:components.month day:components.day]) {
            calendarModel.holiday = @"清明节";
        }
    } else if (components.month == 5 && components.day == 1) {
        calendarModel.holiday = @"劳动节";
    } else if (components.month == 5 && components.day == 4) {
        calendarModel.holiday = @"青年节";
    } else if (components.month == 6 && components.day == 1) {
        calendarModel.holiday = @"儿童节";
    } else if (components.month == 8 && components.day == 1) {
        calendarModel.holiday = @"建军节";
    } else if (components.month == 9 && components.day == 10) {
        calendarModel.holiday = @"教师节";
    } else if (components.month == 10 && components.day == 1) {
        calendarModel.holiday = @"国庆节";
    } else if (components.month == 11 && components.day == 11) {
        calendarModel.holiday = @"光棍节";
    } else if (components.month == 12 && components.day == 25) {
        calendarModel.holiday = @"圣诞节";
    }
    // 计算农历耗性能
    if (_isShowLunar || _isShowHoliday) {
        [_lunarManager getLunarCalendarWithDate:date calendarModel:calendarModel];
    }
}
#pragma mark NSDate和NSCompontents转换
- (NSDateComponents *)dateToComponents:(NSDate *)date {
    NSDateComponents *components = [_greCalendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    return components;
}

- (NSDate *)componentsToDate:(NSDateComponents *)components {
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *date = [_greCalendar dateFromComponents:components];
    return date;
}

@end
