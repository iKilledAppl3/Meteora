// Created by iKilledAppl3! 
//this header file is the heart and soul of the tweak next to the xm file.
//This contains all the interfaces needed for the tweak and what we need to modify it with.

#import <UIKit/UIKit.h>
//Cephei header make sure you have this in your include folder! 
#import <Cephei/HBPreferences.h>
#import <objc/runtime.h>
#import <MediaRemote/MediaRemote.h>
#import <AudioToolbox/AudioServices.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

NSString *unlockSound = [[NSBundle bundleWithPath:@"/Library/Application Support/Durango/"] pathForResource:@"unlock" ofType:@"caf"];


@interface SBDashBoardUnlockBehavior : NSObject {
	
}
@end

@interface SBLockScreenViewControllerBase : NSObject {
	
}
+(id)sharedInstance;
-(void)setAuthenticated:(BOOL)arg1;
-(BOOL)isAuthenticated;
@end

@protocol BiometricKitDelegate <NSObject>
@end

@interface BiometricKit : NSObject <BiometricKitDelegate>
+ (id)manager;
@end

@interface SBUIBiometricResource : NSObject <BiometricKitDelegate>{
	
}
+(id)sharedInstance;
-(BOOL)hasEnrolledFingers;
-(void)_reallySetAuthenticated:(BOOL)arg1 keybagState:(id)arg2;
-(void)_stopMatching;

@end


@interface SBDashBoardMesaUnlockBehavior : NSObject  {
	
}
+(id)sharedInstance;
-(void)mesaUnlockTriggerFired:(id)arg1;
-(void)handleBiometricEvent:(unsigned long long)arg1;
-(void)setMesaUnlockBehaviorDelegate:(id)arg1;
@end


@interface SBFUserAuthenticationController : NSObject {
	
}
+(id)sharedInstance;
-(void)_handleSuccessfulAuthentication:(id)arg1 responder:(id)arg2;
-(void)_handleFailedAuthentication:(id)arg1 error:(id)arg2 responder:(id)arg3;
@end


@class VolumeControl;
@interface VolumeControl : NSObject { 
}
-(void)increaseVolume;
-(void)decreaseVolume;
-(void)cancelVolumeEvent;
-(float)volumeStepUp;
-(float)volumeStepDown;
+(id)sharedVolumeControl;
@end

@interface SBBiometricEventLogger : NSObject
@end

@interface SBLockScreenViewController : UIViewController {
	BOOL _isInScreenOffMode;
}
+(id)sharedInstance;
-(BOOL)requiresPasscodeInputForUIUnlockFromSource:(int)arg1 withOptions:(id)arg2;
-(BOOL)shouldAutoUnlockForSource:(int)arg1;
-(BOOL)handleVolumeUpButtonPressed;
-(BOOL)handleVolumeDownButtonPressed;
-(void)shakeSlideToUnlockTextWithCustomText:(id)arg1;
-(void)finishUIUnlockFromSource:(int)arg1;
-(void)handleBiometricEvent:(unsigned long long)arg1;
-(void)handleSuccessfulAuthenticationRequest:(id)arg1 ;
-(void)handleFailedAuthenticationRequest:(id)arg1 error:(id)arg2;
-(void)passcodeLockViewPasscodeEnteredViaMesa:(id)arg1;
//New
-(void)presentMediaControls;
@end

