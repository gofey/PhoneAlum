//
//  GFPhotoAlumController.m
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/5.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import "GFPhotoAlumController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "GFPhotosController.h"

@interface GFPhotoAlumController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *assetGroupArray;
@property(nonatomic,strong)ALAssetsLibrary *assetLib;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation GFPhotoAlumController{
    NSString * _reuseIdentifier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setupNav];
    self.view.backgroundColor = [UIColor blackColor];
    _reuseIdentifier = @"normalcellID";
    //assetGroup Array
    [self.assetLib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if (group.numberOfAssets > 0) {
                [self.assetGroupArray addObject:group];
            }
        }else{
            if (self.assetGroupArray.count > 0) {
                [self.tableView reloadData];
                
            }else{
                //no photo
            }
            
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"enumerateGroupsError:%@",error);
    }];
}

- (void)setupNav{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text = @"照片";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 44);
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

#pragma mark - tableView dataSource & delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_reuseIdentifier];
    ALAssetsGroup *group = self.assetGroupArray[indexPath.row];
    cell.imageView.clipsToBounds = YES;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.image = [UIImage imageWithCGImage:group.posterImage];
    cell.textLabel.text = [NSString stringWithFormat:@"%@    %@", [group valueForProperty:ALAssetsGroupPropertyName],[NSString stringWithFormat:@"(%ld)", (long)group.numberOfAssets]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assetGroupArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GFPhotosController *photos = [[GFPhotosController alloc] init];
    ALAssetsGroup *group = self.assetGroupArray[indexPath.row];
    photos.group = group;
    photos.delegate = self.delegate;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:photos animated:YES];
}

#pragma mark - 重写Get方法
- (ALAssetsLibrary *)assetLib{
    if (!_assetLib) {
        _assetLib = [[ALAssetsLibrary alloc] init];
    }
    return _assetLib;
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        [self.view addSubview:table];
        table.backgroundColor = [UIColor whiteColor];
        table.delegate = self;
        table.dataSource = self;
        table.showsHorizontalScrollIndicator = NO;
        table.showsVerticalScrollIndicator = NO;
        [table registerClass:[UITableViewCell class] forCellReuseIdentifier:_reuseIdentifier];
        table.rowHeight = 75;
        table.tableFooterView = [[UIView alloc] init];
        
        _tableView = table;
    }
    return _tableView;
}

- (NSMutableArray *)assetGroupArray{
    if (!_assetGroupArray) {
        _assetGroupArray = [NSMutableArray array];
    }
    return _assetGroupArray;
}

#pragma mark - action
- (void)btnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
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
