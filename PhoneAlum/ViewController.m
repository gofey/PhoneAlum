//
//  ViewController.m
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/5.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import "ViewController.h"
#import "GFPhotoAlumController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blueColor];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick{
    GFPhotoAlumController *photoAlum = [[GFPhotoAlumController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoAlum];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
