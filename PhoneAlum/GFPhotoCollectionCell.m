//
//  GFPhotoCollectionCell.m
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/8.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import "GFPhotoCollectionCell.h"

@interface GFPhotoCollectionCell()

@property(nonatomic,strong)UIImageView *photoImgView;
@property(nonatomic,strong)UIButton *selectPhotoBtn;

@end

@implementation GFPhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self.contentView addSubview:imgView];
        self.photoImgView = imgView;
        
        UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedBtn.frame = CGRectMake(frame.size.width - 25, 3, 22, 22);
        [selectedBtn setImage:[UIImage imageNamed:@"CheckmarkNormal"] forState:UIControlStateNormal];
        
        [selectedBtn setImage:[UIImage imageNamed:@"CheckmarkSelected"] forState:UIControlStateSelected];
        [selectedBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectedBtn];
        self.selectPhotoBtn = selectedBtn;
        
    }
    return self;
}

- (void)selectClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    _asset.isSelected = sender.selected;
    if (self.selectClick) {
        self.selectClick(self.asset);
    }
}

- (void)setAsset:(GFAsset *)asset{
    _asset = asset;
    self.photoImgView.image = [UIImage imageWithCGImage:asset.asset.aspectRatioThumbnail];
    self.selectPhotoBtn.selected = asset.isSelected;
}

@end
