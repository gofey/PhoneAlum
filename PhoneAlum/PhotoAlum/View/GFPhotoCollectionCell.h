//
//  GFPhotoCollectionCell.h
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/8.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFAsset.h"

typedef void(^BtnClick)(GFAsset *asset);

@interface GFPhotoCollectionCell : UICollectionViewCell

@property(nonatomic,strong)GFAsset *asset;

@property(nonatomic,copy)BtnClick selectClick;

@end
