### Simple Status Bar Alert
I like to use this for showing a small alert that users can tap on to respring the device once preferences are changed.
You can use it however you would like since it's not limited to only notifications.

#### *PFStatusBarAlert.h*
``` Objective-C

@interface PFStatusBarAlert : NSObject
- (id)initWithMessage:(NSString *)message notification:(NSString *)notification action:(SEL)action target:(id)target;
@property (nonatomic, copy) NSString *message; // Message for status bar button
@property (nonatomic, copy, readonly) NSString *notification; // notification to listen for (prefs changed) NOTE: optional
@property (nonatomic, retain) UIColor *backgroundColor; // modify if you want a different color than default
@property (nonatomic, retain) UIColor *textColor; // modify if you want a different color than default
@property (nonatomic, assign) SEL action; // action to send when tapped
@property (nonatomic, retain) id target; // target to send action to when tapped
@property (nonatomic, retain) UIWindow *applicationWindow; // app window
@property (nonatomic, retain) UIButton *actionButton; // main text button
@property (nonatomic, assign) int oldLevel; // private old window level before overlaying
- (void)showOverlayForSeconds:(float)seconds; // this will be called for 5.5s automatically on notification. NOTE: if no notification is set call manually
- (void)hideOverlay; // hide overlay NOTE: you won't need to call this since the timer hides automatically
@end

```
