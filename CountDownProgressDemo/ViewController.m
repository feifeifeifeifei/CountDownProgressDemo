//
//  ViewController.m
//  CountDownProgressDemo
//
//  Created by 菲了然 on 16/5/23.
//  Copyright © 2016年 菲了然. All rights reserved.
//

#import "ViewController.h"
#import "FYCountDownView.h"
@interface ViewController ()

@property (strong, nonatomic)FYCountDownView * countDownView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back"]];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((self.view.frame.size.width - 200)/2.0, 80, 200, 50);
    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:24];
    [btn setTitle:@"开始计时" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:48/255.0 green:157/255.0 blue:216/255.0 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(countDownEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    __weak typeof (btn)weakBtn= btn;
    FYCountDownView * countView = [[FYCountDownView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 80)/2.0, 200, 80, 80) totalTime:10  lineWidth:3.0 lineColor:[UIColor colorWithRed:48/255.0 green:157/255.0 blue:216/255.0 alpha:1]  startBlock:^{
        [weakBtn setTitle:@"计时中..." forState:UIControlStateNormal];
        } completeBlock:^{
        [weakBtn setTitle:@"重新计时" forState:UIControlStateNormal];
    }];
    [self.view addSubview:self.countDownView = countView];
}

-(void)countDownEvent
{
    if (!self.countDownView.isCountingDown) {
        [self.countDownView startCountDown];
    }
}

@end
