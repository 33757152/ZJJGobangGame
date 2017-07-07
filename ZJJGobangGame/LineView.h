//
//  LineView.h
//  Demo
//
//  Created by 张锦江 on 2017/7/5.
//  Copyright © 2017年 ZJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic,assign) NSInteger line_width;

@property (nonatomic,assign) NSInteger oneSide;

@property (nonatomic,strong) NSMutableArray *resultMArray;

@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIButton *restartButton;

@property (nonatomic,strong) UIView *lastView;

@end
