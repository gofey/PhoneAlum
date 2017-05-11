//
//  ViewController.m
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/5.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import "ViewController.h"
#import "GFPhotoAlumController.h"
@interface ViewController ()<GFPhotoAlumDelegate>
@property(nonatomic,strong)UIImageView *bgImg;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:bgImg];
    self.bgImg = bgImg;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"打开相册" forState:UIControlStateNormal];
    btn.frame = CGRectMake(64, 15, 100, 40);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnClick{
    GFPhotoAlumController *photoAlum = [[GFPhotoAlumController alloc] init];
    photoAlum.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoAlum];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - delegate
- (void)photoAlumSelectedImageArray:(NSArray<UIImage *> *)selectedImgs{
    NSLog(@"%lu",(unsigned long)selectedImgs.count);
    
    self.bgImg.image = selectedImgs[0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
