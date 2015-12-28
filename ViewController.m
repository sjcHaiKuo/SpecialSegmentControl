//
//  ViewController.m
//  SpecialSegmentControl
//
//  Created by 邵吉昌 on 15/12/28.
//  Copyright © 2015年 zhclw. All rights reserved.
//

#import "ViewController.h"
#import "JCCustomSegmentControl.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *myView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JCCustomSegmentControl *view = [[JCCustomSegmentControl alloc] initWithFrame:CGRectMake(30, 100, [UIScreen mainScreen].bounds.size.width - 60, 50)];
    view.titles = @[@"Hello",@"Apple",@"Swift",@"Objc"];
    view.duration = 0.7f;
    [view setButtonOnClickBlock:^(NSInteger tag, NSString *title) {
        NSLog(@"index = %d, title = %@",tag,title);
    }];
    [self.view addSubview:view];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
