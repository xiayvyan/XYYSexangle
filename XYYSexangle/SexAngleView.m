//
//  SexAngleView.m
//  XYYSexangle
//
//  Created by 摇果 on 2017/9/1.
//  Copyright © 2017年 摇果. All rights reserved.
//

#import "SexAngleView.h"

#define ViewWidth0 250.0
#define ViewWidth1 280.0
#define Space 5.0 //圆角大小
#define Mx(viewWidth) (ScreenWidth-viewWidth)/2.0
#define My(viewWidth) (ScreenHeight-viewWidth)/2.0
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface SexAngleView ()
{
    CGPoint _point0;
    CGPoint _point1;
    CGPoint _point2;
    CGPoint _point3;
    CGPoint _point4;
    CGPoint _point5;
    CGPoint _Point0;
    CGPoint _Point1;
    CGPoint _Point2;
    CGPoint _Point3;
    CGPoint _Point4;
    CGPoint _Point5;
    
    CGFloat _a01;
    CGFloat _b01;
    CGFloat _a12;
    CGFloat _b12;
    CGFloat _a34;
    CGFloat _b34;
    
    CGFloat _A01;
    CGFloat _B01;
    CGFloat _A12;
    CGFloat _B12;
    CGFloat _A34;
    CGFloat _B34;
    CGFloat _A45;
    CGFloat _B45;
}
@property (nonatomic, strong) NSMutableArray *layers;

@property (nonatomic, strong) UIBezierPath *animaPath;

@end

@implementation SexAngleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatPoint];
        [self calculateSmall];
        [self drawRect:frame];
    }
    return self;
}

#pragma mark - 绘制Layer层
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    
    UIBezierPath *bezierPath = [self creatPathViewWidth:ViewWidth0];
    [path appendPath:bezierPath];
    [path setUsesEvenOddFillRule:YES];
    
    //蒙版背景填充
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.3;
    [self.layer addSublayer:fillLayer];
    
    //六边形边框及镂空
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.lineWidth = 1.5;
    shapLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapLayer.fillColor = [UIColor clearColor].CGColor;
    shapLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:shapLayer];
    
    //动画路径
    _animaPath = [self creatPathViewWidth:ViewWidth1];
}

- (void)starAnimation {
    
    for (CALayer *layer in self.layers) {
        [layer removeFromSuperlayer];
    }
    for (int i = 0; i < 300; i++) {
        CFTimeInterval beginTime = CACurrentMediaTime() + (0.003 * i);
        [self pathAnimation:beginTime withIndex:i];
    }
}

#pragma mark - 动画
- (void)pathAnimation:(CFTimeInterval)beginTime withIndex:(NSInteger)index {
    
    CALayer *carLayer = [[CALayer alloc] init];
    carLayer.frame = CGRectMake(0, -2, 2, 2);
    if (index < 150) {
        carLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"line"].CGImage);
    }else{
        carLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"line1"].CGImage);
    }
    [self.layer addSublayer:carLayer];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 绘制路径（动画）
    animation.path = _animaPath.CGPath;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 2.5;
    animation.beginTime = beginTime;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = NO;
    animation.calculationMode = kCAAnimationCubicPaced;
    animation.rotationMode = kCAAnimationRotateAuto;
    [carLayer addAnimation:animation forKey:@"carAnimation"];
    
    [self.layers addObject:carLayer];
}

