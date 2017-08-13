// METEORA: iOS 9 LS FOR iOS 10
#import "Headers.h"

static BOOL kEnabled;
static BOOL kDoubleTap;
static BOOL kRemoveChevron;
static BOOL kRemoveMediaPlayerBlur;
static BOOL kCustomSliderText;
static NSString *kCustomText;

#define kTouchIDFingerUp    0
#define kTouchIDFingerDown  1
#define kTouchIDFingerHeld  2
#define kTouchIDMatched     3
#define kTouchIDSuccess     4
#define kTouchIDDisabled    6
#define kTouchIDNotMatched 10

static NSString *noAlbumImagePath = @"/Library/Application Support/Meteora/noalbumart.png";

UITapGestureRecognizer *lockTapGesture;
UIView *mediaControls;
UIView *artworkView;
UIBlurEffect *mediaEffect;
UIVisualEffectView *mediaVisualEffect;
UIView *blurView;
UIImageView* _artworkImageView;
UIView *notifsView;
CGRect artworkFrame;
SBMediaController *mediaController = [%c(SBMediaController) sharedInstance];
SBUILegibilityLabel *timeLabel;


%hook SBLockScreenNotificationListView
- (void)updateForAdditionOfItemAtIndex:(unsigned long long)arg1 allowHighlightOnInsert:(BOOL)arg2 {
  %orig;

  // Check if exists
  for(UIView *view in self.superview.superview.superview.superview.subviews) {
    if(view.tag == 167) {
      return;
    }
  }

  // Create blur view
  blurView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  blurView.backgroundColor = [UIColor clearColor];
  blurView.alpha = 0;
  blurView.tag = 167;

  UIVisualEffectView *blurEffect = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
  blurEffect.frame = blurView.bounds;
  [blurView addSubview:blurEffect];

  [self.superview.superview.superview.superview addSubview:blurView];
  [self.superview.superview.superview.superview sendSubviewToBack:blurView];

  [UIView animateWithDuration:0.4 animations:^(void) {
    blurView.alpha = 1;
  } completion:nil];
}
%end

%hook SBControlCenterController
-(void)setUILocked:(BOOL)arg1 {
	if(kEnabled && [[%c(SBLockScreenManager) sharedInstance] isUILocked]) {
	     %orig(YES);
	}
	
	else {
	   %orig(arg1);	
	}
}
%end
	
// VOLUME CONTROL
%hook VolumeControl
-(void)increaseVolume {
  %orig;

  if (kEnabled && mediaController.isPlaying && [[%c(SBLockScreenManager) sharedInstance] isUILocked]) {
  [[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] + 0.0];
  }
}

-(void)decreaseVolume {
  %orig;

  if (kEnabled && mediaController.isPlaying && [[%c(SBLockScreenManager) sharedInstance] isUILocked]) {
    [[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] - 0.0];
  }
}
%end

// SLIDE TO UNLOCK TEXT
%hook _UIGlintyStringView 
-(void)layoutSubviews {
  if (kEnabled == YES && ![self.text isEqualToString:@"slide to power off"]) {
    self.font = [UIFont fontWithName:@"HelveticaNeue" size:23.0];     
    self.clipsToBounds = YES;
  } else if (kEnabled == YES && ![self.text isEqualToString:@"slide to power off"] && kCustomSliderText == YES) {
    self.text = kCustomText;
    self.font = [UIFont fontWithName:@"HelveticaNeue" size:23.0];     
    self.clipsToBounds = YES;
  } else {
    %orig;
  }
}
%end 

