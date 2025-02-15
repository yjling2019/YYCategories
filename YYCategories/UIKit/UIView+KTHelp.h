//
//  UIView+KTHelp.h
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/3.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIView`.
 */
@interface UIView (KTHelp)

/**
 Create a snapshot image of the complete view hierarchy.
 */
- (nullable UIImage *)kt_snapshotImage;

/**
 Create a snapshot image of the complete view hierarchy.
 @discussion It's faster than "snapshotImage", but may cause screen updates.
 See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
 */
- (nullable UIImage *)kt_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

/**
 Create a snapshot PDF of the complete view hierarchy.
 */
- (nullable NSData *)kt_snapshotPDF;

/**
 Shortcut to set the view.layer's shadow
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)kt_setLayerShadow:(nullable UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 Remove all subviews.
 
 @warning Never call this method inside your view's drawRect: method.
 */
- (void)kt_removeAllSubviews;

/**
 Returns the view's view controller (may be nil).
 */
@property (nullable, nonatomic, readonly) UIViewController *kt_viewController;

/**
 Returns the visible alpha on screen, taking into account superview and window.
 */
@property (nonatomic, readonly) CGFloat kt_visibleAlpha;

/**
 Converts a point from the receiver's coordinate system to that of the specified view or window.
 
 @param point A point specified in the local coordinate system (bounds) of the receiver.
 @param view  The view or window into whose coordinate system point is to be converted. 
    If view is nil, this method instead converts to window base coordinates.
 @return The point converted to the coordinate system of view.
 */
- (CGPoint)kt_convertPoint:(CGPoint)point toViewOrWindow:(nullable UIView *)view;

/**
 Converts a point from the coordinate system of a given view or window to that of the receiver.
 
 @param point A point specified in the local coordinate system (bounds) of view.
 @param view  The view or window with point in its coordinate system. 
    If view is nil, this method instead converts from window base coordinates.
 @return The point converted to the local coordinate system (bounds) of the receiver.
 */
- (CGPoint)kt_convertPoint:(CGPoint)point fromViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the receiver's coordinate system to that of another view or window.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of the receiver.
 @param view The view or window that is the target of the conversion operation. If view is nil, this method instead converts to window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)kt_convertRect:(CGRect)rect toViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the coordinate system of another view or window to that of the receiver.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of view.
 @param view The view or window with rect in its coordinate system.
    If view is nil, this method instead converts from window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)kt_convertRect:(CGRect)rect fromViewOrWindow:(nullable UIView *)view;


@property (nonatomic) CGFloat kt_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat kt_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat kt_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat kt_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat kt_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat kt_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat kt_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat kt_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint kt_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  kt_size;        ///< Shortcut for frame.size.

@end

NS_ASSUME_NONNULL_END