#pragma mark - 绘制六边形
- (UIBezierPath *)creatPathViewWidth:(CGFloat)viewWidth {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (viewWidth == ViewWidth0) {
        //内六边形
        CGPoint point0 = CGPointMake(_point0.x+15, _a01*(_point0.x+15)+_b01);
        CGPoint point1 = CGPointMake(_point1.x-Space, _a01*(_point1.x-Space)+_b01);
        CGPoint point2 = CGPointMake(_point1.x+Space, point1.y);
        CGPoint point3 = CGPointMake(_point2.x-Space, _a12*(_point2.x-Space)+_b12);
        CGPoint point4 = CGPointMake(_point2.x, _point2.y+(Space/cos(M_1_PI/180*60)));
        CGPoint point5 = CGPointMake(_point3.x, _point3.y-(Space/cos(M_1_PI/180*60)));
        CGPoint point6 = CGPointMake(point3.x, _a34*point3.x+_b34);
        CGPoint point7 = CGPointMake(point2.x, _a34*point2.x+_b34);
        CGPoint point8 = CGPointMake(point1.x, point7.y);
        CGPoint point9 = CGPointMake(_point0.x+Space, point6.y);
        CGPoint point10 = CGPointMake(_point0.x, point5.y);
        CGPoint point11 = CGPointMake(_point0.x, point4.y);
        CGPoint point12 = CGPointMake(point9.x, point3.y);
        [bezierPath moveToPoint:point0];
        [bezierPath addLineToPoint:point1];
        [bezierPath addQuadCurveToPoint:point2 controlPoint:_point1];
        [bezierPath addLineToPoint:point3];
        [bezierPath addQuadCurveToPoint:point4 controlPoint:_point2];
        [bezierPath addLineToPoint:point5];
        [bezierPath addQuadCurveToPoint:point6 controlPoint:_point3];
        [bezierPath addLineToPoint:point7];
        [bezierPath addQuadCurveToPoint:point8 controlPoint:_point4];
        [bezierPath addLineToPoint:point9];
        [bezierPath addQuadCurveToPoint:point10 controlPoint:_point5];
        [bezierPath addLineToPoint:point11];
        [bezierPath addQuadCurveToPoint:point12 controlPoint:_point0];
        [bezierPath closePath];
    }else{
        //外六边形
        CGPoint point0 = CGPointMake(_Point0.x+15, _A01*(_Point0.x+15)+_B01);
        CGPoint point1 = CGPointMake(_Point1.x-Space, _A01*(_Point1.x-Space)+_B01);
        CGPoint point2 = CGPointMake(_Point1.x+Space, point1.y);
        CGPoint point3 = CGPointMake(_Point2.x-Space, _A12*(_Point2.x-Space)+_B12);
        CGPoint point4 = CGPointMake(_Point2.x, _Point2.y+(Space/cos(M_1_PI/180*60)));
        CGPoint point5 = CGPointMake(_Point3.x, _Point3.y-(Space/cos(M_1_PI/180*60)));
        CGPoint point6 = CGPointMake(point3.x, _A34*point3.x+_B34);
        CGPoint point7 = CGPointMake(point2.x, _A34*point2.x+_B34);
        CGPoint point8 = CGPointMake(point1.x, point7.y);
        CGPoint point9 = CGPointMake(_Point0.x+Space, point6.y);
        CGPoint point10 = CGPointMake(_Point0.x, point5.y);
        CGPoint point11 = CGPointMake(_Point0.x, point4.y);
        CGPoint point12 = CGPointMake(point9.x, point3.y);
        [bezierPath moveToPoint:point0];
        [bezierPath addLineToPoint:point1];
        [bezierPath addQuadCurveToPoint:point2 controlPoint:_Point1];
        [bezierPath addLineToPoint:point3];
        [bezierPath addQuadCurveToPoint:point4 controlPoint:_Point2];
        [bezierPath addLineToPoint:point5];
        [bezierPath addQuadCurveToPoint:point6 controlPoint:_Point3];
        [bezierPath addLineToPoint:point7];
        [bezierPath addQuadCurveToPoint:point8 controlPoint:_Point4];
        [bezierPath addLineToPoint:point9];
        [bezierPath addQuadCurveToPoint:point10 controlPoint:_Point5];
        [bezierPath addLineToPoint:point11];
        [bezierPath addQuadCurveToPoint:point12 controlPoint:_Point0];
        [bezierPath closePath];
    }
    return bezierPath;
}

