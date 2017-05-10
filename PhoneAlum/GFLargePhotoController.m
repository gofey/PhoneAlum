//
//  GFLargePhotoController.m
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/8.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import "GFLargePhotoController.h"
#import "GFLargePhotoCollectionCell.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


@interface GFLargePhotoController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIAlertController *alertVC;

@end

@implementation GFLargePhotoController{
    
    CGFloat _offSpaceX;
    CGFloat _itemHeight;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _offSpaceX = 30;
    _itemHeight = kHeight - 160;
    _reuseIdentifier = @"normalCell";
    self.view.backgroundColor = [UIColor blackColor];
    
    self.collectionView.contentOffset = CGPointMake(_currentIndex * (kWidth + _offSpaceX), 0);
    [self.collectionView reloadData];
    self.imgCount = self.selectedImgIndexs.count;
    
}

- (void)setupNav{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 10, 44);
    [leftBtn setTitle:@"<" forState:UIControlStateNormal];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 44);
    [rightBtn setTitle:@"选中" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

#pragma mark - 重写get方法
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        flowLayout.itemSize = CGSizeMake(kWidth + _offSpaceX, _itemHeight);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, kWidth +_offSpaceX, _itemHeight) collectionViewLayout:flowLayout];
        [self.view addSubview:collectionView];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor blackColor];
        [collectionView registerClass:[GFLargePhotoCollectionCell class] forCellWithReuseIdentifier:_reuseIdentifier];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}
- (UIAlertController *)alertVC{
    if (!_alertVC) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你做多只能选%d张照片",LimitCount] message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        _alertVC = alert;
    }
    return _alertVC;
}
#pragma mark - collection datasource and delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GFLargePhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_reuseIdentifier forIndexPath:indexPath];

    GFAsset *asset = self.assetArray[indexPath.row];
    
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(q, ^{
        UIImage *image = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullResolutionImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = image;
        });
    });
    
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assetArray.count;
}

#pragma mark - scrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.currentIndex = scrollView.contentOffset.x / (kWidth + _offSpaceX);
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
//    [self.collectionView reloadData];
}

#pragma mark - Action
- (void)leftBtnClick{
    if (self.passArrayBlock) {
        self.passArrayBlock(self.assetArray,self.selectedImgIndexs);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick:(UIButton *)sender{
    if (_isEnough && !sender.selected) {
        [self presentViewController:self.alertVC animated:YES completion:nil];
        return;
    }
    sender.selected = !sender.selected;
    GFAsset *asset = self.assetArray[_currentIndex];
    asset.isSelected = sender.selected;
    [self.assetArray replaceObjectAtIndex:_currentIndex withObject:asset];
    if (asset.isSelected) {
        [self.selectedImgIndexs addObject:[NSNumber numberWithInteger:_currentIndex]];
    }else{
        [self.selectedImgIndexs removeObject:[NSNumber numberWithInteger:_currentIndex]];
    }
    self.imgCount = self.selectedImgIndexs.count;

    
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    GFAsset *asset = self.assetArray[currentIndex];
    self.rightBtn.selected = asset.isSelected;
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