// CAMERA ICON
%hook SBSlideUpAppGrabberView
-(void)layoutSubviews {
  %orig;

  if (kEnabled == YES) {
    UIImageView *saturatedIconView = [self valueForKey:@"_saturatedIconView"];
      
    UIImage *cameraImage = [saturatedIconView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    saturatedIconView.tintColor = [UIColor whiteColor];

    UIImageView *grabberIconImageView = [[UIImageView alloc] init];
    grabberIconImageView.frame = saturatedIconView.frame;
    grabberIconImageView.bounds = saturatedIconView.bounds;
    grabberIconImageView.image = cameraImage;
    [saturatedIconView addSubview:grabberIconImageView];
    
    UIView *backgroundView = [self valueForKey:@"_backgroundView"];
    backgroundView.hidden = YES;
    UIView *tintView = [self valueForKey:@"tintView"];
    tintView.hidden = YES;
  }
}     
%end

// DISABLE SHOW PASSCODE BUTTON
%hook SBHomeButtonShowPasscodeRecognizer
-(void)setDelegate:(id)arg1 {
  if (!kEnabled) {
    %orig;
  }
}     
%end

%hook SBHomeButtonShowPasscodeRecognizerDelegate
-(void)homeButtonShowPasscodeRecognizerRequestsPasscodeUIToBeShown:(id)arg1 {
  if (!kEnabled) {
    %orig;
  }
}

-(void)homeButtonShowPasscodeRecognizerDidFailToRecognize:(id)arg1 {
  if (!kEnabled) {
    %orig;
  }
}
%end

// SHOW SLIDE TO UNLOCK
%hook SBLockScreenView 
-(void)setSlideToUnlockHidden:(BOOL)arg1 forRequester:(id)arg2 {
  if (kEnabled) {
    %orig(NO, arg2);
  } else {
    %orig;
  }
}

- (void)setSlideToUnlockBlurHidden:(BOOL)arg1 forRequester:(id)arg2 {
  if (kEnabled) {
    %orig(NO, arg2);
  } else {
    %orig;
  }
}

// LAYOUT LOCKSCREEN VIEWS
-(void)layoutSubviews {
  %orig;

  if (kEnabled) {
    // Grabbers
    SBUIChevronView *topGrabberView = [self valueForKey:@"_topGrabberView"];
    topGrabberView.alpha = 1;
    topGrabberView.hidden = NO;
    topGrabberView.userInteractionEnabled = YES;
    [self addSubview:topGrabberView];
    [self sendSubviewToBack:topGrabberView];

    if (kRemoveChevron || mediaController.isPlaying) {
      topGrabberView.hidden = YES;
    }
    
    SBUIChevronView *bottomGrabberView = [self valueForKey:@"_bottomGrabberView"];
    bottomGrabberView.alpha = 1;
    bottomGrabberView.hidden = NO;
    [self addSubview:bottomGrabberView];
    [self sendSubviewToBack:bottomGrabberView];
    
    if (kRemoveChevron) {
      bottomGrabberView.hidden = YES;
    }
	
    // Vibrancy bug fix
    SBWallpaperEffectView *slideToUnlockBackgroundView = [self valueForKey:@"_slideToUnlockBackgroundView"];
    slideToUnlockBackgroundView.alpha = 0;
	
    // Notification Center Gesture
    UIScreenEdgePanGestureRecognizer *ncSwipeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(ncSwipeGestureAction)];
    ncSwipeGesture.edges = UIRectEdgeTop;
    [[%c(FBSystemGestureManager) sharedInstance] addGestureRecognizer:ncSwipeGesture toDisplay:[%c(FBDisplayManager) mainDisplay]];
    
    // Control Center Gesture
    UIScreenEdgePanGestureRecognizer *ccPanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(ccPanGestureAction)];
    ccPanGesture.edges = UIRectEdgeBottom;
    [self addGestureRecognizer:ccPanGesture];

    // 2 Finger Tap Gesture
    if (kDoubleTap == YES) {
      lockTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapLockAction)];
      lockTapGesture.numberOfTouchesRequired = 2;
      //lockTapGesture.numberOfTapsRequired = 2;
      [self addGestureRecognizer:lockTapGesture];
    }
    
	//Remove the duplicate notification view from the lockscreen.
    UIView * _notificationView = [self valueForKey:@"_notificationView"];
   [_notificationView removeFromSuperview];
	
    // Notifications View
    UIView *_foregroundLockView = MSHookIvar<UIView*>(self, "_foregroundLockView");
    for(UIView *notifView in _foregroundLockView.subviews) {
      if([notifView class] == NSClassFromString(@"MTONotificationsView")) {
	return;
      }
    }
	notifsView = [[%c(MTONotificationsView) alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_foregroundLockView addSubview:notifsView];
	if (mediaController.isPlaying) {
	 [mediaControls removeFromSuperview];
}
  }
  
}

// 2 FINGER TAP GESTURE
%new
-(void)doubleTapLockAction {
  [((SpringBoard *)[%c(SpringBoard) sharedApplication]) _simulateLockButtonPress];
}

// SHOW NOTIFICATION CENTER
%new
-(void)ncSwipeGestureAction {
  [[%c(SBNotificationCenterController) sharedInstance] presentAnimated:YES];
}

