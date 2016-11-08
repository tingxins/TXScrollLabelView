//
//  TXScrollLabelView.m
//
//  Created by tingxins on 2/23/16.
//  Copyright © 2016 tingxins. All rights reserved.
//
#define TXScrollLabelFont [UIFont systemFontOfSize:14]
#import "TXScrollLabelView.h"
#import "UIView+TXFrame.h"
#import <CoreText/CoreText.h>

@interface TXScrollLabelView ()

@property (weak, nonatomic) UILabel *scrollLabel0;

@property (weak, nonatomic) UILabel *scrollLabel1;

@property (weak, nonatomic) UITextView *scrollTextView;

@property (strong, nonatomic) NSTimer *scrollTimer;

@property (strong, nonatomic) NSArray *scrollArray;

@end

@implementation TXScrollLabelView

- (NSArray *)scrollArray {
    if (_scrollArray) return _scrollArray;
    return _scrollArray = [self getSeparatedLinesFromLabel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        UILabel *scrollLabel0 = [[UILabel alloc]init];
        scrollLabel0.numberOfLines = 0;
        self.scrollLabel0 = scrollLabel0;
        self.scrollLabel0.font = TXScrollLabelFont;
        self.scrollLabel0.textColor = [UIColor whiteColor];
        [self addSubview:scrollLabel0];
        
        UILabel *scrollLabel1 = [[UILabel alloc]init];
        scrollLabel1.numberOfLines = 0;
        self.scrollLabel1 = scrollLabel1;
        self.scrollLabel1.font = TXScrollLabelFont;
        self.scrollLabel1.textColor = [UIColor whiteColor];
        [self addSubview:scrollLabel1];
        
        scrollLabel0.lineBreakMode = NSLineBreakByWordWrapping;
        scrollLabel1.lineBreakMode = NSLineBreakByWordWrapping;
        scrollLabel0.textAlignment = NSTextAlignmentCenter;
        scrollLabel1.textAlignment = NSTextAlignmentCenter;
        self.scrollEnabled = NO;
    }
    return self;
}

- (void)setScrollTitle:(NSString *)scrollTitle {
    _scrollTitle = [scrollTitle copy];
    
    switch (self.scrollType) {
        case TXScrollLabelViewType_LR:
        {
            CGSize scrollLabelS = [self.scrollTitle boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: TXScrollLabelFont} context:nil].size;
            self.scrollLabel0.frame = CGRectMake(10, 0, scrollLabelS.width, 30);
            self.scrollLabel0.text = self.scrollTitle;
            
            self.scrollLabel1.frame = CGRectMake(CGRectGetMaxX(self.scrollLabel0.frame) + 20, 0, scrollLabelS.width, 30);
            self.scrollLabel1.text = self.scrollTitle;
            self.contentSize = CGSizeMake(scrollLabelS.width * 2 + 40, scrollLabelS.height);
            CGFloat maxWidth = 200;
            self.bounds = CGRectMake(0, 0, MIN(maxWidth, scrollLabelS.width), 30);
        }
            break;
            
        case TXScrollLabelViewType_UD:
        {
            
            CGSize scrollLabelS = [self.scrollTitle boundingRectWithSize:CGSizeMake(200, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: TXScrollLabelFont} context:nil].size;
            self.scrollLabel0.frame = CGRectMake(0, 0, scrollLabelS.width, scrollLabelS.height);
            self.scrollLabel0.text = self.scrollTitle;
            
            self.scrollLabel1.frame = CGRectMake(0, CGRectGetMaxY(self.scrollLabel0.frame), scrollLabelS.width, scrollLabelS.height);
            self.scrollLabel1.text = self.scrollTitle;
            self.contentSize = CGSizeMake(scrollLabelS.width, scrollLabelS.height * 2);
            self.bounds = CGRectMake(0, 0, scrollLabelS.width, 30);
        }
            break;
            
        case TXScrollLabelViewType_Flip:
        {
            
            CGSize scrollLabelS = [self.scrollTitle boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: TXScrollLabelFont} context:nil].size;
            self.scrollLabel0.frame = CGRectMake(0, 0, scrollLabelS.width, 30);
            self.scrollLabel0.text = self.scrollTitle;
            
            self.scrollLabel1.frame = CGRectMake(0, CGRectGetMaxY(self.scrollLabel0.frame), scrollLabelS.width, 30);;
            self.scrollLabel1.text = self.scrollTitle;
            self.contentSize = CGSizeMake(scrollLabelS.width, scrollLabelS.height * 2);
            self.bounds = CGRectMake(0, 0, scrollLabelS.width, 30);
        }
            break;
            
            
        case TXScrollLabelViewType_FlipNoCle:
        {
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
            paraStyle.lineSpacing = 10;
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:_scrollTitle];
            [attributedStr addAttributes:@{NSFontAttributeName:TXScrollLabelFont, NSParagraphStyleAttributeName:paraStyle} range:NSMakeRange(0, attributedStr.length)];
            
            CGSize scrollLabelS = [attributedStr boundingRectWithSize:CGSizeMake(self.tx_width, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            
            self.scrollLabel0.frame = CGRectMake(0, 0, scrollLabelS.width, self.tx_height);
            self.scrollLabel1.frame = CGRectMake(0, CGRectGetMaxY(self.scrollLabel0.frame), scrollLabelS.width, self.tx_height);
            
            CGFloat width = scrollLabelS.width;
            if (!self.tx_width) {
                self.tx_width = width;
            }
            self.contentSize = CGSizeMake(self.tx_width, scrollLabelS.height * 2);
            self.bounds = CGRectMake(0, 0, self.tx_width, self.tx_height);
        }
            break;
            
        default:
            break;
    }
}

