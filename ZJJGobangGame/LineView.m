//
//  LineView.m
//  Demo
//
//  Created by 张锦江 on 2017/7/5.
//  Copyright © 2017年 ZJJ. All rights reserved.
//
#define    VIEW_ID      100000

#import "LineView.h"

@implementation LineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    _oneSide = 0;
    _resultMArray = [NSMutableArray array];
    _line_width = self.frame.size.width/14;
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, self.frame.size.height-60, _line_width*14-200, 60)];
    self.tipLabel.backgroundColor = [UIColor lightGrayColor];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.font = [UIFont systemFontOfSize:20.0f];
    [self letBlackOneGo];
    [self addSubview:self.tipLabel];
    
    self.cancelButton = [self customButtonWithFrame:CGRectMake(0, self.tipLabel.frame.origin.y, 100, 60) backColor:[UIColor blackColor] withText:@"悔棋"];
    [self.cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    self.restartButton = [self customButtonWithFrame:CGRectMake(14*_line_width-100, self.tipLabel.frame.origin.y, 100, 60) backColor:[UIColor redColor] withText:@"重新开始"];
    [self.restartButton addTarget:self action:@selector(restartClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.restartButton];
}

- (void)restartClick {
    [self remakeTheViewInitialize];
}
- (void)cancelClick {
    if (_lastView) {
        [_lastView removeFromSuperview];
        _oneSide -= 1;
        _lastView = nil;
        if (_oneSide%2 == 0) {
            [self letBlackOneGo];
        }else {
            [self letWhiteOneGo];
        }
    }
}
- (UIButton *)customButtonWithFrame:(CGRect)rect backColor:(UIColor *)backColor withText:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = backColor;
    return button;
}
- (void)letBlackOneGo {
    self.tipLabel.text = @"黑子走";
    self.tipLabel.textColor = [UIColor blackColor];
}
- (void)letWhiteOneGo {
    self.tipLabel.text = @"白子走";
    self.tipLabel.textColor = [UIColor whiteColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ref, 0.3, 0.4, 0.3, 1);
    for (int i = 0; i<15; i++) {
        CGContextMoveToPoint(ref, _line_width*i, 0);
        CGContextAddLineToPoint(ref, _line_width*i, _line_width*14);
    }
    for (int i = 0; i<15; i++) {
        CGContextMoveToPoint(ref, 0, _line_width*i);
        CGContextAddLineToPoint(ref, 14*_line_width, _line_width*i);
    }
    CGContextStrokePath(ref);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.y<=_line_width*14) {
        [self creatUIWithPoint:point];
    }
}

