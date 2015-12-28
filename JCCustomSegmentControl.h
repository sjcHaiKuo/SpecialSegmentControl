//
//  JCCustomSegmentControl.h
//  SpecialSegmentControl
//
//  Created by 邵吉昌 on 15/12/28.
//  Copyright © 2015年 zhclw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonOnClickBlock)(NSInteger tag,NSString *title);

@interface JCCustomSegmentControl : UIView

@property (nonatomic, strong) NSArray *titles;    //标题数组
@property (nonatomic, strong) UIColor *titleCustomColor;   // 标题常规颜色
@property (nonatomic, strong) UIColor *titleHighLightColor;  // 标题敞亮颜色
@property (nonatomic, strong) UIColor *backgroundHighLightColor;   //高亮时的颜色、
@property (nonatomic, strong) UIFont *titlesFont;
@property (nonatomic, assign) CGFloat duration;

// 点击按钮的回调

- (void) setButtonOnClickBlock:(ButtonOnClickBlock)block;

@end
