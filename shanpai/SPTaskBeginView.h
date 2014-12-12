//
//  SPTaskBeginView.h
//  shanpai
//
//  Created by liang chunyan on 14-12-11.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@interface SPTaskBeginView : UIView
@property (weak, nonatomic) IBOutlet SwipeView *imageSwipeView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;

@property (nonatomic, strong) NSArray *dataList;

/*!
 *  加载网页
 *
 *  @param url url地址
 */
- (void)loadUrl:(NSString *)url;
@end