@interface SBLockScreenManager : NSObject {
//SBLockScreenViewController* _lockScreenViewController;
}
+ (id)sharedInstance;
- (void)_runUnlockActionBlock:(BOOL)arg1;
- (void)unlockUIFromSource:(int)arg1 withOptions:(id)arg2;
- (void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2;
//new from SBDashBoardMesaUnlockBehavior we'll add it here to handle things if needed
- (void)_handleMesaFailure;
-(void)attemptUnlockWithMesa;
-(void)_attemptUnlockWithPasscode:(id)arg1 mesa:(BOOL)arg2 finishUIUnlock:(BOOL)arg3;
@property(readonly) BOOL isUILocked;
@property(readonly, nonatomic) SBLockScreenViewController *lockScreenViewController;
@property(readonly) BOOL bioAuthenticatedWhileMenuButtonDown;
@end

@interface SBLockScreenScrollView : UIScrollView
@end

@interface SBUILegibilityLabel : UIView {
	
}
@end

@interface SBLockScreenDateViewController : UIView 
@end

@interface FBSDisplay : NSObject
@end

@interface FBDisplayManager : NSObject
+ (instancetype)sharedInstance;
+ (FBSDisplay*)mainDisplay;
@end

@interface FBSystemGestureManager : NSObject <UIGestureRecognizerDelegate>
+ (instancetype)sharedInstance;
- (void)addGestureRecognizer:(id)arg1 toDisplay:(id)arg2;
@end

@interface SpringBoard : NSObject
- (void)_simulateLockButtonPress;
@end

@interface SBNotificationCenterController: NSObject {
	
}
+(id)sharedInstance;
-(void)presentAnimated:(BOOL)arg1;
@end

@protocol SBHomeButtonShowPasscodeRecognizerDelegate <NSObject>
@required
-(void)homeButtonShowPasscodeRecognizerDidFailToRecognize:(id)arg1;
-(void)homeButtonShowPasscodeRecognizerRequestsPasscodeUIToBeShown:(id)arg1;

@end

@class SBControlCenterController;
@class CCUIControlCenterViewController;
@interface SBControlCenterController : NSObject
+ (id)sharedInstance;
-(void)presentAnimated:(BOOL)arg1;
@end

@interface _UIGlintyStringView : UILabel {
      UILabel* _label;
}
@end

@interface SBLockScreenView : UIView {
	
}
+(id)sharedInstance;
-(void)getScrollview;
-(void)_layoutMediaControlsView;
-(void)setCustomSlideToUnlockText:(id)arg1;
@end

@interface SBWallpaperEffectView : UIView 
@end

@interface SBLockScreenPluginManager : NSObject {
	
}
+(id)sharedInstance;
-(void)_handleUIRelock;
-(void)setEnabled:(BOOL)arg1;
-(BOOL)isEnabled;
-(void)_refreshLockScreenPlugin;
@end

@interface SBLockScreenSettings : NSObject {
	
}
+(id)sharedInstance;
-(BOOL)showNowPlaying;
-(void)setShowNowPlaying:(BOOL)arg1;
@end

@interface SBLockScreenNowPlayingController : UIViewController {
}
@property (assign, nonatomic) BOOL enabled;
-(BOOL)isEnabled;
-(void)_updateNowPlayingPlugin;
+(id)sharedInstance;
-(void)setEnabled:(BOOL)arg1;
@end
 
@interface SBUIChevronView : UIView {
	
}
@end

@interface SBSlideUpAppGrabberView : UIView {
	UIImage* _grabberImage;
}
@end

@interface SBSaturatedIconView : UIImageView {
	
}
@end

@interface SBUIBannerItem : NSObject {
	
}
@end

@interface SBMediaController : NSObject {
	BOOL _lastNowPlayingAppIsPlaying;
}
-(void)setVolume:(float)arg1;
-(float)volume;
+(id)sharedInstance;
-(void)increaseVolume;
-(void)decreaseVolume;
-(BOOL)isPlaying;
-(BOOL)isPaused;
-(BOOL)hasTrack;
@end

@interface SBFLockScreenDateView : UIView {
	
}
@end

@interface MPUNowPlayingArtworkView : UIView {
	UIImage* _placeholderImage;
}
-(UIImage *)artworkImage;
+(id)sharedInstance;
@end

@interface MPULockScreenMediaControlsViewController : UIViewController
@end

@interface MPUNowPlayingController : NSObject {
	
}
+(id)sharedInstance;
-(UIImage *)currentNowPlayingArtwork;
@end

/*@interface SBLockScreenNotificationListView : UIView
@end
 

@interface iKilledAppl3NotifView : SBLockScreenNotificationListView <UITableViewDataSource, UITableViewDelegate> {
	
}
@end*/


@interface SkittyBlockLSMediaView : UIView {
  MPULockScreenMediaControlsViewController *_mediaController;
}
@end