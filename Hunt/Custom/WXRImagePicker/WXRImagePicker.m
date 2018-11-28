//
//  WXRImagePicker.m
//  wxer_manager
//
//  Created by JackyLiang on 2017/8/16.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "WXRImagePicker.h"
#import "VPImageCropperViewController.h"
#import "AppInfo.h"
#import "CommonUtils.h"
#import "UIImage+JLAdd.h"

@interface WXRImagePicker ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>
@property (nonatomic, assign) BOOL cropable;
@property (nonatomic, assign) CGRect cropFrame;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, assign) PickImagePath path;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, copy) pickImageBlock pickerBlock;
@end

@implementation WXRImagePicker

+(instancetype)shareImagePicker{
    static WXRImagePicker *imagePicker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imagePicker = [[WXRImagePicker alloc] init];
    });
    return imagePicker;
}

-(void)showImagePickerWithCropable:(BOOL)cropable cropFrame:(CGRect)cropFrame  pickPath:(PickImagePath)pickPath block:(pickImageBlock )backBlock{
    self.cropFrame = cropFrame;
    self.cropable = cropable;
    self.path = pickPath;
    self.pickerBlock = [backBlock copy];
    if (pickPath == PickImagePathPhotoAndCamera) {
        [self pickImagePaths];
    }else if (pickPath == PickImagePathPhoto || pickPath == PickImagePathLocalVideo){
        [self pickPhotoPath];
    }else if (pickPath == PickImagePathCamera){
        [self pickCameraPath];
    }
}
//选择方式
-(void)pickImagePaths{
    WeakSelf(self);
    
    EasyAlertView *alertV = [EasyAlertView alertViewWithTitle:nil subtitle:ChooseAvatarType AlertViewType:AlertViewTypeSystemActionSheet config:nil];
    [alertV addAlertItem:^EasyAlertItem *{
        return [EasyAlertItem itemWithTitle:Cancel type:AlertItemTypeSystemCancel callback:nil];
    }];
    [alertV addAlertItemWithTitle:TakePhoto type:AlertItemTypeSystemDefault callback:^(EasyAlertView *showview, long index) {
        [weakself pickCameraPath];
    }];
    [alertV addAlertItemWithTitle:ChooseFromAlbum type:AlertItemTypeSystemDefault callback:^(EasyAlertView *showview, long index) {
        [weakself pickPhotoPath];
    }];
    
    [alertV showAlertView];
}
//相机
-(void)pickCameraPath{
    if (![AppInfo checkCameraAuthorizationStatus]) {

        [EasyAlertView alertViewWithPart:^EasyAlertPart *{
            return [EasyAlertPart shared].setTitle(@"").setSubtitle(@"相机权限未开启，请前往设置开启").setAlertType(AlertViewTypeAlert) ;
        } config:^EasyAlertConfig *{
            return [EasyAlertConfig shared].settwoItemHorizontal(YES).setAnimationType(AlertAnimationTypeFade).setTintColor(WhiteTextColor).setBgViewEvent(NO).setSubtitleTextAligment(NSTextAlignmentCenter).setEffectType(AlertBgEffectTypeAlphaCover) ;
        } buttonArray:^NSArray<NSString *> *{
            return @[@"前往设置",Cancel] ;
        } callback:^(EasyAlertView *showview , long index) {
            if (!index) {
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                } else {
                    // Fallback on earlier versions
                }
            }
        }];
    }else{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *takePhoto = [[UIImagePickerController alloc] init];
        takePhoto.sourceType = UIImagePickerControllerSourceTypeCamera;
        takePhoto.delegate = self;
        takePhoto.allowsEditing = NO;
        [[CommonUtils currentViewController] presentViewController:takePhoto animated:YES completion:nil];
    } else {
        [EasyTextView showText:@"相机不可用"];
    }
    }
}

//相册
-(void)pickPhotoPath{
    if (![AppInfo checkPhotoAuthorizationStatus]) {
        [EasyAlertView alertViewWithPart:^EasyAlertPart *{
            return [EasyAlertPart shared].setTitle(@"").setSubtitle(@"相册权限未开启，请前往设置开启").setAlertType(AlertViewTypeAlert) ;
        } config:^EasyAlertConfig *{
            return [EasyAlertConfig shared].settwoItemHorizontal(YES).setAnimationType(AlertAnimationTypeFade).setTintColor(WhiteTextColor).setBgViewEvent(NO).setSubtitleTextAligment(NSTextAlignmentCenter).setEffectType(AlertBgEffectTypeAlphaCover) ;
        } buttonArray:^NSArray<NSString *> *{
            return @[@"前往设置",Cancel] ;
        } callback:^(EasyAlertView *showview , long index) {
            if (!index) {
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                } else {
                    // Fallback on earlier versions
                }
            }
        }];
    }else {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (self.path == PickImagePathLocalVideo) {
        if (self.cropable) {
            [EasyTextView showText:@"不支持视频裁剪,请将cropable置为NO"];
            return;
        }
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    }
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
        [[CommonUtils currentViewController] presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark =========UIImagePickerControllerDelegate=========
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^() {
        self.info = info;
        UIImage *pickimage = nil;
//        if (self.editable) {
//            pickimage  = [info objectForKey:UIImagePickerControllerEditedImage];
//        }else{
//            pickimage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        }
        if (self.path != PickImagePathLocalVideo) {
            pickimage = [info objectForKey:UIImagePickerControllerOriginalImage];
            pickimage = [pickimage imageByScalingToMaxSize];
        }
        if (!self.cropable && self.pickerBlock) {
            self.pickerBlock(pickimage,self.info);
        }else{
        // 裁剪
            CGRect cropperRect = self.cropFrame;
            if (cropperRect.size.height == 0 && cropperRect.size.width == 0 && cropperRect.origin.x == 0 && cropperRect.origin.y == 0) {
                cropperRect = CGRectMake(0, (MAINSCREEN_HEIGHT - MAINSCREEN_WIDTH)/2, MAINSCREEN_WIDTH, MAINSCREEN_WIDTH);
            }
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:pickimage cropFrame:cropperRect limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [[CommonUtils currentViewController] presentViewController:imgEditorVC animated:YES completion:nil];
        }
    }];
}

#pragma mark VPImageCropperDelegate  选取图片并裁剪成头像的控件
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        if (self.pickerBlock) {
            self.pickerBlock(editedImage,self.info);
        }
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
