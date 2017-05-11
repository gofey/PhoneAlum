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
    _isEnough = NO;
    _bottomViewHeight = 44;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //设置NavBar
    [self setupNav];
    
    //添加底部视图
    [self addBottomView];
    self.imgCount = 0;
    [self addObserver:self forKeyPath:@"imgCount" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)setupNav{
    
}


- (void)setImgCount:(NSInteger)imgCount{
    _imgCount = imgCount;
    if (imgCount == 0) {
        //数目为0不可提交
        self.numberLabel.hidden = YES;
        self.submitBtn.enabled = NO;
        return;
    }
    self.numberLabel.hidden = NO;
    self.submitBtn.enabled = YES;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)imgCount];
}

//底部视图
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
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn = submitBtn;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submitClick)];
    [numberLabel addGestureRecognizer:tap];
    numberLabel.userInteractionEnabled = YES;
}

#pragma mark - kvo的回调方法
//keyPath:属性名称
//object:被观察的对象
//change:变化前后的值都存储在change字典中
//context:注册观察者的时候,context传递过来的值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([[change objectForKey:NSKeyValueChangeNewKey] integerValue] >= LimitCount) {
        _isEnough = YES;
    }else{
        _isEnough = NO;
    }
    [self.collectionView reloadData];
}

#pragma mark - Action
- (void)submitClick{
    
    //将索引变换成Image数组，方便上传
    NSMutableArray<UIImage *> *selectedImgs = [NSMutableArray array];
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    for (NSNumber *num in self.selectedImgIndexs) {
        NSInteger index = num.integerValue;
        dispatch_group_async(dispatchGroup, globalQ, ^(){
            UIImage *image = [UIImage imageWithCGImage:self.assetArray[index].asset.defaultRepresentation.fullResolutionImage];
            [selectedImgs addObject:image];
            
        });
    }
    
    //利用dispatch group是为了确认数组转换
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        //在这里上传
        [self.delegate photoAlumSelectedImageArray:selectedImgs];
//        NSLog(@"count:%lu",(unsigned long)selectedImgs.count);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}
#pragma mark - 重写get方法

- (NSMutableArray *)selectedImgIndexs{
    if (!_selectedImgIndexs) {
        _selectedImgIndexs = [NSMutableArray array];
    }
    return _selectedImgIndexs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{

    [self removeObserver:self forKeyPath:@"imgCount"];
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
