//
//  TopLeaderView.m
//  CAVER
//
//  Created by 酷蜂ios on 16/5/18.
//  Copyright © 2016年 酷蜂ios. All rights reserved.
//


#import "TopLeaderView.h"
#import "TopLeaderBtn.h"
#import "UIView+Extension.h"

#define LINE_NOMAL_COLOR KColor(235, 130, 125, 1)
#define TITLE_FONT [UIFont systemFontOfSize:15]

@interface TopLeaderView ()

@property (nonatomic,strong)NSMutableArray <TopLeaderBtn*>*titles;


//@property (nonatomic,weak)UIView *lineView;

@property (nonatomic,weak)UIView *bottomLineView;

/**当前选中的按钮*/
@property (nonatomic,weak)UIButton *selectedBtn;
@property (nonatomic,strong)UILabel    *redLab;
@end

@implementation TopLeaderView
@synthesize redLabText;

-(NSMutableArray<TopLeaderBtn *> *)titles
{
    if(!_titles){
        _titles = [NSMutableArray array];
    }
    return _titles;
}

-(instancetype)initWithFrame:(CGRect)frame topTitles:(NSArray<NSString *> *)titles
{
    self = [super initWithFrame:frame];
    if(self){
        _hideBottomLine = NO;
        self.redLab=[[UILabel alloc]init];
        self.redLab.backgroundColor=[UIColor redColor];
        VIEW_CORNER(self.redLab, 7);
        self.redLab.textColor=[UIColor whiteColor];
        self.redLab.font=FONT_11;
        self.redLab.textAlignment=NSTextAlignmentCenter;
        self.redLab.alpha=0;
        self.backgroundColor = [UIColor whiteColor];
        
       
        self.backgroundColor = [UIColor whiteColor];

        
        
        
        UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        self.bottomLineView = grayLine;
        grayLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:grayLine];
        [self addSubview:self.redLab];
        
        UIView *lineView = [[UIView alloc]init];
        self.lineView = lineView;
        lineView.backgroundColor = HEXCOLOR(0xf74940);
        [self addSubview:lineView];
        
        [self setUpWithTitle:titles];
        
    }
    return self;
}

- (void)setUpWithTitle:(NSArray*)array
{
    CGFloat titleW = self.width/array.count-((array.count -1)*1);
    CGFloat titleH = self.height-1;
    CGFloat lineWidth = self.lineWidth;
    if(lineWidth == 0){
        lineWidth = 50;
    }
    
    for (int i = 0; i<array.count; i++) {
        NSString *title = array[i];
        TopLeaderBtn *button = [[TopLeaderBtn alloc]init];
        button.tag = i;
        [button addTarget:self action:@selector(clickLeader:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:KColor(51, 51, 51, 1) forState:UIControlStateSelected];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:TITLE_FONT];
        if(i == 0){
            button.selected = YES;
            self.selectedBtn = button;
        }else{
            button.selected = NO;
        }
        [self addSubview:button];
        CGFloat x = i*(titleW+1);
        button.frame = CGRectMake(x, 0, titleW, titleH);
        if(i == 0){
            self.lineView.frame = CGRectMake((button.CenterX-lineWidth*0.5), self.height-2.5, lineWidth, 2);
        }
        if (i==1) {
            self.redLab.frame=CGRectMake(button.frame.origin.x+button.frame.size.width/2+20, 10, 14, 14);
        }
        [self.titles addObject:button];
    }
    
}

-(void)setNomalIndex:(NSInteger)nomalIndex
{
    _nomalIndex = nomalIndex;
    if(nomalIndex == self.selectedBtn.tag)return;
    TopLeaderBtn *button = self.titles[nomalIndex];
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    CGPoint titleCenter = button.center;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.center = CGPointMake(titleCenter.x, self.lineView.center.y);
    }];
}

- (void)clickLeader:(TopLeaderBtn*)sender
{
    if(self.selectedBtn == sender)return;
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    if([self.delegate respondsToSelector:@selector(topLeaderView:DidClickWithIndex:)]){
        [self.delegate topLeaderView:self DidClickWithIndex:sender.tag];
    }
    if(self.hideBottomRedLine)return;
    CGPoint titleCenter = sender.center;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.center = CGPointMake(titleCenter.x, self.lineView.center.y);
    }];
}


-(void)setRedLabText:(int)_redLabText{
    if (redLabText!=_redLabText) {
        redLabText=_redLabText;
    }
    
    if (redLabText==0) {
        self.redLab.alpha=0;
        self.redLab.text=@"0";
    }else{
        self.redLab.alpha=1;
        self.redLab.text=[NSString stringWithFormat:@"%d",redLabText];
    }
    
}

#pragma mark - publick
- (void)changSelectedStaus:(NSInteger)index
{
    TopLeaderBtn *selectedBtn = self.titles[index];
    [self clickLeader:selectedBtn];
    
}
- (void)resumeFirstIndex
{
    TopLeaderBtn *firstBtn = self.titles.firstObject;
    self.selectedBtn.selected = NO;
    firstBtn.selected = YES;
    self.selectedBtn = firstBtn;
    CGPoint titleCenter = firstBtn.center;
    self.lineView.center = CGPointMake(titleCenter.x, self.lineView.center.y);
    
}


-(void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    for (TopLeaderBtn *btn in self.titles) {
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    }
}

- (void)setNomalColor:(UIColor *)nomalColor
{
    _nomalColor = normal;
    for (TopLeaderBtn *btn in self.titles) {
        [btn setTitleColor:nomalColor forState:UIControlStateNormal];
    }
}

-(void)setHideBottomLine:(BOOL)hideBottomLine
{
    _hideBottomLine = hideBottomLine;
    self.bottomLineView.hidden = hideBottomLine;
    
}

-(void)setHideBottomRedLine:(BOOL)hideBottomRedLine
{
    _hideBottomRedLine = hideBottomRedLine;
    [self.lineView setHidden:hideBottomRedLine];
    
}

-(void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    CGRect lineFrame = self.lineView.frame;
    
    CGFloat desMargin = lineWidth-lineFrame.size.width;
    if(desMargin >0){
        lineFrame.origin.x -= desMargin*0.5;
    }else{
        lineFrame.origin.x += desMargin*0.5;
    }
    lineFrame.size.width = lineWidth;
    self.lineView.frame = lineFrame;
}


@end
