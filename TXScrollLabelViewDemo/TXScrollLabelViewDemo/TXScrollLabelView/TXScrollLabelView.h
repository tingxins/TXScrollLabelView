//
//  TXScrollLabelView.h
//
//  Created by tingxins on 2/23/16.
//  Copyright © 2016 tingxins. All rights reserved.
//  滚动视图

#define TXScrollLabelViewDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#import <UIKit/UIKit.h>
#import "UIView+TXFrame.h"

@interface TXScrollLabelView : UIScrollView

typedef NS_ENUM(NSInteger, TXScrollLabelViewType) {
    TXScrollLabelViewTypeLeftRight = 0,
    TXScrollLabelViewTypeUpDown,
    TXScrollLabelViewTypeFlipRepeat,
    TXScrollLabelViewTypeFlipNoRepeat
};

#pragma mark - Property
/** 滚动文字 */
@property (copy, nonatomic) NSString *tx_scrollTitle;
/** 滚动类型 */
@property (assign, nonatomic) TXScrollLabelViewType tx_scrollType;
/** 滚动速率 */
@property (assign, nonatomic) NSTimeInterval tx_scrollVelocity;
/** 滚动显示范围 */
@property (assign, nonatomic) CGRect tx_scrollContentSize;
/** 文本颜色 */
@property (strong, nonatomic) UIColor *tx_scrollTitleColor;

#pragma mark - Class Methods

- (instancetype)initWithScrollTitle:(NSString *)scrollTitle
                         scrollType:(TXScrollLabelViewType)scrollType
                     scrollVelocity:(NSTimeInterval)scrollVelocity
                            options:(UIViewAnimationOptions)options;

+ (instancetype)tx_setScrollTitle:(NSString *)scrollTitle;

+ (instancetype)tx_setScrollTitle:(NSString *)scrollTitle
                       scrollType:(TXScrollLabelViewType)scrollType;

+ (instancetype)tx_setScrollTitle:(NSString *)scrollTitle
                       scrollType:(TXScrollLabelViewType)scrollType
                   scrollVelocity:(NSTimeInterval)scrollVelocity;
/**
 类初始化方法
 @param scrollTitle 滚动文本
 @param scrollType 滚动类型
 @param scrollVelocity 滚动速率
 @param options Now, supports the type of TXScrollLabelViewTypeFlipNoRepeat only.
 */
+ (instancetype)tx_setScrollTitle:(NSString *)scrollTitle
                       scrollType:(TXScrollLabelViewType)scrollType
                   scrollVelocity:(NSTimeInterval)scrollVelocity
                          options:(UIViewAnimationOptions)options;

#pragma mark - Operation Methods
/**
 *  开始滚动
 */
- (void) beginScrolling;
/**
 *  停止滚动
 */
- (void) endScrolling;

/**
 *  暂停滚动(暂不支持恢复)
 */
- (void) pauseScrolling;

@end
