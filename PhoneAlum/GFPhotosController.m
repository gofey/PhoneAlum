//
//  GFPhotosController.m
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/8.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import "GFPhotosController.h"
#import "GFPhotoCollectionCell.h"
#import "GFLargePhotoController.h"
#import "GFAsset.h"

@interface GFPhotosController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
//{
////    NSString * _reuseIdentifier;
////    NSMutableArray *_selectedImgIndexs;
////    UICollectionView *_collectionView;
////    NSMutableArray<GFAsset *> *_assetArray;
//}
//@property(nonatomic,strong)NSMutableArray *selectedIndex;

@end

@implementation GFPhotosController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _reuseIdentifier = @"normalcellID";
    self.view.backgroundColor = [UIColor blackColor];
    
//    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
//    //当是侧滑手势的时候设置scrollview需要此手势失效才生效即可
//    for (UIGestureRecognizer *gesture in gestureArray) {
//        if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//            NSLog(@"ppp");
//            [self.collection.panGestureRecognizer requireGestureRecognizerToFail:gesture];
//        }
//    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)setupNav{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text = [_group valueForProperty:ALAssetsGroupPropertyName];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 44);
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

//- (void)submitClick:(UIButton *)sender{
//    
//    //上传部分代码请写在下边
//    
//    
//}

#pragma mark - Action

- (void)rightBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 重写Set方法
- (void)setGroup:(ALAssetsGroup *)group{
    _group = group;
    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            
            [self.assetArray addObject:[GFAsset assetWithAsset:result]];
        }else{
            if (self.assetArray.count == 0) {
                NSLog(@" no photo");
            }
            [self.collectionView reloadData];
        }
    }];
}

- (NSMutableArray *)selectedImgIndexs{
    if (!_selectedImgIndexs) {
        _selectedImgIndexs = [NSMutableArray array];
    }
    return _selectedImgIndexs;
}

- (ALAssetsGroup *)group{
    if (!_group) {
        NSLog(@"no  group!!!!");
    }
    return _group;
}



#pragma mark - 重写Get方法
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 25) / 4;
        flowLayout.itemSize = CGSizeMake(width, width);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 44) collectionViewLayout:flowLayout];
        [self.view addSubview:collectionView];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[GFPhotoCollectionCell class] forCellWithReuseIdentifier:_reuseIdentifier];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (NSMutableArray *)assetArray{
    if (!_assetArray) {
        _assetArray = [NSMutableArray array];
    }
    return _assetArray;
}

#pragma mark - collection datasource and delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GFPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_reuseIdentifier forIndexPath:indexPath];
    
    cell.asset = self.assetArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    cell.selectClick = ^(GFAsset *asset){
        [weakSelf.assetArray replaceObjectAtIndex:indexPath.row withObject:asset];
        if (asset.isSelected) {
            [weakSelf.selectedImgIndexs addObject:[NSNumber numberWithInteger:indexPath.row]];
        }else{
            [weakSelf.selectedImgIndexs removeObject:[NSNumber numberWithInteger:indexPath.row]];
        }
        self.imgCount = self.selectedImgIndexs.count;
        
    };
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assetArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GFLargePhotoController *large = [[GFLargePhotoController alloc] init];
    large.currentIndex = indexPath.row;
    large.assetArray = self.assetArray;
    large.selectedImgIndexs = self.selectedImgIndexs;
    __weak typeof(self) weakSelf = self;
    large.passArrayBlock = ^(NSMutableArray *assetArray,NSMutableArray *selectedArray){
        weakSelf.assetArray = assetArray;
        weakSelf.selectedImgIndexs = selectedArray;
        weakSelf.imgCount = selectedArray.count;
        [weakSelf.collectionView reloadData];
    };
    
    [self.navigationController pushViewController:large animated:YES];
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
