//
//  ICTutorialOverlay.m
//  ICTutorialOverlay
//
//  Created by Ichito Nagata on 2013/08/19.
//
//

#define ANIMATION_DURATION 0.4f

#import "ICTutorialOverlay.h"

#import <QuartzCore/QuartzCore.h>

#pragma mark -
#pragma mark ICTutorialOverlayHole

@implementation ICTutorialOverlayHole

- (UIBezierPath*)bezierPath
{
    UIBezierPath *path;
    switch (self.form) {
        case ICTutorialOverlayHoleFormRectangle:
            path = [UIBezierPath bezierPathWithRect:self.rect];
            break;
        case ICTutorialOverlayHoleFormCircle:
            path = [UIBezierPath bezierPathWithOvalInRect:self.rect];
            break;
        case ICTutorialOverlayHoleFormRoundedRectangle:
            path = [UIBezierPath bezierPathWithRoundedRect:self.rect cornerRadius:7.0f];
            break;
        default:
            break;
    }
    return path;
}

- (BOOL)containsPoint:(CGPoint)point
{
    if (self.boundView) {
        UIView *rootView = self.boundView;
        while (rootView.superview) {
            rootView = rootView.superview;
        }
        CGRect rect = [self.boundView convertRect:self.boundView.bounds toView:rootView];
        return CGRectContainsPoint(rect, point);
    }
    
    UIBezierPath *path = [self bezierPath];
    if (path == nil) {
        return YES;
    }
    return [path containsPoint:point];
}

@end

#pragma mark -
#pragma mark ICTutorialOverlay

@interface ICTutorialOverlay ()
{
    NSMutableArray *holes;
}
@end

@implementation ICTutorialOverlay

static ICTutorialOverlay *showingOverlay;
+ (ICTutorialOverlay*)showingOverlay
{
    return showingOverlay;
}

- (void)initialize
{
    holes = [NSMutableArray array];
    self.opaque = NO;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.hideWhenTapped = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (ICTutorialOverlayHole*)addHoleWithRect:(CGRect)rect form:(ICTutorialOverlayHoleForm)form transparentEvent:(BOOL)transparentEvent
{
    ICTutorialOverlayHole *hole = [[ICTutorialOverlayHole alloc] init];
    hole.rect = rect;
    hole.form = form;
    hole.transparentEvent = transparentEvent;
    [holes addObject:hole];
    return hole;
}

- (ICTutorialOverlayHole*)addHoleWithView:(UIView*)view padding:(CGFloat)padding offset:(CGSize)offset form:(ICTutorialOverlayHoleForm)form transparentEvent:(BOOL)transparentEvent
{
    UIView *rootView = view;
    while (rootView.superview) {
        rootView = rootView.superview;
    }
    CGRect rect = [view convertRect:view.bounds toView:rootView];
    
    CGSize paddingSize = [self calculatePaddingSizeWithRect:rect defaultPadding:padding form:form];
    rect.origin.x += offset.width - paddingSize.width;
    rect.origin.y += offset.height - paddingSize.height;
    rect.size.width += paddingSize.width * 2;
    rect.size.height += paddingSize.height * 2;
    
    ICTutorialOverlayHole *hole = [self addHoleWithRect:rect form:form transparentEvent:transparentEvent];
    hole.boundView = view;
    return hole;
}

- (CGSize)calculatePaddingSizeWithRect:(CGRect)rect defaultPadding:(CGFloat)defaultPadding form:(ICTutorialOverlayHoleForm)form
{
    if (rect.size.width == 0 || rect.size.height == 0) {
        return CGSizeMake(defaultPadding, defaultPadding);
    }
    
    CGSize paddingSize;
    switch (form) {
        case ICTutorialOverlayHoleFormRectangle:
        case ICTutorialOverlayHoleFormRoundedRectangle:
        {
            paddingSize.width = defaultPadding;
            paddingSize.height = defaultPadding;
            break;
        }
        case ICTutorialOverlayHoleFormCircle:
        {
            CGFloat w = rect.size.width;
            CGFloat h = rect.size.height;
            CGFloat theta = atan2f(h, w);
            CGFloat sin = sinf(theta);
            CGFloat cos = cosf(theta);
            CGFloat coef = sqrtf(sin * sin + (h * h) / (w * w) * cos * cos);
            CGFloat cw = w * coef / sin;
            CGFloat ch = h * coef / sin;
            paddingSize.width = (cw - w) / 2 + defaultPadding;
            paddingSize.height = (ch - h) / 2 + defaultPadding;
            break;
        }
        default:
            break;
    }
    
    return paddingSize;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    for (ICTutorialOverlayHole *hole in holes) {
        if(! CGRectIsEmpty(CGRectIntersection(hole.rect, rect))) {
            UIBezierPath *path = [hole bezierPath];
            if (path) {
                [path fillWithBlendMode:kCGBlendModeClear alpha:1];
            }
        }
    }
    
    CGContextRestoreGState(context);
}


- (void)show
{
    if (self.isShown) {
        return;
    }
    
    if (showingOverlay) {
        [showingOverlay hide];
    }
    
    showingOverlay = self;
    
    if (self.willShowCallback) {
        self.willShowCallback();
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    [window bringSubviewToFront:self];

    if (self.animated) {
        self.alpha = 0.0f;
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.alpha = 1.0f;
        } completion:^(BOOL finished) {
            if (finished) {
                if (self.didShowCallback) {
                    self.didShowCallback();
                }
            }
        }];
    } else {
        if (self.didShowCallback) {
            self.didShowCallback();
        }
    }

}

- (void)hide
{
    if (! self.isShown) {
        return;
    }
    
    showingOverlay = nil;
    
    if (self.willHideCallback) {
        self.willHideCallback();
    }
    
    if (self.animated) {
        self.alpha = 1.0f;
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
                if (self.didHideCallback) {
                    self.didHideCallback();
                }
            }
        }];
    } else {
        [self removeFromSuperview];
        if (self.didHideCallback) {
            self.didHideCallback();
        }
    }

    

}

- (BOOL)isShown
{
    return self.superview != nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {

    for (ICTutorialOverlayHole *hole in holes) {
        if (! hole.transparentEvent) {
            continue;
        }
        if ([hole containsPoint:point]) {
            return NO;
        }
    }
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.hideWhenTapped) {
        [self hide];
    }
}

@end
