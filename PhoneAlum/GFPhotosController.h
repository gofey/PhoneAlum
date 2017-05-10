//
//  GFPhotosController.h
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/8.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import "GFPhotoBaseViewController.h"
//#import <AssetsLibrary/AssetsLibrary.h>

@interface GFPhotosController : GFPhotoBaseViewController{
    ALAssetsGroup *_group;
}

@property (nonatomic,strong)ALAssetsGroup *group;

@end