// SHOW CONTROL CENTER
%new
-(void)ccPanGestureAction {
  [[%c(SBControlCenterController) sharedInstance] presentAnimated:YES];
}

// LOCKSCREEN MEDIA CONTROLS
-(void)_layoutMediaControlsView { 
  if (kEnabled && mediaController.isPlaying) {
    UIView *_foregroundLockView = MSHookIvar<UIView*>(self, "_foregroundLockView");
    for (UIView* sub in _foregroundLockView.subviews) {
      if ([sub class] == NSClassFromString(@"MTOMediaView")) {
	return;
      }
    }
    
    int deviceHeight = [UIScreen mainScreen].bounds.size.height;
    
    switch (deviceHeight) {
      case 736: // iPhone 5.5in
	mediaControls = [[%c(MTOMediaView) alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-20,  200)];
	[_foregroundLockView addSubview:mediaControls];
	mediaControls.userInteractionEnabled = YES;
	break;
      
      case 667:  // iPhone 4.7in
	mediaControls = [[%c(MTOMediaView) alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-20,  200)];
	[_foregroundLockView addSubview:mediaControls];
	mediaControls.userInteractionEnabled = YES;
	break;
	    
      case 568: // iPhone 4in
	mediaControls = [[%c(MTOMediaView) alloc] initWithFrame:CGRectMake(5.5, 10, 300, 200)];
	[_foregroundLockView addSubview:mediaControls];
	mediaControls.userInteractionEnabled = YES;
	break;
      
      default: // iPad
	mediaControls = [[%c(MTOMediaView) alloc] initWithFrame:CGRectMake(5.5, 10, 300, 200)];
	[_foregroundLockView addSubview:mediaControls];
	mediaControls.userInteractionEnabled = YES;
	break;
	
    }
    if (kRemoveMediaPlayerBlur) {
      mediaVisualEffect = nil;
    } else {
      mediaEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
      mediaVisualEffect = [[UIVisualEffectView alloc] initWithEffect:mediaEffect];
      mediaVisualEffect.frame = [[UIScreen mainScreen] bounds];
      [self addSubview:mediaVisualEffect];
      [self sendSubviewToBack:mediaVisualEffect];
    }
  }
}

// LAYOUT MEDIA CONTROLS
-(void)setMediaControlsView:(id)arg1 {
  if (kEnabled && mediaController.isPlaying) {
    [self _layoutMediaControlsView];
  } else if (kEnabled && mediaController.isPaused && !kRemoveMediaPlayerBlur) {
    [mediaControls removeFromSuperview];
    [mediaVisualEffect removeFromSuperview];
  } else if (kEnabled && mediaController.isPaused && kRemoveMediaPlayerBlur) {
    [mediaControls removeFromSuperview];
  } else {
    %orig;
  }
}

- (void)dealloc {
 %orig;
}
%end

// touch id fix (maybe or just a fluke, may have side effects) from DGh0st
%hook SBFUserAuthenticationController
-(void)_revokeAuthenticationImmediately:(BOOL)arg1 forPublicReason:(id)arg2 {
  if (kEnabled && arg1 && ([arg2 isEqualToString:@"BioUnlock in Old LockScreen"] || [arg2 isEqualToString:@"StartupTransitionToLockOut"])) {
    
  } else {
    %orig(arg1, arg2);
  }
}

-(void)revokeAuthenticationImmediatelyForPublicReason:(id)arg1 {
  if (kEnabled && ([arg1 isEqualToString:@"BioUnlock in Old LockScreen"] || [arg1 isEqualToString:@"StartupTransitionToLockOut"])) {

  } else {
    %orig(arg1);
  }
}

-(void)revokeAuthenticationImmediatelyIfNecessaryForPublicReason:(id)arg1 {
  if (kEnabled && ([arg1 isEqualToString:@"BioUnlock in Old LockScreen"] || [arg1 isEqualToString:@"StartupTransitionToLockOut"])) {

  } else {
    %orig(arg1);
  }
}

-(void)revokeAuthenticationIfNecessaryForPublicReason:(id)arg1 {
  if (kEnabled && ([arg1 isEqualToString:@"BioUnlock in Old LockScreen"] || [arg1 isEqualToString:@"StartupTransitionToLockOut"])) {

  } else {
    %orig(arg1);
  }
}
%end

