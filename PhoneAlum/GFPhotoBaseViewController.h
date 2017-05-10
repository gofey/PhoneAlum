//
//  GFPhotoBaseViewController.h
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/9.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFAsset.h"

@interface GFPhotoBaseViewController : UIViewController{
    NSString *_reuseIdentifier;
    NSMutableArray *_selectedImgIndexs;
    UICollectionView *_collectionView;
    NSMutableArray<GFAsset *> *_assetArray;
}

@property(nonatomic)BOOL bottomViewIsHidden;

@property(nonatomic)NSInteger imgCount;

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *selectedImgIndexs;

@property(nonatomic,strong)NSMutableArray<GFAsset *> *assetArray;

@end
