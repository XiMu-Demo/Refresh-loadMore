//
//  DownScrollV.h
//  LianAi
//
//  Created by calvin on 14/11/7.
//  Copyright (c) 2014年 Yung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGLoadMoreView : UICollectionReusableView

@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UILabel *tipsLabel;


- (void)startAnimation;
- (void)stopAnimation;
- (BOOL)isAnimating;
- (void)noMoreData;
- (void)restartLoadData;
@end