// SHOW TIME AND DATE
%hook SBFLockScreenDateView
-(void)layoutSubviews {
  if (kEnabled && mediaController.isPlaying) {
    timeLabel = [self valueForKey:@"_timeLabel"];
    timeLabel.hidden = YES;
  } else if (kEnabled && mediaController.isPaused) {
    %orig;
    timeLabel = [self valueForKey:@"_timeLabel"];
    timeLabel.hidden = NO;
    [mediaControls removeFromSuperview];
    [mediaVisualEffect removeFromSuperview];
  } else {
    %orig;
  }
}
%end

// HIDE VOLUME HUD (MEDIA PLAYING)
%hook SBVolumeHUDView
- (void)layoutSubviews {
  %orig;

  if (kEnabled && [[%c(SBLockScreenManager) sharedInstance] isUILocked])  {
    [self setHidden:YES];     
  }
}
%end

// DISABLE HOME PRESS UNLOCK (NOT WORKING)
%hook SBLockScreenViewControllerBase 
-(id)createHomeButtonShowPasscodeRecognizerForHomeButtonPress {
  if (kEnabled) {
    return nil;
  } else {
    return %orig;
  }
}

// TOUCH ID FIX (NOT WORKING)
-(void)handleBiometricEvent:(unsigned long long)arg1 {
  %orig;
  
  if (kEnabled && [[%c(SBLockScreenManager) sharedInstance] isUILocked] && arg1 == kTouchIDSuccess) {
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:unlockSound],&soundID);
    AudioServicesPlaySystemSound(soundID);
  } else {
    %orig;
  }
}
%end
    
%hook SBLockScreenViewController 
-(void)handleBiometricEvent:(unsigned long long)arg1 {
  %orig;
  
  if (kEnabled && [[%c(SBLockScreenManager) sharedInstance] isUILocked] && arg1 == kTouchIDSuccess) {
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:unlockSound],&soundID);
    AudioServicesPlaySystemSound(soundID);
  } else {
    %orig;
  }
}

// SHOW MEDIA CONTROLS
%new -(void)presentMediaControls {
  [[%c(SBLockscreenView) sharedInstance] _layoutMediaControlsView];   
}

// HANDLE VOLUME EVENTS
-(BOOL)handleVolumeUpButtonPressed { 
  return %orig;
}

-(BOOL)handleVolumeDownButtonPressed {
  return %orig;
}

// DEVICE LOCKING FIX
-(BOOL)canUIUnlockFromSource:(int)arg1 {
  if (kEnabled == YES) {
    return YES;
  } else {
    return %orig;
  }
}

// HIDE DATE (MEDIA PLAYING)
-(BOOL)_shouldShowDate {
  if (kEnabled && mediaController.isPlaying) {
    return FALSE;
  } else {
    return %orig;
  }
}     

// SHOW STATUS BAR TIME (MEDIA PLAYING)
-(BOOL)shouldShowLockStatusBarTime {
  if (kEnabled && mediaController.isPlaying) {
    return TRUE;
  } else {
    return %orig;
  }
}     
    
// SHOW SLIDE TO UNLOCK
- (BOOL)shouldShowSlideToUnlockTextImmediately {
  if (kEnabled) {
    return TRUE;
  } else {
    return %orig;
  }
}

// SCREEN TIMEOUT FIX
- (void)_handleDisplayTurnedOnWhileUILocked:(id)arg1 {
  if (kEnabled && [self valueForKey:@"_isInScreenOffMode"]) {
    YES;
  } else {
    %orig;
  }
}
%end

// TOUCH ID FIX (NOT WORKING)
%hook SBLockScreenManager
- (void)dashBoardViewController:(id)arg1 requestsTouchIDDisabled:(BOOL)arg2 forReason:(id)arg3 {
  %orig(arg1, FALSE, arg3);
}

- (void)setBiometricAutoUnlockingDisabled:(BOOL)arg1 forReason:(id)arg2 {
  %orig(FALSE, arg2);
}

- (void)homeButtonShowPasscodeRecognizerRequestsPasscodeUIToBeShown:(id)arg1 {
  if (!kEnabled) {
    %orig;
  }
}

- (void)homeButtonShowPasscodeRecognizerDidFailToRecognize:(id)arg1 {
  if (!kEnabled) {
    %orig;
  }
}

- (void)_setHomeButtonShowPasscodeRecognizer:(id)arg1 {
  if (!kEnabled) {
    %orig;
  }
}
%end

%hook SBUIPasscodeLockViewBase
- (void)setBiometricAuthenticationAllowed:(BOOL)arg1 {
  if (kEnabled) {
    %orig(TRUE);
  } else {
    %orig;
  }
}

