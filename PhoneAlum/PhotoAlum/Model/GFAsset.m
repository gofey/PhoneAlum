//
//  GFAsset.m
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/9.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import "GFAsset.h"

@implementation GFAsset

- (GFAsset *)initWithAsset:(ALAsset *)asset{
    GFAsset *gfA = [[GFAsset alloc] init];
    gfA.asset = asset;
    gfA.isSelected = NO;
    return gfA;
}

+ (GFAsset *)assetWithAsset:(ALAsset *)asset{
    return [[self alloc] initWithAsset:asset];
}

@end
