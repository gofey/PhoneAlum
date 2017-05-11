//
//  GFLargePhotoController.h
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/8.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import "GFPhotoBaseViewController.h"
#import "GFAsset.h"

typedef void(^ControllerBlock)(NSMutableArray *assetArray,NSMutableArray *selectedArray);

@interface GFLargePhotoController : GFPhotoBaseViewController

//@property(nonatomic,strong)NSMutableArray <GFAsset *> *assetArray;
//
//@property(nonatomic,strong)NSMutableArray *selectedImgIndexs;

@property(nonatomic)NSInteger currentIndex;

@property(nonatomic,copy)ControllerBlock passArrayBlock;

- (void)leftBtnClick;

@end