#pragma mark - 六边形顶点坐标
- (void)creatPoint {
    //左上角为------point0-------
    _point0 = CGPointMake((sin(M_1_PI / 180 * 60)) * (ViewWidth0 / 2)+Mx(ViewWidth0), (ViewWidth0 / 4)+My(ViewWidth0));
    _point1 = CGPointMake((ViewWidth0 / 2)+Mx(ViewWidth0), 0+My(ViewWidth0));
    _point2 = CGPointMake(ViewWidth0 - ((sin(M_1_PI / 180 * 60)) * (ViewWidth0 / 2))+Mx(ViewWidth0), (ViewWidth0 / 4)+My(ViewWidth0));
    _point3 = CGPointMake(ViewWidth0 - ((sin(M_1_PI / 180 * 60)) * (ViewWidth0 / 2))+Mx(ViewWidth0), (ViewWidth0 / 2) + (ViewWidth0 / 4)+My(ViewWidth0));
    _point4 = CGPointMake((ViewWidth0 / 2)+Mx(ViewWidth0), ViewWidth0+My(ViewWidth0));
    _point5 = CGPointMake((sin(M_1_PI / 180 * 60)) * (ViewWidth0 / 2)+Mx(ViewWidth0), (ViewWidth0 / 2) + (ViewWidth0 / 4)+My(ViewWidth0));
    
    
    _Point0 = CGPointMake((sin(M_1_PI / 180 * 60)) * (ViewWidth1 / 2)+Mx(ViewWidth1), (ViewWidth1 / 4)+My(ViewWidth1));
    _Point1 = CGPointMake((ViewWidth1 / 2)+Mx(ViewWidth1), 0+My(ViewWidth1));
    _Point2 = CGPointMake(ViewWidth1 - ((sin(M_1_PI / 180 * 60)) * (ViewWidth1 / 2))+Mx(ViewWidth1), (ViewWidth1 / 4)+My(ViewWidth1));
    _Point3 = CGPointMake(ViewWidth1 - ((sin(M_1_PI / 180 * 60)) * (ViewWidth1 / 2))+Mx(ViewWidth1), (ViewWidth1 / 2) + (ViewWidth1 / 4)+My(ViewWidth1));
    _Point4 = CGPointMake((ViewWidth1 / 2)+Mx(ViewWidth1), ViewWidth1+My(ViewWidth1));
    _Point5 = CGPointMake((sin(M_1_PI / 180 * 60)) * (ViewWidth1 / 2)+Mx(ViewWidth1), (ViewWidth1 / 2) + (ViewWidth1 / 4)+My(ViewWidth1));
}

#pragma mark - 计算两点所在直线方程
- (void)calculateSmall {
    CGPoint point01 = [self calculateWithPoint0:_point0 point:_point1];
    _a01 = point01.x;
    _b01 = point01.y;
    
    CGPoint point12 = [self calculateWithPoint0:_point1 point:_point2];
    _a12 = point12.x;
    _b12 = point12.y;
    
    CGPoint point34 = [self calculateWithPoint0:_point3 point:_point4];
    _a34 = point34.x;
    _b34 = point34.y;
    
    
    CGPoint Point01 = [self calculateWithPoint0:_Point0 point:_Point1];
    _A01 = Point01.x;
    _B01 = Point01.y;
    
    CGPoint Point12 = [self calculateWithPoint0:_Point1 point:_Point2];
    _A12 = Point12.x;
    _B12 = Point12.y;
    
    CGPoint Point34 = [self calculateWithPoint0:_Point3 point:_Point4];
    _A34 = Point34.x;
    _B34 = Point34.y;
    
    CGPoint Point45 = [self calculateWithPoint0:_Point4 point:_Point5];
    _A45 = Point45.x;
    _B45 = Point45.y;
}

- (CGPoint)calculateWithPoint0:(CGPoint)point0 point:(CGPoint)point1 {
    
    CGFloat x0 = point0.x;
    CGFloat y0 = point0.y;
    
    CGFloat x1 = point1.x;
    CGFloat y1 = point1.y;
    
    CGFloat a = (y0-y1)/(x0-x1);
    CGFloat b = y0-(a*x0);
    
    CGPoint point = CGPointMake(a, b);
    return point;
}

#pragma mark - 
- (NSMutableArray *)layers {
    if (!_layers) {
        _layers = [NSMutableArray array];
    }
    return _layers;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
