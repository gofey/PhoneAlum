//
//  GFPhotoBaseViewController.m
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/9.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import "GFPhotoBaseViewController.h"

@interface GFPhotoBaseViewController ()
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)UIButton *submitBtn;
@end

@implementation GFPhotoBaseViewController{
    CGFloat _bottomViewHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _bottomViewHeight = 44;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setupNav];
    [self addBottomView];
    self.imgCount = 0;
    
}

- (void)setupNav{
    
}

- (void)setImgCount:(NSInteger)imgCount{
    if (imgCount == 0) {
        self.numberLabel.hidden = YES;
        self.submitBtn.enabled = NO;
        return;
    }
    self.numberLabel.hidden = NO;
    self.submitBtn.enabled = YES;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)imgCount];
}

- (void)addBottomView{
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - _bottomViewHeight, [UIScreen mainScreen].bounds.size.width, _bottomViewHeight)];
    [self.view addSubview:bottom];
    bottom.backgroundColor = [UIColor blackColor];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45 - 33, (_bottomViewHeight - 30) / 2, 30, 30)];
    [bottom addSubview:numberLabel];
    numberLabel.backgroundColor = [UIColor greenColor];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = [UIFont systemFontOfSize:18];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.clipsToBounds = YES;
    numberLabel.layer.cornerRadius = 15;
    self.numberLabel = numberLabel;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottom addSubview:submitBtn];
    submitBtn.frame = CGRectMake(CGRectGetMaxX(numberLabel.frame) + 3, 0, 40, _bottomViewHeight);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn = submitBtn;
    
}

- (void)submitClick:(UIButton *)sender{
    //将索引变换成Image数组，方便上传
    NSMutableArray *selectedImgs = [NSMutableArray array];
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    for (NSNumber *num in self.selectedImgIndexs) {
        NSInteger index = num.integerValue;
        dispatch_group_async(dispatchGroup, globalQ, ^(){
            UIImage *image = [UIImage imageWithCGImage:self.assetArray[index].asset.defaultRepresentation.fullResolutionImage];
            [selectedImgs addObject:image];
            
        });
    }
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        //在这里上传
        
        NSLog(@"count:%lu",(unsigned long)selectedImgs.count);
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
