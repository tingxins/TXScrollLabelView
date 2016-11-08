//
//  TXScrollLabelView.m
//
//  Created by tingxins on 2/23/16.
//  Copyright © 2016 tingxins. All rights reserved.
//

#define TXScrollLabelFont [UIFont systemFontOfSize:14]
#import "TXScrollLabelView.h"
#import <CoreText/CoreText.h>

static const NSInteger TXScrollDefaultTimeInterval = 2.0;//滚动默认时间

@interface NSTimer (TXTimerTarget)

+ (NSTimer *)tx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeat:(BOOL)yesOrNo block:(void(^)(NSTimer *timer))block;

@end


@implementation NSTimer (TXTimerTarget)

+ (NSTimer *)tx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeat:(BOOL)yesOrNo block:(void (^)(NSTimer *))block{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(startTimer:) userInfo:[block copy] repeats:yesOrNo];
}

+ (void)startTimer:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end

@interface TXScrollLabelView ()

@property (assign, nonatomic) UIViewAnimationOptions options;

@property (weak, nonatomic) UILabel *upLabel;

@property (weak, nonatomic) UILabel *downLabel;
//定时器
@property (strong, nonatomic) NSTimer *scrollTimer;
//文本行分割数组
@property (strong, nonatomic) NSArray *scrollArray;

@end

@implementation TXScrollLabelView

#pragma mark - init Methods

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        /** Default BgColor. */
        self.backgroundColor = [UIColor blackColor];
        
        UILabel *upLabel = [[UILabel alloc]init];
        upLabel.numberOfLines = 0;
        self.upLabel = upLabel;
        self.upLabel.font = TXScrollLabelFont;
        self.upLabel.textColor = [UIColor whiteColor];
        [self addSubview:upLabel];
        
        UILabel *downLabel = [[UILabel alloc]init];
        downLabel.numberOfLines = 0;
        self.downLabel = downLabel;
        self.downLabel.font = TXScrollLabelFont;
        self.downLabel.textColor = [UIColor whiteColor];
        [self addSubview:downLabel];
        
        upLabel.lineBreakMode = NSLineBreakByWordWrapping;
        downLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        upLabel.textAlignment = NSTextAlignmentCenter;
        downLabel.textAlignment = NSTextAlignmentCenter;
        self.scrollEnabled = NO;
    }
    return self;
}

- (instancetype)initWithScrollTitle:(NSString *)scrollTitle
                         scrollType:(TXScrollLabelViewType)scrollType
                     scrollVelocity:(NSTimeInterval)scrollVelocity
                            options:(UIViewAnimationOptions)options {
    if (self = [super init]) {
        self.tx_scrollTitle = scrollTitle;
        self.tx_scrollType = scrollType;
        self.tx_scrollVelocity = scrollVelocity;
        self.options = options;
    }
    return self;
}

+ (instancetype)tx_setScrollTitle:(NSString *)scrollTitle {
    
    return [self tx_setScrollTitle:scrollTitle
                        scrollType:TXScrollLabelViewTypeLeftRight];
}

+ (instancetype)tx_setScrollTitle:(NSString *)scrollTitle
                       scrollType:(TXScrollLabelViewType)scrollType {
    
    return [self tx_setScrollTitle:scrollTitle
                        scrollType:scrollType
                    scrollVelocity:TXScrollDefaultTimeInterval];
}

+ (instancetype)tx_setScrollTitle:(NSString *)scrollTitle
                       scrollType:(TXScrollLabelViewType)scrollType
                   scrollVelocity:(NSTimeInterval)scrollVelocity {
    
    return [self tx_setScrollTitle:scrollTitle
                        scrollType:scrollType
                    scrollVelocity:scrollVelocity
                           options:UIViewAnimationOptionCurveEaseInOut];
}

+ (instancetype)tx_setScrollTitle:(NSString *)scrollTitle
                       scrollType:(TXScrollLabelViewType)scrollType
                   scrollVelocity:(NSTimeInterval)scrollVelocity
                          options:(UIViewAnimationOptions)options {
    
    return [[self alloc] initWithScrollTitle:scrollTitle
                                  scrollType:scrollType
                              scrollVelocity:scrollVelocity
                                     options:options];
}

#pragma mark - Getter & Setter Methods

- (UIViewAnimationOptions)options {
    if (_options) return _options;
    return _options = UIViewAnimationOptionCurveEaseInOut;
}

