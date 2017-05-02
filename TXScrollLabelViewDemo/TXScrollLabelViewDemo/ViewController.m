//
//  ViewController.m
//  TXScrollLabelViewDemo
//
//  Created by tingxins on 20/10/2016.
//  Copyright © 2016 tingxins. All rights reserved.
//

#import "ViewController.h"
#import "TXScrollLabelView.h"

@interface ViewController ()<TXScrollLabelViewDelegate>

@property (weak, nonatomic) TXScrollLabelView *scrollLabelView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewInfos];
    
    [self setSubviews];
    
}

- (void)setViewInfos {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"TXScrollLabelView";
}

- (void)setSubviews {
    
    [self addWith:TXScrollLabelViewTypeLeftRight velocity:1];
    
    [self addWith:TXScrollLabelViewTypeUpDown velocity:1];
    
    [self addWith:TXScrollLabelViewTypeFlipRepeat velocity:2];
    
    [self addWith:TXScrollLabelViewTypeFlipNoRepeat velocity:2];
}

- (void)addWith:(TXScrollLabelViewType)type velocity:(CGFloat)velocity {
    /** Step1: 滚动文字 */
    NSString *scrollTitle = @"If you don't control the image server you're using, you may not be able to change the URL when its content is updated. This is the case for Facebook avatar URLs for instance. In such case, you may use the SDWebImageRefreshCached flag. This will slightly degrade the performance but will respect the HTTP caching control headers";
    
    /** Step2: 创建 ScrollLabelView */
    TXScrollLabelView *scrollLabelView = [TXScrollLabelView scrollWithTitle:scrollTitle type:type velocity:velocity options:UIViewAnimationOptionCurveEaseInOut];
    
    /** Step3: 设置代理进行回调 */
    scrollLabelView.scrollLabelViewDelegate = self;
    
    /** Step4: 布局(Required) */
    scrollLabelView.frame = CGRectMake(50, 100 * (type + 0.7), 300, 30);
    
    [self.view addSubview:scrollLabelView];
    
    //偏好(Optional), Preference,if you want.
    scrollLabelView.tx_centerX  = [UIScreen mainScreen].bounds.size.width * 0.5;
    scrollLabelView.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 10);
    scrollLabelView.scrollSpace = 10;
    scrollLabelView.font = [UIFont systemFontOfSize:15];
    scrollLabelView.textAlignment = NSTextAlignmentCenter;
    scrollLabelView.backgroundColor = [UIColor blackColor];
    scrollLabelView.layer.cornerRadius = 5;
    
    /** Step5: 开始滚动(Start scrolling!) */
    [scrollLabelView beginScrolling];
}

- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text{
    NSLog(@"%@",text);
}

@end
