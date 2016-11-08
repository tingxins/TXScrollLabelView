# TXScrollLabelView

[![Pod License](http://img.shields.io/cocoapods/l/SDWebImage.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)

`TXScrollLabelView` is an iOS class that displays a adverts or boardcast e.g. with an view.

![TXScrollLableView Gif](scrollLabelView.gif)

### Usage 

Example (Run **demo** For more details):

        NSString *scrollTitle = @"xxxxx";
        TXScrollLabelView *scrollLabelView = [TXScrollLabelView tx_setScrollTitle:scrollTitle scrollType:options scrollVelocity:2.0 options:UIViewAnimationOptionTransitionFlipFromTop];
        //布局
        scrollLabelView.tx_scrollContentSize = CGRectMake(50, 100 * (options + 0.7), 250, 30);
        scrollLabelView.tx_centerX = [UIScreen mainScreen].bounds.size.width * 0.5;
        //偏好设置
        scrollLabelView.backgroundColor = [UIColor blackColor];
        scrollLabelView.layer.cornerRadius = 5;
        [self.view addSubview:scrollLabelView];
        
        [scrollLabelView beginScrolling];
        self.scrollLabelView = scrollLabelView;


