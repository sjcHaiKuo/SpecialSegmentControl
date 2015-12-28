//
//  JCCustomSegmentControl.m
//  SpecialSegmentControl
//
//  Created by 邵吉昌 on 15/12/28.
//  Copyright © 2015年 zhclw. All rights reserved.
//

#define DEFAULT_TITLES_FONT 20.0F
#define DEFAULT_DURATION 3.0f

#import "JCCustomSegmentControl.h"

@interface JCCustomSegmentControl ()

@property (nonatomic, assign) CGFloat viewWidth;   // 组件的宽度
@property (nonatomic, assign) CGFloat viewHeight;  // 组件的高度
@property (nonatomic, assign) CGFloat labelWidth;  // label的宽度

// 上层view，highLightView大小为一个label的大小，上面添加了highColorView红色的view，然后添加highToptView，所有颜色为白色的label的view
@property (nonatomic, strong) UIView *highLightView;
@property (nonatomic, strong) UIView *highToptView;
@property (nonatomic, strong) UIView *highColorView;

@property (nonatomic, strong) NSMutableArray *labelMutaleArray;
@property (nonatomic, strong) ButtonOnClickBlock buttonBlock;

@end

@implementation JCCustomSegmentControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewWidth = frame.size.width;
        _viewHeight = frame.size.height;
        _duration = DEFAULT_DURATION;
    }
    return self;
}

- (void)setButtonOnClickBlock:(ButtonOnClickBlock)block {
    if (block) {
        _buttonBlock = block;
    }
}

- (void)layoutSubviews {
    [self customData];
    [self createBottomLabels];
    [self createTopLabels];
    [self createTopButtons];
}

// 设置默认值
- (void)customData {
    if (_titles == nil) {
        _titles = @[@"test0",@"test1",@"test2"];
    }
    
    if (_titleCustomColor == nil) {
        _titleCustomColor = [UIColor blackColor];
    }
    
    if (_titleHighLightColor == nil) {
        _titleHighLightColor = [UIColor whiteColor];
    }
    
    if (_backgroundHighLightColor == nil) {
        _backgroundHighLightColor = [UIColor redColor];
    }
    
    if (_titlesFont == nil) {
        _titlesFont = [UIFont systemFontOfSize:DEFAULT_TITLES_FONT];
    }
    
    if (_labelMutaleArray == nil) {
        _labelMutaleArray = [[NSMutableArray alloc] initWithCapacity:_titles.count];
    }
    
    _labelWidth = _viewWidth / _titles.count;
    
}

// 创建最底层的label
- (void)createBottomLabels {
    
    for (int i = 0; i < _titles.count; i++) {
        UILabel *tempLabel = [self createLabelWithTitlesIndex:i textColor:_titleCustomColor];
        [self addSubview:tempLabel];
        [_labelMutaleArray addObject:tempLabel];
    }
    
}

// 创建上一层高亮使用的label
- (void)createTopLabels {
    CGRect highLightViewFrame = CGRectMake(0, 0, _labelWidth, _viewHeight);
    _highLightView = [[UIView alloc] initWithFrame:highLightViewFrame];
    _highLightView.clipsToBounds = YES;
    
    _highColorView = [[UIView alloc] initWithFrame:highLightViewFrame];
    _highColorView.backgroundColor = _backgroundHighLightColor;
    _highColorView.layer.cornerRadius = 20;
    [_highLightView addSubview:_highColorView];
    
    _highToptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    for (int i = 0; i < _titles.count; i++) {
        UILabel *label = [self createLabelWithTitlesIndex:i textColor:_titleHighLightColor];
        [_highToptView addSubview:label];
    }
    [_highLightView addSubview:_highToptView];
    [self addSubview:_highLightView];
    
}

// 返回创建好的label
- (UILabel *) createLabelWithTitlesIndex:(NSInteger)index textColor:(UIColor *)textColor {
    CGRect currentLabelFrame = [self countCurrentRectWithIndex:index];
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:currentLabelFrame];
    tempLabel.textColor = textColor;
    tempLabel.text = _titles[index];
    tempLabel.font = _titlesFont;
    tempLabel.minimumScaleFactor = 0.1f;
    tempLabel.textAlignment = NSTextAlignmentCenter;
    return tempLabel;
}

// 返回当前点击按钮的frame
- (CGRect) countCurrentRectWithIndex:(NSInteger)index {
    return CGRectMake(_labelWidth * index, 0, _labelWidth, _viewHeight);
}

// 创建按钮
- (void) createTopButtons {
    for (int i = 0; i < _titles.count; i++) {
        CGRect tempFrame = [self countCurrentRectWithIndex:i];
        UIButton *tempButton = [[UIButton alloc] initWithFrame:tempFrame];
        tempButton.tag  = i;
        [tempButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tempButton];
    }
}

// 点击按钮事件
- (void)tapButton:(UIButton *)sender {
    if (_buttonBlock && sender.tag < _titles.count) {
        _buttonBlock(sender.tag,_titles[sender.tag]);
    }
    
    CGRect frame = [self countCurrentRectWithIndex:sender.tag];
    CGRect changeFrame = [self countCurrentRectWithIndex:-sender.tag];
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:_duration animations:^{
        _highLightView.frame = frame;
        _highToptView.frame = changeFrame;
    } completion:^(BOOL finished) {
        [weakSelf shakeAnimationForView:_highColorView];
    }];
    
}

// 抖动效果
- (void)shakeAnimationForView:(UIView *)view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x +1, position.y);
    CGPoint y = CGPointMake(position.x -1, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
    
}

@end
