//
//  TXScrollLabelView.h
//
//  Created by tingxins on 2/23/16.
//  Copyright © 2016 tingxins. All rights reserved.
//  滚动视图

typedef enum {
    TXScrollLabelViewType_LR,
    TXScrollLabelViewType_UD,
    TXScrollLabelViewType_Flip,
    TXScrollLabelViewType_FlipNoCle
}TXScrollLabelViewType;

#import <UIKit/UIKit.h>

@interface TXScrollLabelView : UIScrollView

#pragma mark - Property
/** 滚动文字 */
@property (copy, nonatomic) NSString *scrollTitle;
/** 滚动类型 */
@property (assign, nonatomic) TXScrollLabelViewType scrollType;
/** 滚动速率 */
@property (assign, nonatomic) NSTimeInterval scrollVelocity;

#pragma mark - Methods
/**
 *  开始滚动
 */
- (void) beginScrolling;
/**
 *  停止滚动
 */
- (void) stopScrolling;

/**
 *  暂停滚动
 */
- (void) pauseScrolling;

@end
