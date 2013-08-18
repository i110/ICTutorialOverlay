//
//  ICViewController.h
//  ICTutorialOverlayDemo
//
//  Created by Ichito Nagata on 2013/08/19.
//  Copyright (c) 2013年 Ichito Nagata. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ICTutorialOverlay.h"

@interface ICViewController : UIViewController
<ICTutorialOverlayDelegate>

@property (nonatomic, weak) IBOutlet UIButton *rectButton;
@property (nonatomic, weak) IBOutlet UIButton *roundRectButton;
@property (nonatomic, weak) IBOutlet UIButton *circleButton;
@property (nonatomic, weak) IBOutlet UIButton *randomButton;

- (IBAction)didRectButtonTapped:(id)sender;
- (IBAction)didRoundRectButtonTapped:(id)sender;
- (IBAction)didCircleButtonTapped:(id)sender;
- (IBAction)didRandomButtonTapped:(id)sender;

@end