- (void)creatUIWithPoint:(CGPoint)point {
    float x = point.x;
    float y = point.y;
    // 取整
    int a_x = x/_line_width;
    int b_y = y/_line_width;
    // 左面距离
    float left_x = x - a_x*_line_width;
    float left_y = y - b_y*_line_width;
    // 右面距离
    float right_x = (a_x+1)*_line_width-x;
    float right_y = (b_y+1)*_line_width-y;
    if (left_x<right_x) {
        x = a_x*_line_width;
    }else {
        x = (a_x+1)*_line_width;
    }
    if (left_y<right_y) {
        y = b_y*_line_width;
    }else {
        y = (b_y+1)*_line_width;
    }
    [self customUIWithX:x Y:y];
}
- (void)customUIWithX:(float)x Y:(float)y {
    NSInteger tagIndex = [self calculateTheTagWithX:x Y:y];
    UIView *originView = [self viewWithTag:tagIndex];
    if (originView) {
        return;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    view.layer.cornerRadius = 5;
    view.clipsToBounds = YES;
    view.center = CGPointMake(x, y);
    view.bounds = CGRectMake(0, 0, 10, 10);
    view.tag = tagIndex;
    [self addSubview:view];
    _lastView = view;
    if (_oneSide%2==1) {
        [self letBlackOneGo];
        view.backgroundColor = [UIColor whiteColor];
    }else {
        [self letWhiteOneGo];
    }
   // 开始检查
    [self beginToCheckIsWinWithColor:view.backgroundColor withX:x withY:y];
    _oneSide++;
}

- (NSInteger)calculateTheTagWithX:(float)x Y:(float)y {
    NSNumber *xN = [NSNumber numberWithFloat:x];
    NSNumber *yN = [NSNumber numberWithFloat:y];
    NSString *tagStr = [NSString stringWithFormat:@"%@%@",xN,yN];
    return [tagStr integerValue] + VIEW_ID;
}

- (void)beginToCheckIsWinWithColor:(UIColor *)currentColor withX:(float)x withY:(float)y {
    NSArray *horizontalArray = [self obtainHorizontalArrayWithX:x withY:y];
    NSArray *verticalArray = [self obtainVerticalArrayWithX:x withY:y];
    NSArray *obliqueIncressArray = [self obtainObliqueIncreaseArrayWithX:x withY:y];
    NSArray *obliqueReduceArray = [self obtainObliqueReduceArrayWithX:x withY:y];
    BOOL horizonBool = [self isWinWithArray:horizontalArray andCurrentColor:currentColor];
    if (horizonBool) {
        [self showResultWithTitle:@"水平方向" withColor:currentColor];
        return;
    }
    BOOL verticalBool = [self isWinWithArray:verticalArray andCurrentColor:currentColor];
    if (verticalBool) {
        [self showResultWithTitle:@"竖直方向" withColor:currentColor];
        return;
    }
    BOOL obliqueIncressBool = [self isWinWithArray:obliqueIncressArray andCurrentColor:currentColor];
    if (obliqueIncressBool) {
        [self showResultWithTitle:@"斜向上方向" withColor:currentColor];
        return;
    }
    BOOL obliqueReduceBool = [self isWinWithArray:obliqueReduceArray andCurrentColor:currentColor];
    if (obliqueReduceBool) {
        [self showResultWithTitle:@"斜向下方向" withColor:currentColor];
        return;
    }
}

- (NSArray *)obtainHorizontalArrayWithX:(float)x withY:(float)y {
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    for (float index = x-4*_line_width; index<=x+4*_line_width; index+=_line_width) {
        if (index>=0 && index<=14*_line_width) {
            UIView *view0 = [self viewWithTag:[self calculateTheTagWithX:index Y:y]];
            if (view0) {
                [dataArray addObject:view0];
            }
        }
    }
    return dataArray;
}

- (NSArray *)obtainVerticalArrayWithX:(NSInteger)x withY:(NSInteger)y {
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    for (float index = y-4*_line_width; index<=y+4*_line_width; index+=_line_width) {
        if (index>=0 && index<=14*_line_width) {
            UIView *view0 = [self viewWithTag:[self calculateTheTagWithX:x Y:index]];
            if (view0) {
                [dataArray addObject:view0];
            }
        }
    }
    return dataArray;
}

- (NSArray *)obtainObliqueIncreaseArrayWithX:(NSInteger)x withY:(NSInteger)y {
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    for (float index = x-4*_line_width; index<=x+4*_line_width; index+=_line_width) {
        if (index>=0 && index<=14*_line_width) {
            if (y-index+x>=0 && y-index+x<=14*_line_width) {
                UIView *view0 = [self viewWithTag:[self calculateTheTagWithX:index Y:y-index+x]];
                if (view0) {
                    [dataArray addObject:view0];
                }
            }
        }
    }
    return dataArray;
}

- (NSArray *)obtainObliqueReduceArrayWithX:(NSInteger)x withY:(NSInteger)y {
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    for (float index = x-4*_line_width; index<=x+4*_line_width; index+=_line_width) {
        if (index>=0 && index<=14*_line_width) {
            if (index-x+y>=0 && index-x+y<=14*_line_width) {
                UIView *view0 = [self viewWithTag:[self calculateTheTagWithX:index Y:index-x+y]];
                if (view0) {
                    [dataArray addObject:view0];
                }
            }
        }
    }
    return dataArray;
}

- (BOOL)isWinWithArray:(NSArray *)array andCurrentColor:(UIColor *)currentColor {
    if (array.count < 5) {
        return NO;
    }
    [_resultMArray removeAllObjects];
    for (UIView *subView in array) {
        if (subView.backgroundColor == currentColor) {
            [_resultMArray addObject:subView];
        }else {
            [_resultMArray removeAllObjects];
        }
        if (_resultMArray.count >= 5) {
            return YES;
        }
    }
    return NO;
}

- (void)showResultWithTitle:(NSString *)title withColor:(UIColor *)currentColor {
    [self whenOneSideWinMagnifyTheView];
    NSString *whoStr = @"黑子";
    if (currentColor == [UIColor whiteColor]) {
        whoStr = @"白子";
    }
    NSString *totalStr = [NSString stringWithFormat:@"^_^%@%@胜✌️",whoStr,title];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"比赛结果" message:totalStr preferredStyle:0];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"再战一局!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self remakeTheViewInitialize];
    }];
    [alert addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil] ;
}

- (void)remakeTheViewInitialize {
    for (UIView *subView in self.subviews) {
        _oneSide = 0;
        [self letBlackOneGo];
        [_resultMArray removeAllObjects];
        if (subView != self.tipLabel && subView != self.cancelButton && subView != self.restartButton) {
            [subView removeFromSuperview];
        }
    }
}
- (void)whenOneSideWinMagnifyTheView {
    for (UIView *subView in _resultMArray) {
        subView.bounds = CGRectMake(0, 0, 20, 20);
        subView.layer.cornerRadius = 10;
        subView.clipsToBounds = YES;
    }
}



@end
