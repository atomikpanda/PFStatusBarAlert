
// PFStatusBarAlert

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PFStatusBarAlert.h"

static void statusbar_got_notification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo )
{
    if (observer)
        [(PFStatusBarAlert *)observer showOverlayForSeconds:5.5];
}

@implementation PFStatusBarAlert

@synthesize applicationWindow=_applicationWindow, message=_message, notification=_notification, action=_action;
@synthesize target=_target, actionButton=_actionButton, backgroundColor=_backgroundColor, textColor=_textColor;
@synthesize oldLevel=_oldLevel;

- (id)initWithMessage:(NSString *)message notification:(NSString *)notification action:(SEL)action target:(id)target
{
 self = [self init];

 // checking for screen orientation change
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusBarFrame) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

// checking for status bar change
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusBarFrame) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];


 self.message = message;

 if (notification)
  _notification = [notification copy];

 self.action = action;
 self.target = target;

 if (self.notification)
 {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), self, (CFNotificationCallback)statusbar_got_notification,
  (CFStringRef)self.notification, NULL, CFNotificationSuspensionBehaviorCoalesce);
 }


 self.applicationWindow = [UIApplication sharedApplication].keyWindow;
 self.oldLevel = self.applicationWindow.windowLevel;

 self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
 self.actionButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
 self.actionButton.alpha = 0.0f;

 if (self.target && self.action)
  [self.actionButton addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];


  self.backgroundColor = [UIColor colorWithHue:0.15 saturation:0.00 brightness:0.96 alpha:1.00];
  self.textColor = [UIColor blackColor];

 self.actionButton.backgroundColor = self.backgroundColor;

 return self;
}

- (void)updateStatusBarFrame
{
    UIView *view = self.actionButton;
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
}

- (void)showOverlayForSeconds:(float)seconds
{

  if (self.actionButton.isHidden)
    self.actionButton.hidden = NO;

  self.applicationWindow.windowLevel = UIWindowLevelStatusBar;

  [self.actionButton setTitle:self.message forState:UIControlStateNormal];
  [self.actionButton setTitleColor:self.textColor forState:UIControlStateNormal];
  self.actionButton.backgroundColor  = self.backgroundColor;
  self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];

  [self.applicationWindow addSubview:self.actionButton];
  [self.applicationWindow bringSubviewToFront:self.actionButton];

  [UIView animateWithDuration:0.3f animations:^{

    self.actionButton.alpha = 1.0f;

  } completion:^(BOOL finished) {

    [NSTimer scheduledTimerWithTimeInterval:seconds
    target:self
    selector:@selector(hideOverlay)
    userInfo:nil
    repeats:NO];

  }];
}

- (void)hideOverlay
{
  [UIView animateWithDuration:0.3f animations:^{

    self.actionButton.alpha = 0.0f;
    self.applicationWindow.windowLevel = self.oldLevel;
  } completion:^(BOOL finished) {

    [self.actionButton removeFromSuperview];
    self.actionButton.hidden = YES;
  }];
}

- (void)dealloc
{
  self.message = nil;
  self.target = nil;

  if (_notification)
    [_notification release];

  self.actionButton = nil;
  self.backgroundColor = nil;
  self.textColor = nil;

  [super dealloc];
}

@end
