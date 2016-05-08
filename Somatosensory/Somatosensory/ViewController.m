//
//  ViewController.m
//  Somatosensory
//
//  Created by 蔡万鸿 on 16/5/8.
//  Copyright © 2016年 黄花菜. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

static const NSUInteger duration = 0.2;

@interface ViewController ()
/** X方向 */
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
/** Y方向 */
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
/** Z方向 */
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
/** 手机倾斜方向 */
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
/** 加速计 */
@property (nonatomic, strong) CMMotionManager *motionManager;

@property(nonatomic,assign)int ziTaiX;
@property(nonatomic,assign)int ziTaiY;

/** 长按计时器Timer */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initSomatosensoryView];
    
    [self somatosensoryParams];
}

/**
 *  初始化体感模式参数
 */
- (void)p_initSomatosensoryView {
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 5 / 60.0;
    [self.motionManager startAccelerometerUpdates];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(somatosensoryParams) userInfo:nil repeats:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self p_timerInvalidate];
}

/**
 *  体感
 */
- (void)somatosensoryParams {
    float x, y, z;
    
    x = - self.motionManager.accelerometerData.acceleration.x;
    y = - self.motionManager.accelerometerData.acceleration.y;
    z = - self.motionManager.accelerometerData.acceleration.z;
    
    self.xLabel.text = [NSString stringWithFormat:@"%f",x];
    self.yLabel.text = [NSString stringWithFormat:@"%f",y];
    self.zLabel.text = [NSString stringWithFormat:@"%f",z];
    
    //X轴和Z轴的夹角度数
    double tmp1 = 0;
    //Y轴和Z轴的夹角度数
    double tmp2 = 0;
    
    //atan2f 余弦
    tmp1 =  atan2f(x,z) * 180 / 3.1415926;
    tmp2 =  atan2f(y,z) * 180 / 3.1415926;
    
    if(fabs(tmp1) < 5){
        self.ziTaiX = 0;
    }
    else if((tmp1 >= 5) && (tmp1 <= 45)) { //左
        self.ziTaiX = -(int)(tmp1 - 5);
    }
    else if((tmp1 >= -45) && (tmp1 <= -5)) { //后
        self.ziTaiX = -(int)(tmp1+5);
    }

    if(fabs(tmp2) < 5){
        self.ziTaiY = 0;
    }
    else if((tmp2 >= 5) && (tmp2 <= 45)){ //右
        self.ziTaiY = (int)(tmp2 - 5);
    }
    else if((tmp2 >= -45) && (tmp2 <= -5)){ //左
        self.ziTaiY = (int)(tmp2 + 5);
    }
    
    NSLog(@"self.ziTaiX  %d",self.ziTaiX);
    NSLog(@"self.ziTaiY  %d",self.ziTaiY);
    
    if (self.ziTaiX > 0) { //前
        self.directionLabel.text = @"向前";
    }
    else if (self.ziTaiX < 0) {//后
        self.directionLabel.text = @"向后";
    }
    
    if (self.ziTaiY < 0) { //左
        self.directionLabel.text = @"向左";
    }
    else if (self.ziTaiY > 0) {//右
        self.directionLabel.text = @"向右";
    }
}

- (void)p_timerInvalidate {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
