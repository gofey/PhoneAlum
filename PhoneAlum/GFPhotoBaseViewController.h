//
//  GFPhotoBaseViewController.h
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/9.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFAsset.h"
#define LimitCount 9
@interface GFPhotoBaseViewController : UIViewController{
    NSString *_reuseIdentifier;
    NSMutableArray *_selectedImgIndexs;
    UICollectionView *_collectionView;
    NSMutableArray<GFAsset *> *_assetArray;
    BOOL _isEnough;
}

@property(nonatomic)BOOL bottomViewIsHidden;

@property(nonatomic)NSInteger imgCount;//选择的照片数目

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *selectedImgIndexs;//选择的照片的数组下标

@property(nonatomic,strong)NSMutableArray<GFAsset *> *assetArray;//所有照片的数组

@end