- (void)beginScrolling {
    [self stopScrolling];
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateScrolling) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
}

- (void)stopScrolling {
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

- (void)pauseScrolling {
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

- (void)updateScrolling {
    switch (self.scrollType) {
        case TXScrollLabelViewType_LR:
        {
            if (self.contentSize.width * 0.5 == self.contentOffset.x || self.contentOffset.x > self.contentSize.width * 0.5) {
                [self stopScrolling];
                self.contentOffset = CGPointMake(2, 0);//x增加偏移量，防止卡顿
                [self beginScrolling];
                return;
            }
            self.contentOffset = CGPointMake(self.contentOffset.x + 1, self.contentOffset.y);
            
        }
            break;
            
        case TXScrollLabelViewType_UD:
        {
            if (self.contentOffset.y > self.scrollLabel0.frame.size.height) {
                [self stopScrolling];
                self.contentOffset = CGPointMake(0, 2);//y增加偏移量，防止卡顿
                [self beginScrolling];
                return;
            }
            self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + 1);
            
        }
            break;
            
        case TXScrollLabelViewType_Flip:
        {
            
            [self stopScrolling];
            self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateScrolling) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
            
            [self flipAnimationWithDelay:0];
        }
            break;
            
        case TXScrollLabelViewType_FlipNoCle:
        {
            
            [self stopScrolling];
            NSTimeInterval velocity = self.scrollVelocity ? self.scrollVelocity : 2;
            
            self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:velocity target:self selector:@selector(updateScrolling) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
            
            [self flipNoCleAnimationWithDelay:velocity];
        }
            break;
            
        default:
            break;
    }
}

- (void)flipAnimationWithDelay:(NSTimeInterval)delay {
    [UIView transitionWithView:self.scrollLabel0 duration:delay * 0.5 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        self.scrollLabel0.tx_bottom = 0;
        [UIView transitionWithView:self.scrollLabel0 duration:delay * 0.5 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            self.scrollLabel1.tx_y = 0;
        } completion:^(BOOL finished) {
            self.scrollLabel0.tx_y = self.tx_height;
            UILabel *tempLabel = self.scrollLabel0;
            self.scrollLabel0 = self.scrollLabel1;
            self.scrollLabel1 = tempLabel;
        }];
    } completion:nil];
}

- (void)flipNoCleAnimationWithDelay:(NSTimeInterval)delay {
    static int count = 0;
    
    self.scrollLabel0.text = self.scrollArray[count];
    
    count ++;
    
    if (count == self.scrollArray.count) count = 0;
    
    self.scrollLabel1.text = self.scrollArray[count];
    
    [self flipAnimationWithDelay:delay];
}

#pragma mark - 文字分行

-(NSArray *)getSeparatedLinesFromLabel {
    
    NSString *text = _scrollTitle;
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

@end
