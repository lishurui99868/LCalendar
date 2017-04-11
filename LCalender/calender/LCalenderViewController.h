//
//  LCalenderViewController.h
//  LCalender
//
//  Created by 李姝睿 on 2017/3/6.
//  Copyright © 2017年 李姝睿. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LCalenderViewControllerType) {
    LCalenderViewControllerTypeBefore = 0, // 显示当月之前
    LCalenderViewControllerTypeMiddle, // 前后显示一半
    LCalenderViewControllerTypeLater // 显示当月之后
};

@protocol LCalenderViewControllerDelegate <NSObject>
@optional
- (void)calendarSelectedCalendarModels:(NSArray *)array;

@end


@interface LCalenderViewController : UIViewController

@property (nonatomic, weak) id<LCalenderViewControllerDelegate> delegate;

@end
