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

#pragma mark - NSTimer+TXTimerTarget

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

#pragma mark - UILabel+TXLabel


@interface TXScrollLabel : UILabel

@property (assign, nonatomic) UIEdgeInsets contentInset;

@end

@implementation TXScrollLabel

- (instancetype)init {
    if (self = [super init]) {
        _contentInset = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _contentInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _contentInset)];
}

@end

@interface TXScrollLabel (TXLabel)

+ (instancetype)tx_label;

@end

@implementation TXScrollLabel (TXLabel)

+ (instancetype)tx_label {
    TXScrollLabel *label = [[TXScrollLabel alloc]init];
    label.numberOfLines = 0;
    label.font = TXScrollLabelFont;
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end

#pragma mark - TXScrollLabelView

@interface TXScrollLabelView ()

@property (assign, nonatomic) UIViewAnimationOptions options;

@property (weak, nonatomic) TXScrollLabel *upLabel;

@property (weak, nonatomic) TXScrollLabel *downLabel;
//定时器
@property (strong, nonatomic) NSTimer *scrollTimer;
//文本行分割数组
@property (strong, nonatomic) NSArray *scrollArray;

@end

@implementation TXScrollLabelView

@synthesize scrollSpace = _scrollSpace;

@synthesize font = _font;

#pragma mark - Preference Methods

- (void)setSomePreference {
    /** Default preference. */
    self.backgroundColor = [UIColor blackColor];
    self.scrollEnabled = NO;
}

- (void)setSomeSubviews {
    TXScrollLabel *upLabel = [TXScrollLabel tx_label];
    self.upLabel = upLabel;
    [self addSubview:upLabel];
    
    TXScrollLabel *downLabel = [TXScrollLabel tx_label];
    self.downLabel = downLabel;
    [self addSubview:downLabel];
}

#pragma mark - init Methods
/** Terminating app due to uncaught exception 'Warning TXScrollLabelView -[TXScrollLabelView init] unimplemented!', reason: 'unimplemented, use - tx_setScrollTitle:scrollType:scrollVelocity:options:'*/
- (instancetype)init {
    @throw [NSException exceptionWithName:[NSString stringWithFormat:@"Warning %@ %s unimplemented!", self.class, __func__] reason:@"unimplemented, please use - tx_setScrollTitle:scrollType:scrollVelocity:options:" userInfo:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setSomePreference];
        
        [self setSomeSubviews];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)scrollTitle
                         scrollType:(TXScrollLabelViewType)scrollType
                     scrollVelocity:(NSTimeInterval)scrollVelocity
                            options:(UIViewAnimationOptions)options
                              inset:(UIEdgeInsets)inset {
    if (self = [super init]) {
        self.scrollTitle = scrollTitle;
        self.scrollType = scrollType;
        self.scrollVelocity = scrollVelocity;
        self.options = options;
        _scrollInset = inset;
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
    
    return [self tx_setScrollTitle:scrollTitle
                        scrollType:scrollType
                    scrollVelocity:scrollVelocity
                           options:options inset:UIEdgeInsetsMake(0, 5, 0, 5)];
}

+ (instancetype)tx_setScrollTitle:(NSString *)scrollTitle
                       scrollType:(TXScrollLabelViewType)scrollType
                   scrollVelocity:(NSTimeInterval)scrollVelocity
                          options:(UIViewAnimationOptions)options
                            inset:(UIEdgeInsets)inset {
    
    return [[self alloc] initWithTitle:scrollTitle
                                  scrollType:scrollType
                              scrollVelocity:scrollVelocity
                                     options:options inset:inset];
}

#pragma mark - Getter & Setter Methods

- (void)setScrollInset:(UIEdgeInsets)scrollInset {
    _scrollInset = scrollInset;
    [self setupSubviewsLayout];
}

- (void)setScrollSpace:(CGFloat)scrollSpace {
    _scrollSpace = scrollSpace;
    [self setupSubviewsLayout];
}

- (CGFloat)scrollSpace {
    if (_scrollSpace) return _scrollSpace;
    return 0.f;
}

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
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setupSubviewsLayout];
}

- (void)setTx_scrollTitleColor:(UIColor *)tx_scrollTitleColor {
    _scrollTitleColor = tx_scrollTitleColor;
    [self setupTextColor:tx_scrollTitleColor];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.upLabel.textAlignment = textAlignment;
    self.downLabel.textAlignment = textAlignment;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.upLabel.font = font;
    self.downLabel.font = font;
    [self setupSubviewsLayout];
}

