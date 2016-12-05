//
//  NSString+AttributedString.m
//  TXScrollLabelViewDemo
//
//  Created by 陈应平 on 2016/12/5.
//  Copyright © 2016年 tingxins. All rights reserved.
//

#import "NSString+AttributedString.h"

@implementation NSString (AttributedString)

- (NSMutableAttributedString *)setAttributedWithIdentifyStringArray:(NSArray *)identifyStringArray color:(UIColor *)color font:(UIFont *)font
{
    if (!self && !identifyStringArray) {
        return nil;
    }
    
    if (!identifyStringArray.count) {
        return nil;
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    for (NSString *identifyString in identifyStringArray) {
        NSRange range = [self rangeOfString:identifyString];
        if (font) {
            [attributedStr addAttribute:NSFontAttributeName value:font range:range];
        }
        if (color) {
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
    }
    
    return attributedStr;
}

@end
