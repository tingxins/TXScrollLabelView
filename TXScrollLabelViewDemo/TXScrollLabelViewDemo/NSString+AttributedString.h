//
//  NSString+AttributedString.h
//  TXScrollLabelViewDemo
//
//  Created by 陈应平 on 2016/12/5.
//  Copyright © 2016年 tingxins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (AttributedString)

// 传递一个字符串数组，可以渲染不同的颜色，后期有需要可以把 color 和 font 也以数组的形式传递，配对使用
- (NSMutableAttributedString *)setAttributedWithIdentifyStringArray:(NSArray *)identifyStringArray color:(UIColor *)color font:(UIFont *)font;

@end
