#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PFStatusBarAlert.h"

@interface UIApplication ()
- (CGRect)statusBarFrameForOrientation:(long long)ori;
@end

static void statusbar_got_notification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo )
{
    if (observer)
        [(PFStatusBarAlert *)observer showOverlayForSeconds:5.5];
}

@implementation PFStatusBarAlert

@synthesize statusBarOverlay=_statusBarOverlay, message=_message, notification=_notification, action=_action;
@synthesize target=_target, actionButton=_actionButton, backgroundColor=_backgroundColor, textColor=_textColor;

- (id)initWithMessage:(NSString *)message notification:(NSString *)notification action:(SEL)action target:(id)target
{
 self = [self init];

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

 self.statusBarOverlay = [[UIWindow alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]];
 self.statusBarOverlay.alpha = 0.0f;

 self.actionButton = [[UIButton alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]];
 if (self.target && self.action)
  [self.actionButton addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];


  self.actionButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.statusBarOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

 self.backgroundColor = [UIColor colorWithHue:0.15 saturation:0.00 brightness:0.96 alpha:1.00];
 self.textColor = [UIColor blackColor];


 return self;
}

- (void)interfaceOrientationDidChange:(NSNotification *)notif
{
  self.statusBarOverlay.frame = [[[UIApplication sharedApplication] keyWindow] bounds];

  self.actionButton.frame = [[[UIApplication sharedApplication] keyWindow] bounds];
}

- (void)showOverlayForSeconds:(float)seconds
{
  [self interfaceOrientationDidChange:nil];
  if (self.statusBarOverlay.isHidden)
    self.statusBarOverlay.hidden = NO;

  self.statusBarOverlay.windowLevel = UIWindowLevelStatusBar+1;
  self.statusBarOverlay.backgroundColor = self.backgroundColor;
  [self.statusBarOverlay makeKeyAndVisible];



  [self.actionButton setTitle:self.message forState:UIControlStateNormal];
  [self.actionButton setTitleColor:self.textColor forState:UIControlStateNormal];
  self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];

  [self.statusBarOverlay addSubview:self.actionButton];

  [UIView animateWithDuration:0.3f animations:^{

    self.statusBarOverlay.alpha = 1.0f;

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

    self.statusBarOverlay.alpha = 0.0f;

  } completion:^(BOOL finished) {
    self.statusBarOverlay.hidden = YES;
  }];
}

- (void)dealloc
{
  self.message = nil;
  self.statusBarOverlay = nil;
  self.target = nil;

  if (_notification)
    [_notification release];

  self.actionButton = nil;
  self.backgroundColor = nil;
  self.textColor = nil;

  [super dealloc];
}

@end
