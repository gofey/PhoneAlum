//
//  GFLargePhotoCollectionCell.m
//  PhoneAlum
//
//  Created by 厉国辉 on 2017/5/9.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import "GFLargePhotoCollectionCell.h"

@implementation GFLargePhotoCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubs:frame];
    }
    return self;
}

- (void)initSubs:(CGRect)frame{
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, frame.size.height)];
    [self.contentView addSubview:img];
    img.clipsToBounds = YES;
    img.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView = img;
    
}
@end