- (NSArray *)scrollArray {
    if (_scrollArray) return _scrollArray;
    return _scrollArray = [self getSeparatedLinesFromLabel];
}

- (void)setTx_scrollContentSize:(CGRect)tx_scrollContentSize{
    _tx_scrollContentSize = tx_scrollContentSize;
    self.frame = _tx_scrollContentSize;
    [self setupSubviewsLayout];
}

- (void)setTx_scrollTitleColor:(UIColor *)tx_scrollTitleColor {
    _tx_scrollTitleColor = tx_scrollTitleColor;
    self.upLabel.textColor = _tx_scrollTitleColor;
    self.downLabel.textColor = _tx_scrollTitleColor;
}

#pragma mark - SubviewsLayout Methods
//,,,
- (void)setupSubviewsLayout {
    switch (_tx_scrollType) {
        case TXScrollLabelViewTypeLeftRight:
        {
            CGSize scrollLabelS = [_tx_scrollTitle boundingRectWithSize:CGSizeMake(0, self.tx_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: TXScrollLabelFont} context:nil].size;
            self.upLabel.frame = CGRectMake(10, 0, scrollLabelS.width, self.tx_height);
            self.upLabel.text = _tx_scrollTitle;
            
            self.downLabel.frame = CGRectMake(CGRectGetMaxX(self.upLabel.frame) + 20, 0, scrollLabelS.width, self.tx_height);
            self.downLabel.text = _tx_scrollTitle;
            self.contentSize = CGSizeMake(scrollLabelS.width * 2 + 40, scrollLabelS.height);
            self.bounds = CGRectMake(0, 0, MIN(self.tx_width, scrollLabelS.width), self.tx_height);
        }
            break;
            
        case TXScrollLabelViewTypeUpDown:
        {
            
            CGSize scrollLabelS = [_tx_scrollTitle boundingRectWithSize:CGSizeMake(self.tx_width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: TXScrollLabelFont} context:nil].size;
            CGFloat scrollLabelH = MAX(scrollLabelS.height, self.tx_height);
            self.upLabel.frame = CGRectMake(0, 0, scrollLabelS.width, scrollLabelH);
            self.upLabel.text = _tx_scrollTitle;
            
            self.downLabel.frame = CGRectMake(0, CGRectGetMaxY(self.upLabel.frame), scrollLabelS.width, scrollLabelH);
            self.downLabel.text = _tx_scrollTitle;
            self.contentSize = CGSizeMake(scrollLabelS.width, scrollLabelH * 2);
            self.bounds = CGRectMake(0, 0, MIN(self.tx_width, scrollLabelS.width), self.tx_height);
        }
            break;
            
        case TXScrollLabelViewTypeFlipRepeat:
        {
            CGSize scrollLabelS = [_tx_scrollTitle boundingRectWithSize:CGSizeMake(self.tx_width, self.tx_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: TXScrollLabelFont} context:nil].size;
            self.upLabel.frame = CGRectMake(0, 0, scrollLabelS.width, self.tx_height);
            self.upLabel.text = _tx_scrollTitle;
            
            self.downLabel.frame = CGRectMake(0, CGRectGetMaxY(self.upLabel.frame), scrollLabelS.width, self.tx_height);;
            self.downLabel.text = _tx_scrollTitle;
            self.contentSize = CGSizeMake(scrollLabelS.width, scrollLabelS.height * 2);
            self.bounds = CGRectMake(0, 0, MIN(self.tx_width, scrollLabelS.width), self.tx_height);
        }
            break;
            
            
        case TXScrollLabelViewTypeFlipNoRepeat:
        {
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
            paraStyle.lineSpacing = 10;
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:_tx_scrollTitle];
            [attributedStr addAttributes:@{NSFontAttributeName:TXScrollLabelFont, NSParagraphStyleAttributeName:paraStyle} range:NSMakeRange(0, attributedStr.length)];
            
            CGSize scrollLabelS = [attributedStr boundingRectWithSize:CGSizeMake(self.tx_width, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            
            self.upLabel.frame = CGRectMake(0, 0, scrollLabelS.width, self.tx_height);
            self.downLabel.frame = CGRectMake(0, CGRectGetMaxY(self.upLabel.frame), scrollLabelS.width, self.tx_height);
            
            CGFloat width = scrollLabelS.width;
            if (!self.tx_width) {
                self.tx_width = width;
            }
            self.contentSize = CGSizeMake(self.tx_width, scrollLabelS.height * 2);
            self.bounds = CGRectMake(0, 0, MIN(self.tx_width, scrollLabelS.width), self.tx_height);
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Scrolling Operation Methods

- (void)beginScrolling {
    [self endScrolling];
    
    __weak typeof(self) weakSelf = self;
    self.scrollTimer = [NSTimer tx_scheduledTimerWithTimeInterval:0.1 repeat:YES block:^(NSTimer *timer) {
        TXScrollLabelView *strongSelf = weakSelf;
        if (strongSelf) {
            [self updateScrolling];
        }
    }];
    
    [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
}

- (void)endScrolling {
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

- (void)pauseScrolling {
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

#pragma mark - Scrolling Animation Methods

- (void)updateScrolling {
    __weak typeof(self) weakSelf = self;
    switch (self.tx_scrollType) {
        case TXScrollLabelViewTypeLeftRight:
        {
            if (self.contentSize.width * 0.5 == self.contentOffset.x || self.contentOffset.x > self.contentSize.width * 0.5) {
                [self endScrolling];
                self.contentOffset = CGPointMake(2, 0);//x增加偏移量，防止卡顿
                [self beginScrolling];
                return;
            }
            self.contentOffset = CGPointMake(self.contentOffset.x + 1, self.contentOffset.y);
            
        }
            break;
            
        case TXScrollLabelViewTypeUpDown:
        {
            if (self.contentOffset.y > self.upLabel.frame.size.height) {
                [self endScrolling];
                self.contentOffset = CGPointMake(0, 2);//y增加偏移量，防止卡顿
                [self beginScrolling];
                return;
            }
            self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + 1);
            
        }
            break;
            
        case TXScrollLabelViewTypeFlipRepeat:
        {
            
            [self endScrolling];
            
            NSTimeInterval velocity = self.tx_scrollVelocity ? self.tx_scrollVelocity : 2;
            
            self.scrollTimer = [NSTimer tx_scheduledTimerWithTimeInterval:velocity repeat:YES block:^(NSTimer *timer) {
                TXScrollLabelView *strongSelf = weakSelf;
                if (strongSelf) {
                    [self updateScrolling];
                }
            }];
            
            [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
            
            [self flipAnimationWithDelay:velocity];
        }
            break;
            
        case TXScrollLabelViewTypeFlipNoRepeat:
        {
            
            [self endScrolling];
            
            NSTimeInterval velocity = self.tx_scrollVelocity ? self.tx_scrollVelocity : 2;
            
            self.scrollTimer = [NSTimer tx_scheduledTimerWithTimeInterval:velocity repeat:YES block:^(NSTimer *timer) {
                TXScrollLabelView *strongSelf = weakSelf;
                if (strongSelf) {
                    [self updateScrolling];
                }
            }];
            
            [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
            
            [self flipNoCleAnimationWithDelay:velocity];
        }
            break;
            
        default:
            break;
    }
}

- (void)flipAnimationWithDelay:(NSTimeInterval)delay {
    [UIView transitionWithView:self.upLabel duration:delay * 0.5 options:self.options animations:^{
        self.upLabel.tx_bottom = 0;
        [UIView transitionWithView:self.upLabel duration:delay * 0.5 options:self.options animations:^{
            self.downLabel.tx_y = 0;
        } completion:^(BOOL finished) {
            self.upLabel.tx_y = self.tx_height;
            UILabel *tempLabel = self.upLabel;
            self.upLabel = self.downLabel;
            self.downLabel = tempLabel;
        }];
    } completion:nil];
}

- (void)flipNoCleAnimationWithDelay:(NSTimeInterval)delay {
    static int count = 0;
    self.upLabel.text = self.scrollArray[count];
    count ++;
    if (count == self.scrollArray.count) count = 0;
    self.downLabel.text = self.scrollArray[count];
    [self flipAnimationWithDelay:delay];
}

#pragma mark - 文本行分割

-(NSArray *)getSeparatedLinesFromLabel {
    
    NSString *text = _tx_scrollTitle;
    UIFont *font = [UIFont systemFontOfSize:15];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, NULL, CGRectMake(0,0,self.tx_width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines) {
        
        CTLineRef lineRef = (__bridge CTLineRef )line;
        
        CFRange lineRange = CTLineGetStringRange(lineRef);
        
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}

- (void)dealloc {
    [self endScrolling];
}

@end
