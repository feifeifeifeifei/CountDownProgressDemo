//
//  FYCountDownView.m
//  CountDownProgressDemo
//
//  Created by 菲了然 on 16/5/27.
//  Copyright © 2016年 菲了然. All rights reserved.
//

#import "FYCountDownView.h"

#define PROGRESSW self.frame.size.width
#define PROGRESSH self.frame.size.height

@interface FYCountDownView()

@property (strong, nonatomic) CAShapeLayer * progressLayer;
@property (strong, nonatomic) CABasicAnimation *rotateAnimation;
@property (strong, nonatomic) CABasicAnimation *strokeAnimationEnd;
@property (strong, nonatomic) CAAnimationGroup *animationGroup;
@property (assign, nonatomic) CGFloat progressLineWidth;
@property (strong, nonatomic) UIColor * progressLineColor;
@property (strong, nonatomic) UILabel *countLabel;
@property (assign, nonatomic) NSInteger totalTime;
@property (copy, nonatomic) CountDownStartBlock startBlock;
@property (copy, nonatomic) CountDownCompleteBlock completeBlock;


@end

@implementation FYCountDownView

-(instancetype)initWithFrame:(CGRect)frame  totalTime:(NSInteger)totalTime lineWidth:(CGFloat)lineWidth  lineColor:(UIColor *)lineColor startBlock:(CountDownStartBlock)startBlock completeBlock:(CountDownCompleteBlock)completeBlock
{
    self  = [self initWithFrame:frame];
    if (self) {
        self.progressLineWidth = lineWidth;
        self.progressLineColor = lineColor;
        self.totalTime = totalTime;
        self.startBlock  = startBlock;
        self.completeBlock = completeBlock;
        [self.layer addSublayer:self.progressLayer];
        UILabel * countLabel = [[UILabel alloc] initWithFrame:self.bounds];
        countLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:frame.size.width/2.5];
        countLabel.textColor = self.progressLineColor;
        countLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.countLabel = countLabel];
    }
    return self;
}
-(void)startTime
{
    __weak typeof (self)bself = self;
    if (_totalTime > 0) {
        __block NSInteger timeout = _totalTime; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                //主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    bself.isCountingDown = NO;
                    bself.hidden = YES;
                    [bself stopCountDown];
                });
            }else{
                bself.isCountingDown = YES;
                NSInteger seconds = timeout % 60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.countLabel.text = [NSString stringWithFormat:@"%@s",@(seconds).stringValue];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}

-(void)startCountDown
{
    self.hidden = NO;
    self.isCountingDown = YES;
    if (self.startBlock) {
        self.startBlock();
    }
    [self startTime];
    [self.progressLayer addAnimation:self.animationGroup forKey:@"group"];
}

-(void)stopCountDown
{
    if (self.rotateAnimation && self.animationGroup) {
        [self.progressLayer removeAllAnimations];
    }
    if (self.completeBlock) {
        self.completeBlock();
    }
}

-(CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = CGRectMake(0, 0, PROGRESSW, PROGRESSH);
        _progressLayer.position = CGPointMake(PROGRESSW/2.0, PROGRESSH/2.0);
        _progressLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(PROGRESSW/2.0, PROGRESSH/2.0) radius:(PROGRESSW - self.progressLineWidth)/2.0 startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.lineWidth = self.progressLineWidth;
        _progressLayer.strokeColor = self.progressLineColor.CGColor;
        _progressLayer.strokeEnd = 0;
        _progressLayer.strokeStart = 0;
        _progressLayer.lineCap = kCALineCapRound;
    }
    return _progressLayer;
}

-(CABasicAnimation *)rotateAnimation
{
    if (!_rotateAnimation) {
        _rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _rotateAnimation.fromValue = @(2 * M_PI);
        _rotateAnimation.toValue = @0;
        _rotateAnimation.duration = self.totalTime;
        _rotateAnimation.removedOnCompletion = NO;
    }
    return _rotateAnimation;
}

-(CABasicAnimation *)strokeAnimationEnd
{
    if (!_strokeAnimationEnd) {
        _strokeAnimationEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _strokeAnimationEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _strokeAnimationEnd.duration = self.totalTime;
        _strokeAnimationEnd.fromValue = @1;
        _strokeAnimationEnd.toValue = @0;
        _strokeAnimationEnd.speed = 1.0;
        _strokeAnimationEnd.removedOnCompletion = NO;
    }
    return _strokeAnimationEnd;
}

-(CAAnimationGroup *)animationGroup
{
    if (!_animationGroup) {
        _animationGroup = [CAAnimationGroup animation];
        _animationGroup.animations = @[self.strokeAnimationEnd,self.rotateAnimation];
        _animationGroup.duration = self.totalTime;
    }
    return _animationGroup;
}

@end
