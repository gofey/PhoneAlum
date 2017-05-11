//
//  GFAsset.h
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/9.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface GFAsset : NSObject
@property(nonatomic)BOOL isSelected;
@property(nonatomic,strong)ALAsset *asset;

- (GFAsset *)initWithAsset:(ALAsset *)asset;

+ (GFAsset *)assetWithAsset:(ALAsset *)asset;


@end
