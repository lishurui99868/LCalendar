//
//  ViewController.m
//  LCalender
//
//  Created by 李姝睿 on 2017/3/6.
//  Copyright © 2017年 李姝睿. All rights reserved.
//

#import "ViewController.h"
#import "LCalenderViewController.h"
#import "LCalendarModel.h"

@interface ViewController ()<LCalenderViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)openCalenderClicked:(id)sender {
    
    LCalenderViewController *vc = [[LCalenderViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)calendarSelectedCalendarModels:(NSArray *)array {
    NSMutableString *str = [NSMutableString string];
    for (LCalendarModel *model in array) {
        [str appendFormat:@"%ld年%ld月%ld日", model.year, model.month, model.day ];
        [str appendString:@"\n"];
    }
    _textView.text = str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