- (BOOL)isBiometricAuthenticationAllowed {
  if (kEnabled) {
    return TRUE;
  } else {
    return %orig;
  }
}
%end

// DISABLE DASHBOARD (iOS 10 LS)
%hook SBLockScreenDefaults
- (void)setUseDashBoard:(BOOL)arg1 {
  if (kEnabled) {
    %orig(NO);	  
  } else {
    %orig;
  }
}

- (BOOL)useDashBoard {
  if (kEnabled) {
    return FALSE;
  } else {
    return %orig;   
  }  
}

- (void)_bindAndRegisterDefaults {
  %orig;
  if (kEnabled) {
    [self performSelector:@selector(setUseDashBoard:)];
  }
}     
%end

// NOTIFICATIONS VIEW
@implementation MTONotificationsView
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];

  if (self != nil) {
    _notificationController = [[%c(SBLockScreenNotificationListController) alloc] init];
    _notificationController.view.frame = frame;
    [self addSubview:_notificationController.view];
  }
  return self;
}
@end

// MEDIA CONTROLS
@implementation MTOMediaView
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];

  if (self != nil) {
    _mediaController = [[%c(MPULockScreenMediaControlsViewController) alloc] init];
    _mediaController.view.frame = frame;
    [self addSubview:_mediaController.view];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAlbumArtInfo:) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];	
  }
  return self;
}

- (void)layoutSubviews {
  int devicesHeight = [UIScreen mainScreen].bounds.size.height;
  
  switch (devicesHeight) {
    case 736: // iPhone 5.5in
      artworkFrame = CGRectMake(32.5, 230, 360, 360);
      _artworkImageView = [[UIImageView alloc] initWithFrame:artworkFrame];
      [self addSubview:_artworkImageView];
	    
      break;

    case 667: // iPhone 4.7in
      artworkFrame = CGRectMake(30, 230, 320, 320);
      _artworkImageView = [[UIImageView alloc] initWithFrame:artworkFrame];
      [self addSubview:_artworkImageView];
	    
      break;

    case 568: // iPhone 4in
      artworkFrame = CGRectMake(40, 210, 240, 240);
      _artworkImageView = [[UIImageView alloc] initWithFrame:artworkFrame];
      [self addSubview:_artworkImageView];  
	
      break;
    default: // iPad
      artworkFrame = CGRectMake(40, 210, 240, 240);
      _artworkImageView = [[UIImageView alloc] initWithFrame:artworkFrame];
      [self addSubview:_artworkImageView];	    
      break;
  }
  if (mediaController.isPlaying && mediaController.hasTrack) {
    [self performSelector:@selector(updateAlbumArtInfo:)];
  }
}

-(void)updateAlbumArtInfo:(id)completeAlbumInfoUpdate {
  MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
    __block UIImage *artwork = [UIImage imageWithData:[(__bridge NSDictionary *)information objectForKey:(NSData *)(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]] ? [UIImage imageWithData:[(__bridge NSDictionary *)information objectForKey:(NSData *)(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]] : [[UIImage alloc] initWithContentsOfFile:noAlbumImagePath];
    _artworkImageView.image = artwork;
  });
}

-(void)dealloc {
  [_mediaController release];
  [_artworkImageView release];
  [super dealloc];
}
@end

// LOAD PREFERENCES
HBPreferences *preferences;
extern NSString *const HBPreferencesDidChangeNotification;
static void loadPrefs() {
  
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.ikilledappl3.meteora.plist"];
  
  if(prefs) {  
    kCustomText = ( [prefs objectForKey:@"kCustomText"] ? [prefs objectForKey:@"kCustomText"] : kCustomText );
    [kCustomText retain];
  }
}  
 
%ctor {
  preferences = [[HBPreferences alloc] initWithIdentifier:@"com.ikilledappl3.meteora"];

  [preferences registerBool:&kEnabled default:NO forKey:@"kEnabled"];
  [preferences registerBool:&kDoubleTap default:NO forKey:@"kDoubleTap"];
  [preferences registerBool:&kRemoveChevron default:NO forKey:@"kRemoveChevron"];
  [preferences registerBool:&kRemoveMediaPlayerBlur default:NO forKey:@"kRemoveMediaPlayerBlur"];
  [preferences registerBool:&kCustomSliderText default:NO forKey:@"kCustomSliderText"];

  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.ikilledappl3.meteora-prefsreload"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
}
