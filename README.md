# PhoneAlum
自定制相册，参照微信

主要的功能当然是为了多张选择照片啦，

可以在代理方法中拿到你已经选择的照片

可以设置你一次选定的最多张数

但是单张照片显示的时候并不能放大缩小，功能以后完善

第一版效果如下

![images](http://ooy23086i.bkt.clouddn.com/photoAlum1.png)

![images](http://ooy23086i.bkt.clouddn.com/photoAlum2.jpeg)

![images](http://ooy23086i.bkt.clouddn.com/photoAlum3.jpeg)

跳转方法

    GFPhotoAlumController *photoAlum = [[GFPhotoAlumController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoAlum];
    
    [self presentViewController:nav animated:YES completion:nil];
    
诸如按钮文字之类的小细节当然都可以自己更改啦

哦哦！！！大家最关注的功能当然是在哪里获取已经选择的照片
如果你想拿到已经选择的照片，最直接的方法当然是代理，
引入<GFPhotoAlumDelegate>
设置photoAlum.delegate = self;
代理方法
  
    #pragma mark - delegate
    - (void)photoAlumSelectedImageArray:(NSArray<UIImage *> *)selectedImgs{
        NSLog(@"%lu",(unsigned long)selectedImgs.count);
     
        self.bgImg.image = selectedImgs[0];
    }

在GFPhotoBaseViewController.m文件下的- (void)submitClick方法

    - (void)submitClick{
    
    //将索引变换成Image数组，方便上传
    NSMutableArray<UIImage *> *selectedImgs = [NSMutableArray array];
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    for (NSNumber *num in self.selectedImgIndexs) {
        NSInteger index = num.integerValue;
        dispatch_group_async(dispatchGroup, globalQ, ^(){
            UIImage *image = [UIImage imageWithCGImage:self.assetArray[index].asset.defaultRepresentation.fullResolutionImage];
            [selectedImgs addObject:image];
            
        });
    }
    
    //利用dispatch group是为了确认数组转换
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        //代理传值
        [self.delegate photoAlumSelectedImageArray:selectedImgs];
        //在这里上传

        
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    }

