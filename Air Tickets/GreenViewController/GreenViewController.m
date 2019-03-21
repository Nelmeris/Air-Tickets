//
//  GreenViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 17/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "GreenViewController.h"

@interface GreenViewController () {
    NSTimer *timer;
    NSInteger hours;
    NSInteger minutes;
    NSInteger seconds;
    
    CGFloat speed;
    
    UILabel *timerLabel;
    UILabel *speedLabel;
    UIButton *upButton;
    UIButton *downButton;
}

@end

@implementation GreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configurateTimerView];
    
    [self.view setBackgroundColor:UIColor.greenColor];
    // Do any additional setup after loading the view.
}

- (void)configurateTimerView {
    CGFloat centerX = UIScreen.mainScreen.bounds.size.width / 2;
    CGFloat centerY = UIScreen.mainScreen.bounds.size.height / 2;
    
    UIView *timerView = [[UIView alloc] initWithFrame:CGRectMake(centerX - 125, centerY - 50, 250, 100)];
    [timerView setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    timerView.layer.cornerRadius = 7.5;
    
    timerLabel = [[UILabel alloc] initWithFrame:timerView.bounds];
    [timerLabel setTextAlignment:NSTextAlignmentCenter];
    [timerLabel setText:@"00:00:00"];
    [timerLabel setTextColor:UIColor.blackColor];
    
    [timerView addSubview:timerLabel];
    
    [self.view addSubview:timerView];
    
    [self configurateTimerSpeedLabel:timerView];
    [self configurateTimerUpButton:timerView];
    [self configurateTimerDownButton:timerView];
}

- (void)configurateTimerSpeedLabel: (UIView *)timerView {
    CGFloat centerX = UIScreen.mainScreen.bounds.size.width / 2;
    CGFloat centerY = UIScreen.mainScreen.bounds.size.height / 2;
    
    speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - (timerView.frame.size.width / 2), centerY - (timerView.frame.size.height) - 10, timerView.frame.size.width, 50.0)];
    
    [speedLabel setTextAlignment:NSTextAlignmentCenter];
    [speedLabel setText:[NSString stringWithFormat:@"Speed: %.2fx", speed]];
    [speedLabel setTextColor:UIColor.blackColor];
    
    [self.view addSubview:speedLabel];
}

- (void)configurateTimerDownButton: (UIView *)timerView {
    CGFloat centerX = UIScreen.mainScreen.bounds.size.width / 2;
    CGFloat centerY = UIScreen.mainScreen.bounds.size.height / 2;
    
    downButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX - (timerView.frame.size.width / 2), centerY + (timerView.frame.size.height / 2) + 10, 50.0, 50.0)];
    [downButton setTitle:@"-" forState:UIControlStateNormal];
    [downButton setBackgroundColor:UIColor.blackColor];
    [downButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(downTimer) forControlEvents:UIControlEventTouchUpInside];
    downButton.titleLabel.font = [UIFont systemFontOfSize:30.0];
    downButton.layer.cornerRadius = downButton.frame.size.height / 2;
    
    [self.view addSubview:downButton];
}

- (void)configurateTimerUpButton: (UIView *)timerView {
    CGFloat centerX = UIScreen.mainScreen.bounds.size.width / 2;
    CGFloat centerY = UIScreen.mainScreen.bounds.size.height / 2;
    
    upButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX + (timerView.frame.size.width / 2) - 50, centerY + (timerView.frame.size.height / 2) + 10, 50.0, 50.0)];
    [upButton setTitle:@"+" forState:UIControlStateNormal];
    [upButton setBackgroundColor:UIColor.blackColor];
    [upButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [upButton addTarget:self action:@selector(upTimer) forControlEvents:UIControlEventTouchUpInside];
    upButton.titleLabel.font = [UIFont systemFontOfSize:30.0];
    upButton.layer.cornerRadius = upButton.frame.size.height / 2;
    
    [self.view addSubview:upButton];
}

- (void)downTimer {
    [timer invalidate];
    speed /= 2;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 / speed
                                             target:self
                                           selector:@selector(timer)
                                           userInfo:nil
                                            repeats:YES];
    [speedLabel setText:[NSString stringWithFormat:@"Speed: %.2fx", speed]];
    if (speed <= .25) {
        [downButton setEnabled:NO];
        [downButton setBackgroundColor:UIColor.lightGrayColor];
    }
    if (![upButton isEnabled]) {
        [upButton setEnabled:YES];
        [upButton setBackgroundColor:UIColor.blackColor];
    }
}

- (void)upTimer {
    speed *= 2;
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 / speed
                                             target:self
                                           selector:@selector(timer)
                                           userInfo:nil
                                            repeats:YES];
    [speedLabel setText:[NSString stringWithFormat:@"Speed: %.2fx", speed]];
    if (speed >= 64) {
        [upButton setEnabled:NO];
        [upButton setBackgroundColor:UIColor.lightGrayColor];
    }
    if (![downButton isEnabled]) {
        [downButton setEnabled:YES];
        [downButton setBackgroundColor:UIColor.blackColor];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [timer invalidate];
    timer = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    speed = 1;
    [speedLabel setText:[NSString stringWithFormat:@"Speed: %.2fx", speed]];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:speed
                                             target:self
                                           selector:@selector(timer)
                                           userInfo:nil
                                            repeats:YES];
    hours = 0;
    minutes = 0;
    seconds = 0;
    [upButton setEnabled:YES];
    [upButton setBackgroundColor:UIColor.blackColor];
    [downButton setEnabled:YES];
    [downButton setBackgroundColor:UIColor.blackColor];
}

- (void)timer {
    seconds++;
    if (seconds / 60 != 0) {
        minutes += seconds / 60;
        seconds %= 60;
        if (minutes / 60 != 0) {
            hours += minutes / 60;
            minutes %= 60;
        }
    }
    [timerLabel setText:[NSString stringWithFormat:@"%@:%@:%@",
                    [self timeToString:hours],
                    [self timeToString:minutes],
                    [self timeToString:seconds]]];
}

- (NSString *)timeToString: (NSInteger)number {
    return [NSString stringWithFormat:@"%@%ld", (number / 10 == 0) ? @"0" : @"", number];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
