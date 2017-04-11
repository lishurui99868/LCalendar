//
//  LCalendarModel.h
//  LCalender
//
//  Created by 李姝睿 on 2017/3/7.
//  Copyright © 2017年 李姝睿. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LCalendarModelType) {
    LCalendarModelTypeToday = 0,
    LCalendarModelTypeBefore,
    LCalendarModelTypeLatter
};

@interface LCalendarModel : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, copy) NSString *lunarCalendar; // 农历
@property (nonatomic, copy) NSString *holiday;
@property (nonatomic, assign) NSInteger dateInterval; // 日期时间戳
@property (nonatomic, assign) NSInteger week;
@property (nonatomic, assign) LCalendarModelType type;

@property (nonatomic, assign) BOOL isSelecte;

@end

@interface LCalendarHeaderModel : NSObject

@property (nonatomic, copy) NSString *yearAndMonth;
@property (nonatomic, strong) NSArray *calendarModels;

@end
