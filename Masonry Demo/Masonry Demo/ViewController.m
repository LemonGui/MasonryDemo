//
//  ViewController.m
//  Masonry Demo
//
//  Created by Lemon on 16/10/28.
//  Copyright © 2016年 Lemon. All rights reserved.
//

//MAS_SHORTHAND:只要在导入Masonry主头文件之前定义这个宏, 那么以后在使用Masonry框架中的属性和方法的时候, 就可以省略mas_前缀
//#define MAS_SHORTHAND

//MAS_SHORTHAND_GLOBALS:只要在导入Masonry主头文件之前定义这个宏,那么就可以让equalTo函数接收基本数据类型, 内部会对基本数据类型进行包装
//#define MAS_SHORTHAND_GLOBALS

#import "ViewController.h"
#import "Masonry.h"
@interface ViewController ()
@property (nonatomic,strong) UIView * redView;
@property (nonatomic,strong) UIView * blueView;
@property (nonatomic,strong) UIView * yellowView;

@property (nonatomic, strong) UIButton *growingButton;
@property (nonatomic, strong) UIButton *expandButton;
@property (nonatomic, assign) CGFloat scacle;
@property (nonatomic, assign) BOOL isExpand;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
    
//    //priority优先级应用
//    [self test2];
//    
//    ////基本应用
//    [self test3];
//    
//    //multipliedBy 比例
//    [self test4];
//    
//    //更新约束
//    [self test5];
//    
//    //重写约束
//    [self test6];
    
}

// 点击屏幕移除蓝色View
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.blueView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}


//重写约束
-(void)test6{
    _isExpand = NO;
    self.growingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.growingButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.growingButton setBackgroundColor:[UIColor grayColor]];
    [self.growingButton setTitle:@"点我展开" forState:UIControlStateNormal];
    [self.growingButton addTarget:self action:@selector(expandButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.growingButton];
    [self.growingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-350);
    }];
}

//重写约束
-(void)expandButtonTaped:(UIButton *)sender{
    self.isExpand = !_isExpand;
    
    NSString * title = _isExpand ? @"点我收起":@"点我展开";
    [self.growingButton setTitle:title forState:UIControlStateNormal];
    
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

//更新约束
- (void)test5 {
    self.growingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.growingButton setTitle:@"点我放大" forState:UIControlStateNormal];
    self.growingButton.layer.borderColor = UIColor.greenColor.CGColor;
    self.growingButton.layer.borderWidth = 3;
    [self.growingButton addTarget:self action:@selector(onGrowButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.growingButton];
    self.scacle = 1.0;
    [self.growingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        // 初始宽、高为100，优先级最低
        make.width.height.mas_equalTo(100 * self.scacle);
        // 最大放大到整个view
        make.width.height.lessThanOrEqualTo(self.view);
    }];
}


- (void)onGrowButtonTaped:(UIButton *)sender {
    self.scacle += 1.0;
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 重写该方法来更新约束
-(void)updateViewConstraints{
    [super updateViewConstraints];
    //test5  更新约束
//    [self.growingButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        // 这里写需要更新的约束，不用更新的约束将继续存在
//        // 不会被取代，如：其宽高小于屏幕宽高不需要重新再约束
//        make.width.height.mas_equalTo(100 * self.scacle);
//    }];
    
    
     //test6 重写全部约束，之前的约束都将失效
     CGFloat offset = self.isExpand ? 0 : -350;
    [self.growingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(offset);
    }];

}

//multipliedBy 比例
-(void)test4{
    UIView *topView = [[UIView alloc]init];
    [topView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:topView];
    
    UIView *topInnerView = [[UIView alloc]init];
    [topInnerView setBackgroundColor:[UIColor greenColor]];
    [topView addSubview:topInnerView];
    
    UIView *bottomView = [[UIView alloc]init];
    [bottomView setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:bottomView];
    
    UIView *bottomInnerView = [[UIView alloc]init];
    [bottomInnerView setBackgroundColor:[UIColor blueColor]];
    [bottomView addSubview:bottomInnerView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(bottomView);
    }];
    [topInnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(topView.mas_height).multipliedBy(0.3);
        make.center.mas_equalTo(topView);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(topView);
        make.top.mas_equalTo(topView.mas_bottom);
    }];
    [bottomInnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.height.mas_equalTo(bottomInnerView.mas_width).multipliedBy(3);
        make.center.mas_equalTo(bottomView);
    }];

}

//基本应用
-(void)test3{
    
    int podding = 15;
    
    UIView * redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    UIView * blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueView];
    
    UIView * greenView = [[UIView alloc] init];
    greenView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:greenView];
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(podding);
        make.top.equalTo(self.view.mas_top).offset(2*podding);
        make.width.equalTo(blueView);
        make.bottom.equalTo(greenView.mas_top).offset(-podding);
    }];
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(redView);
        make.left.equalTo(redView.mas_right).offset(podding);
        make.right.equalTo(self.view.mas_right).offset(-podding);
        make.bottom.equalTo(redView);
    }];
    
    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(redView.mas_left);
        make.right.equalTo(blueView.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-podding);
        make.height.equalTo(redView);
    }];

}

//priority优先级应用
-(void)test2{
    
    UIView * redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    self.redView = redView;
    
    UIView * blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueView];
    self.blueView = blueView;
    
    UIView * yellowView = [[UIView alloc] init];
    yellowView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:yellowView];
    self.yellowView = yellowView;
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.height.mas_equalTo(50);
    }];
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(redView.mas_right).offset(40);
        make.bottom.width.height.equalTo(redView);
    }];
    
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blueView.mas_right).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.bottom.width.height.equalTo(redView);
        
        // 优先级设置为250，最高1000（默认）
        make.left.equalTo(redView.mas_right).offset(20).priority(250);
    }];
}

-(void)test1{
    UIView * view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(60);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
    }];
    
    //    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(60, 20, 40, 20));
    //    }];
}



@end
