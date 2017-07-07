//
//  ViewController.m
//  Demo
//
//  Created by 张锦江 on 2017/7/3.
//  Copyright © 2017年 ZJJ. All rights reserved.
//
#define   KSCREEN_WIDTH   self.view.frame.size.width
#define   KSCREEN_HEIGHT  self.view.frame.size.height

#import "ViewController.h"
#import "LineView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self creatUI];
    [self loadCustomGameView];
}

#pragma mark - 方法
- (void)creatUI {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 20, KSCREEN_WIDTH, 50);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"欢迎来到五子棋游戏";
    label.font = [UIFont systemFontOfSize:20.0f];
    [self.view addSubview:label];
}


- (void)loadCustomGameView {
    int item = KSCREEN_WIDTH/14;
    int viewWidth = 14*item;
    LineView *gameView = [[LineView alloc] initWithFrame:CGRectMake((KSCREEN_WIDTH-viewWidth)/2, 70, viewWidth, viewWidth+60)];
    gameView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:gameView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
