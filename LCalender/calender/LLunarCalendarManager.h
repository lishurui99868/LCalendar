//
//  LLunarCalendarManager.h
//  LCalender
//
//  Created by 李姝睿 on 2017/3/7.
//  Copyright © 2017年 李姝睿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCalendarModel.h"

@interface LLunarCalendarManager : NSObject

- (void)getLunarCalendarWithDate:(NSDate *)date calendarModel:(LCalendarModel *)calendarModel;

+ (BOOL)isQingMingholidayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end
