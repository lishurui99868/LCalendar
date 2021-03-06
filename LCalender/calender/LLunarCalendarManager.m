//
//  LLunarCalendarManager.m
//  LCalender
//
//  Created by 李姝睿 on 2017/3/7.
//  Copyright © 2017年 李姝睿. All rights reserved.
//

#import "LLunarCalendarManager.h"

@interface LLunarCalendarManager ()

@property (nonatomic, strong) NSCalendar *chineseCalendar;
@property (nonatomic, strong) NSArray *chineseYears;
@property (nonatomic, strong) NSArray *chineseMonths;
@property (nonatomic, strong) NSArray *chineseDays;

@end
@implementation LLunarCalendarManager

- (instancetype)init {
    if (self = [super init]) {
        _chineseCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierChinese];
//        _chineseYears = [NSArray arrayWithObjects:
//                         @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
//                         @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
//                         @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
//                         @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
//                         @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
//                         @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
        _chineseMonths = [NSArray arrayWithObjects:
                          @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                          @"九月", @"十月", @"冬月", @"腊月", nil];
        _chineseDays = [NSArray arrayWithObjects:
                        @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                        @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                        @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    }
    return self;
}

- (void)getLunarCalendarWithDate:(NSDate *)date calendarModel:(LCalendarModel *)calendarModel {
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [_chineseCalendar components:unitFlags fromDate:date];
//    NSString *chineseYear = [_chineseYears objectAtIndex:components.year - 1];
    NSInteger tempDay = components.day;
    // 系统日历类在2057-09-28计算有bug结果为0（应该为30）
    if (tempDay == 0) {
        tempDay = 30;
    }
    NSString *chineseMonth = [_chineseMonths objectAtIndex:components.month - 1];
    NSString *chineseDay = [_chineseDays objectAtIndex:tempDay - 1];
    calendarModel.lunarCalendar = chineseDay;
    if ([@"正月" isEqualToString:chineseMonth] &&
        [@"初一" isEqualToString:chineseDay]) {
        calendarModel.holiday = @"春节";
    } else if ([@"正月" isEqualToString:chineseMonth] &&
               [@"十五" isEqualToString:chineseDay]) {
        calendarModel.holiday = @"元宵节";
    } else if ([@"二月" isEqualToString:chineseMonth] &&
               [@"初二" isEqualToString:chineseDay]) {
        calendarModel.holiday = @"龙抬头";
    } else if ([@"五月" isEqualToString:chineseMonth] &&
               [@"初五" isEqualToString:chineseDay]) {
        calendarModel.holiday = @"端午节";
    } else if ([@"七月" isEqualToString:chineseMonth] &&
               [@"初七" isEqualToString:chineseDay]) {
        calendarModel.holiday = @"七夕";
    } else if ([@"八月" isEqualToString:chineseMonth] &&
               [@"十五" isEqualToString:chineseDay]) {
        calendarModel.holiday = @"中秋节";
    } else if ([@"九月" isEqualToString:chineseMonth] &&
               [@"初九" isEqualToString:chineseDay]) {
        calendarModel.holiday = @"重阳节";
    } else if ([@"腊月" isEqualToString:chineseMonth] &&
               [@"初八" isEqualToString:chineseDay]) {
        calendarModel.holiday = @"腊八";
    } else if ([@"腊月" isEqualToString:chineseMonth] &&
               [@"二三" isEqualToString:chineseDay]) {
        calendarModel.holiday = @"小年";
    } else if ([@"腊月" isEqualToString:chineseMonth] &&
               [@"三十" isEqualToString:chineseDay]) {
        calendarModel.holiday = @"除夕";
    }
}

/*
 清明节日期的计算 [Y*D+C]-L
 公式解读：Y=年数后2位，D=0.2422，L=闰年数，21世纪C=4.81，20世纪=5.59。
 */
+ (BOOL)isQingMingholidayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    if (month == 4) {
        NSInteger pre = year / 100;
        float c = 4.81;
        if(pre == 19) {
            c = 5.59;
        }
        NSInteger y = year % 100;
        NSInteger qingMingDay = (y * 0.2422 + c) - y / 4;
        if (day == qingMingDay) {
            return YES;
        }
    }
    return NO;
}

@end
