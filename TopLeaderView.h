//
//  TopLeaderView.h
//  CAVER
//
//  Created by 酷蜂ios on 16/5/18.
//  Copyright © 2016年 酷蜂ios. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopLeaderView;

@protocol topLeaderViewDelegate <NSObject>

@optional
- (void)topLeaderView:(TopLeaderView*)leaderView DidClickWithIndex:(NSInteger)index;

@end


@interface TopLeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame topTitles:(NSArray<NSString*>*)titles;

@property (nonatomic,weak)UIView *lineView;

/**是否 顯示中間的橫線*/
@property (nonatomic,assign)BOOL showMidLine;

/**是否隐藏底部的线条*/
@property (nonatomic,assign)BOOL hideBottomLine;

@property (nonatomic,assign)BOOL hideBottomRedLine;

/**選擇的標題文字顏色 默認是黑色*/
@property (nonatomic,strong)UIColor *selectedColor;

@property (nonatomic,strong)UIColor *nomalColor;

@property (nonatomic,weak)id<topLeaderViewDelegate>delegate;

@property (nonatomic,assign)CGFloat lineWidth;

/**默认选中的下标。默认为0*/
@property (nonatomic,assign)NSInteger nomalIndex;

/**改变 选中的下标*/
- (void)changSelectedStaus:(NSInteger)index;

/**恢复到 第一个 不会触发代理方法 */
- (void)resumeFirstIndex;

@property (nonatomic,assign)int        redLabText;

@end