- (UIFont *)font {
    if (_font) return _font;
    return TXScrollLabelFont;
}

#pragma mark - Custom Methods

- (void)setupTextColor:(UIColor *)color {
    self.upLabel.textColor = color;
    self.downLabel.textColor = color;
}

- (void)setupTitle:(NSString *)title {
    self.upLabel.text = title;
    self.downLabel.text = title;
}

- (void)setupRepeatTypeLayout {
    CGFloat labelW = self.tx_width - _scrollInset.left - _scrollInset.right;
    CGFloat labelX = _scrollInset.left;
    self.upLabel.frame = CGRectMake(labelX, 0, labelW, self.tx_height);
    self.downLabel.frame = CGRectMake(labelX, CGRectGetMaxY(self.upLabel.frame), labelW, self.tx_height);
}

- (void)setupLRUDTypeLayoutWithMaxSize:(CGSize)size
                                 width:(CGFloat)width
                                height:(CGFloat)height
                      completedHandler:(void(^)(CGSize size))completedHandler {
    CGSize scrollLabelS = [_scrollTitle boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil].size;
    //回调获取布局数据
    completedHandler(scrollLabelS);
    [self setupTitle:_scrollTitle];
}

#pragma mark - SubviewsLayout Methods

- (void)setupSubviewsLayout {
    switch (_scrollType) {
        case TXScrollLabelViewTypeLeftRight: {
            CGFloat labelMaxH = self.tx_height;//最大高度
            CGFloat labelMaxW = 0;//无限宽
            CGFloat labelH = labelMaxH;//label实际高度
            __block CGFloat labelW = 0;//label宽度，有待计算
            
            [self setupLRUDTypeLayoutWithMaxSize:CGSizeMake(labelMaxW, labelMaxH) width:labelW height:labelH completedHandler:^(CGSize size) {
                labelW = MAX(size.width, self.tx_width);
                //开始布局
                self.upLabel.frame = CGRectMake(_scrollInset.left, 0, labelW, labelH);
                //由于 TXScrollLabelViewTypeLeftRight\UpDown 类型 X\Y 值均不一样，此处不再block中处理！
                self.downLabel.frame = CGRectMake(CGRectGetMaxX(self.upLabel.frame) + self.scrollSpace, 0, labelW, labelH);
            }];
        }
            break;
        case TXScrollLabelViewTypeUpDown: {
            CGFloat labelMaxH = 0;
            CGFloat labelMaxW = self.tx_width - _scrollInset.left - _scrollInset.right;
            CGFloat labelW = labelMaxW;
            __block CGFloat labelH = 0;
            
            [self setupLRUDTypeLayoutWithMaxSize:CGSizeMake(labelMaxW, labelMaxH) width:labelW height:labelH completedHandler:^(CGSize size) {
                labelH = MAX(size.height, self.tx_height);
                self.upLabel.frame = CGRectMake(_scrollInset.left, 0, labelW, labelH);
                self.downLabel.frame = CGRectMake(_scrollInset.left, CGRectGetMaxY(self.upLabel.frame) + self.scrollSpace, labelW, labelH);
            }];
        }
            break;
        case TXScrollLabelViewTypeFlipRepeat: {
            [self setupRepeatTypeLayout];
            [self setupTitle:_scrollTitle];
        }
            break;
        case TXScrollLabelViewTypeFlipNoRepeat:
            [self setupRepeatTypeLayout];
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
    switch (self.scrollType) {
        case TXScrollLabelViewTypeLeftRight:
        {
            if (self.contentOffset.x >= (_scrollInset.left + self.upLabel.tx_width + self.scrollSpace)) {
                [self endScrolling];
                self.contentOffset = CGPointMake(_scrollInset.left + 1, 0);//x增加偏移量，防止卡顿
                [self beginScrolling];
            }else {
                self.contentOffset = CGPointMake(self.contentOffset.x + 1, self.contentOffset.y);
            }
        }
            break;
            
        case TXScrollLabelViewTypeUpDown:
        {
            if (self.contentOffset.y >= (self.upLabel.frame.size.height + self.scrollSpace)) {
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
            
            NSTimeInterval velocity = self.scrollVelocity ? self.scrollVelocity : 2;
            
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
            
            NSTimeInterval velocity = self.scrollVelocity ? self.scrollVelocity : 2;
            
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
            TXScrollLabel *tempLabel = self.upLabel;
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
    
    NSString *text = _scrollTitle;
    UIFont *font = self.font;
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,self.upLabel.tx_width,100000));
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
