//
//  ViewController.m
//  TXScrollLabelViewDemo
//
//  Created by tingxins on 20/10/2016.
//  Copyright © 2016 tingxins. All rights reserved.
//

#import "ViewController.h"
#import "TXScrollLabelView.h"

@interface ViewController ()

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
    
    for (int options = 0; options < 4; ++ options) {
        NSString *scrollTitle = @"If you don't control the image server you're using, you may not be able to change the URL when its content is updated. This is the case for Facebook avatar URLs for instance. In such case, you may use the SDWebImageRefreshCached flag. This will slightly degrade the performance but will respect the HTTP caching control headers";
        //options 是 TXScrollLabelViewType 枚举类型， 此处仅为了方便举例
        TXScrollLabelView *scrollLabelView = [TXScrollLabelView tx_setScrollTitle:scrollTitle scrollType:options scrollVelocity:3 options:UIViewAnimationOptionTransitionFlipFromTop];
        [self.view addSubview:scrollLabelView];
        
        //布局(Required)
        scrollLabelView.frame = CGRectMake(50, 100 * (options + 0.7), 300, 30);
        
        //偏好(Optional)
        scrollLabelView.tx_centerX  = [UIScreen mainScreen].bounds.size.width * 0.5;
        scrollLabelView.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 10);
        scrollLabelView.scrollSpace = 10;
        scrollLabelView.font = [UIFont systemFontOfSize:15];
        scrollLabelView.textAlignment = NSTextAlignmentCenter;
        scrollLabelView.backgroundColor = [UIColor blackColor];
        scrollLabelView.layer.cornerRadius = 5;
        
        //开始滚动
        [scrollLabelView beginScrolling];
        self.scrollLabelView = scrollLabelView;
    }
}


@end
