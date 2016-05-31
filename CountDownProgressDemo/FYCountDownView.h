//
//  FYCountDownView.h
//  CountDownProgressDemo
//
//  Created by 菲了然 on 16/5/27.
//  Copyright © 2016年 菲了然. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  开始倒计时
 */
typedef void (^CountDownStartBlock)();
/**
 *  倒计时完成
 */
typedef void (^CountDownCompleteBlock)();

@interface FYCountDownView : UIView
/**
 *  是否正在倒计时
 */
@property (assign, nonatomic)BOOL isCountingDown;
-(instancetype)initWithFrame:(CGRect)frame  totalTime:(NSInteger)totalTime lineWidth:(CGFloat)lineWidth  lineColor:(UIColor *)lineColor startBlock:(CountDownStartBlock)startBlock completeBlock:(CountDownCompleteBlock)completeBlock;

-(void)startCountDown;

@end
