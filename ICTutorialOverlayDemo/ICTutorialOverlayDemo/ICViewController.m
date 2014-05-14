//
//  ICViewController.m
//  ICTutorialOverlayDemo
//
//  Created by Ichito Nagata on 2013/08/19.
//  Copyright (c) 2013年 Ichito Nagata. All rights reserved.
//

#import "ICViewController.h"

@interface ICViewController ()
{
    ICTutorialOverlay *overlay;
}
@end

@implementation ICViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    srand([[NSDate date] timeIntervalSinceReferenceDate]);
}

- (IBAction)didRectButtonTapped:(id)sender
{
    overlay = [[ICTutorialOverlay alloc] init];
    overlay.hideWhenTapped = NO;
    [overlay addHoleWithView:self.rectButton padding:4.0f form:ICTutorialOverlayHoleFormRectangle transparentEvent:NO];
    overlay.willShowCallback = ^{
        NSLog(@"willShowCallback invoked");
    };
    overlay.didShowCallback = ^{
        NSLog(@"didShowCallback invoked");
    };
    overlay.willHideCallback = ^{
        NSLog(@"willHideCallback invoked");
    };
    overlay.didHideCallback = ^{
        NSLog(@"didHideCallback invoked");
    };
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 300, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = @"You can add any subviews into overlay.\nThis will not disappear when tapped";
    [overlay addSubview:label];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(20, 350, 80, 40);
    [closeButton addTarget:self action:@selector(didCloseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [overlay addSubview:closeButton];
    
    [overlay show];
}

- (IBAction)didRoundRectButtonTapped:(id)sender
{
    if (overlay && overlay.isShown) {
        [overlay hide];
        return;
    }
    
    overlay = [[ICTutorialOverlay alloc] init];
    overlay.hideWhenTapped = NO;
    overlay.animated = YES;
    [overlay addHoleWithView:self.roundRectButton padding:4.0f form:ICTutorialOverlayHoleFormRoundedRectangle transparentEvent:YES];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 170, 220, 150)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = @"You can tap views beneath this overlay using transparentEvent:YES.\nTap once again to close.";
    [overlay addSubview:label];
    
    [overlay show];
}

- (void)didCloseButtonTapped:(id)sender
{
    [overlay hide];
}

- (IBAction)didCircleButtonTapped:(id)sender
{
    if (overlay && overlay.isShown) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"You are already showing overlay!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    overlay = [[ICTutorialOverlay alloc] init];
    overlay.hideWhenTapped = NO;
    [overlay addHoleWithView:self.circleButton padding:24.0f form:ICTutorialOverlayHoleFormCircle transparentEvent:YES];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 300, 80)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = @"If you add a hole using view, ignore events which happen at outside of the view. i.e. You can't tap other buttons.";
    [overlay addSubview:label];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(20, 370, 80, 40);
    [closeButton addTarget:self action:@selector(didCloseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [overlay addSubview:closeButton];
    
    [overlay show];
}

- (IBAction)didRandomButtonTapped:(id)sender
{
    CGRect rect = CGRectMake((CGFloat)rand() / RAND_MAX * 300, (CGFloat)rand() / RAND_MAX * 300, 100, 100);
    
    overlay = [[ICTutorialOverlay alloc] init];
    overlay.hideWhenTapped = YES;
    [overlay addHoleWithRect:rect form:ICTutorialOverlayHoleFormCircle transparentEvent:NO];
    [overlay show];
}

# pragma mark -
# pragma mark helper

- (void)showAlert:(NSString*)message
{
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
