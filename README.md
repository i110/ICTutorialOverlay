# ICTutorialOverlay

A utility for making "Overlay Tutorial"

## ICTutorialOverlayDemo

To run the demo, clone this repository or download as .zip and open ICTutorialOverlayDemo.xcworkspace
It is very important to open the .xcworkspace file if you want to run the demo.

## Adding ICTutorialOverlay to your project

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add ICTutorialOverlay to your project.

1.  Add ICTutorialOverlay to your Podfile `pod 'ICTutorialOverlay'`.
2.  Install the pod(s) by running `pod install`.
3.  Include ICTutorialOverlay to your files with `#import "ICTutorialOverlay.h"`.

### Clone from Github

1.  Clone repository from github and copy files directly, or add it as a git submodule.
2.  Add ICTutorialOverlay (.h and .m) files to your project.

### Example Usage

```objective-c
ICTutorialOverlay *overlay = [[ICTutorialOverlay alloc] init];
overlay.hideWhenTapped = NO;
overlay.animated = YES;
[overlay addHoleWithView:self.roundRectButton padding:8.0f offset:CGSizeZero form:ICTutorialOverlayHoleFormRoundedRectangle transparentEvent:YES];


UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 170, 220, 150)];
label.backgroundColor = [UIColor clearColor];
label.textColor = [UIColor whiteColor];
label.numberOfLines = 0;
label.text = @"You can place any views on the overlay";
[overlay addSubview:label];

[overlay show];
```

## Suggestions, requests, feedback and acknowledgements

Any feedback can be can be sent to: i.nagata110@gmail.com.

This software is licensed under the MIT License.
