//
//  ViewController.m
//  DDPlayerBar
//
//  Created by lovelydd on 15/11/27.
//  Copyright © 2015年 xiaomutou. All rights reserved.
//

#import "ViewController.h"

#import "DDPlayerBar.h"
#define RGB_COLOR(r,g,b)            [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = RGB_COLOR(227, 228, 231);
    
    DDPlayerBar *playerBar = [[DDPlayerBar alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.bounds) - 40, 67)];
    [self.view addSubview:playerBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
