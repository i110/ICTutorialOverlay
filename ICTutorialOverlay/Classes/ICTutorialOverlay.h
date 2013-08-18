//
//  ICTutorialOverlay.h
//  ICTutorialOverlay
//
//  Created by Ichito Nagata on 2013/08/19.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    ICTutorialOverlayHoleFormRectangle = 0,
    ICTutorialOverlayHoleFormCircle    = 1,
    ICTutorialOverlayHoleFormRoundedRectangle = 2,
} ICTutorialOverlayHoleForm;

@interface ICTutorialOverlayHole : NSObject

@property (nonatomic) CGRect rect;
@property (nonatomic) ICTutorialOverlayHoleForm form;
@property (nonatomic) BOOL transparentEvent;
@property (nonatomic) UIView *boundView;

- (UIBezierPath*)bezierPath;
- (BOOL)containsPoint:(CGPoint)point;

@end

@class ICTutorialOverlay;
@protocol ICTutorialOverlayDelegate <NSObject>

@optional
- (void)didShowTutorialOverlay:(ICTutorialOverlay*)overlay;
- (void)didHideTutorialOverlay:(ICTutorialOverlay*)overlay;

@end

@interface ICTutorialOverlay : UIView

@property (nonatomic) id<ICTutorialOverlayDelegate> delegate;
@property (nonatomic) BOOL hideWhenTapped;

- (ICTutorialOverlayHole*)addHoleWithRect:(CGRect)rect form:(ICTutorialOverlayHoleForm)form transparentEvent:(BOOL)transparentEvent;
- (ICTutorialOverlayHole*)addHoleWithView:(UIView*)view padding:(CGFloat)padding form:(ICTutorialOverlayHoleForm)form transparentEvent:(BOOL)transparentEvent;

- (void)show;
- (void)hide;

@end
