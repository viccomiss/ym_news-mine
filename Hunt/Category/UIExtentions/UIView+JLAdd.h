//
//  UIView+JLAdd.h
//  wxer_manager
//
//  Created by JackyLiang on 2017/7/25.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger{
    
    LXShadowPathLeft,
    
    LXShadowPathRight,
    
    LXShadowPathTop,
    
    LXShadowPathBottom,
    
    LXShadowPathNoTop,
    
    LXShadowPathAllSide
    
} LXShadowPathSide;

@interface UIView (JLAdd)

/*
 * shadowColor 阴影颜色
 *
 * shadowOpacity 阴影透明度，默认0
 *
 * shadowRadius  阴影半径，默认3
 *
 * shadowPathSide 设置哪一侧的阴影，
 
 * shadowPathWidth 阴影的宽度，
 
 */

-(void)LX_SetShadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(LXShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth;

/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

/**
 生成截图

 @param frame frame
 @param cutout 是否需要剪裁
 @return image
 */
- (UIImage *)screenshotWithFrame:(CGRect)frame isCutout:(BOOL)cutout;


/**
 截取view指定区域

 @param theView view
 @param r frame
 @return image
 */
- (UIImage *)cutoutImageWithFrame:(CGRect)theFrame image:(UIImage *)screenshot;

//按指定比例缩放
-(CGRect)imageCompressForWidth:(UIView *)view targetWidth:(CGFloat)defineWidth;

@end
