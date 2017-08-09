//Durango is the codename for iOS 4.3 and the code name of this slide to unlock tweak :P
//Apple intentionally broke the "old" lockscreen so I had to re-write methods that Apple broke!
//It's been a challenge but hey i learned something new!
//Created by iKilledAppl3 (J.K Hayslip)
//This tweak brings back to old iOS 9 lockscreen back to iOS 10! by disabling the SBDashBoardViewController! (Apple's new lockscreen)!
//Tweaks that modify the dashboard on iOS 10 aren't supported with Meteora because of this!
//I wanted to give an authentic exprience to the user as much as I could!
//The tweak would've been $1.50 because of all the things i had to re-write and add back I wish the community would understand this!
//I'm currently jobless and need the money so here's the compromise of me cutting losses my loss is your gain!
//Donate to me here: http://www.is.gd/donate2ToxicAppl3Inc without this I can't continue going on!
//R.I.P. CHESTER BENNINGTON!

//headers we need! 
//This header file contains everything we need!
#import "Durango+PrivateInterfaces.h"

//see if tweak is enabled!
static BOOL kEnabled;
static BOOL kDoubleTap;
static BOOL kRemoveChevron;
static BOOL kRemoveMediaPlayerBlur;
static BOOL kCustomSliderText;
static NSString *kCustomText;

//touch id detection
//thanks to lockglyphx 
#define kTouchIDFingerUp 	0
#define kTouchIDFingerDown 	1
#define kTouchIDFingerHeld 	2
#define kTouchIDMatched 	3
#define kTouchIDSuccess 	4
#define kTouchIDDisabled 	6
#define kTouchIDNotMatched 10

//No album art image path
static NSString *noAlbumImagePath = @"/Library/Application Support/Durango/noalbumart.png";

//Extra stuff we need to call in the tweak
UITapGestureRecognizer *lockTapGesture; //Lockscreen two touch gesture
UIView *mediaControls; //media controls view
UIView *artworkView; //artwork view
UIBlurEffect *mediaEffect; //blur effect of the media player
UIVisualEffectView *mediaVisualEffect; //blur view of the medis player
UIImageView* _artworkImageView; //artwork image view
CGRect artworkFrame; //artwork frame!
SBMediaController *mediaController = [%c(SBMediaController) sharedInstance]; //SpringBoard Media controller!
SBUILegibilityLabel *timeLabel; //Time label on the lockscreen!

//Adjust the volume :P
//I will never understand why you have to add back a function that was already there by the OS but whatever.... It works :P
%hook VolumeControl
-(void)increaseVolume {
	//Lockscreen manager tells detects things on the lockscreen such as being locked!
	SBLockScreenManager *lsManager = [%c(SBLockScreenManager) sharedInstance];
	if (kEnabled == YES && mediaController.isPlaying && [lsManager isUILocked]) {
		%orig;
		[[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] + 0.0];
		
	}
	
	else {
		%orig;
	}
}

-(void)decreaseVolume {
	SBLockScreenManager *lsManager = [%c(SBLockScreenManager) sharedInstance];
	if (kEnabled == YES && mediaController.isPlaying && [lsManager isUILocked]) {
		%orig;
		[[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] - 0.0];
	}
	
	else {
		%orig;
	}
}
%end

//hook the slide to unlock text and make it the right size
//Apple broke the old lockscreen on purpose!	
%hook _UIGlintyStringView 
-(void)layoutSubviews {
	if (kEnabled == YES && ![self.text isEqualToString:@"slide to power off"]) {
	    self.font = [UIFont fontWithName:@"HelveticaNeue" size:23.0];	
                  self.clipsToBounds = YES;
	}
	
	else if (kEnabled == YES && ![self.text isEqualToString:@"slide to power off"] && kCustomSliderText == YES) {
		self.text = kCustomText;
		    self.font = [UIFont fontWithName:@"HelveticaNeue" size:23.0];	
		    self.clipsToBounds = YES;
	}
	
	else {
		%orig;
	}
	

}
%end 

//Fix the wonky camera icon since apple broke it too!	
%hook SBSlideUpAppGrabberView
-(void)layoutSubviews {
          if (kEnabled == YES) {
	     %orig;
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
	
	else {
		%orig;
	}
	
}	
%end

//Try to disable the show passcode button
%hook SBHomeButtonShowPasscodeRecognizer
-(void)setDelegate:(id)arg1 {
	if (kEnabled == YES) {
		  
		
	}
	
	else {
		%orig;
	}
	
}	
%end

//Try to disable the show passcode button
%hook SBHomeButtonShowPasscodeRecognizerDelegate
-(void)homeButtonShowPasscodeRecognizerRequestsPasscodeUIToBeShown:(id)arg1 {
	if (kEnabled == YES) {
		
	}
	
	else {
		%orig;
	}
	
}

-(void)homeButtonShowPasscodeRecognizerDidFailToRecognize:(id)arg1 {
	if (kEnabled == YES) {
		
		
	}
	
	else {
		%orig;
	}
}
%end

//Try to get Touch ID working
//I found out from Stricktron that Apple disables mesa authentication on the lockscreen	
%hook SBLockScreenManager
-(void)setBiometricAutoUnlockingDisabled:(BOOL)arg1 forReason:(id)arg2 {
	%orig;
	arg1 = NO;
}
-(void)homeButtonShowPasscodeRecognizerRequestsPasscodeUIToBeShown:(id)arg1 {
	if (kEnabled == YES) {
		
	}
	
	else {
		%orig;
	}
	
}

-(void)homeButtonShowPasscodeRecognizerDidFailToRecognize:(id)arg1 {
	if (kEnabled == YES) {
		
		
	}
	
	else {
		%orig;
	}
}

-(void)_setHomeButtonShowPasscodeRecognizer:(id)arg1 {
	if (kEnabled == YES) {
		
		
	}
	
	else {
		%orig;
	}
}
%end

//Show slide to unlock text immediately!	
%hook SBLockScreenView 
-(void)setSlideToUnlockHidden:(BOOL)arg1 forRequester:(id)arg2 {
	if (kEnabled == YES) {
		NO;
		
	}
	
	else {
		%orig;
	}
	
}

- (void)setSlideToUnlockBlurHidden:(BOOL)arg1 forRequester:(id)arg2 {
	if (kEnabled == YES) {
	 NO;
		
	}
	
	else {
		%orig;
	}
	
}

//Layout the views of the lockscreen!
//add back all the views that Apple removed! 
-(void)layoutSubviews {
	if (kEnabled == YES) {
		%orig;
		//Add back the grabbers to the lockscreen!
		SBUIChevronView *topGrabberView = [self valueForKey:@"_topGrabberView"];
		topGrabberView.alpha = 1;
		topGrabberView.hidden = NO;
		topGrabberView.userInteractionEnabled = YES;
		[self addSubview:topGrabberView];
		[self sendSubviewToBack:topGrabberView];

		if (kRemoveChevron == YES) {
     		topGrabberView.hidden = YES;
		}
		
		else if (mediaController.isPlaying) {
			topGrabberView.hidden = YES;
		}
		
		else if (mediaController.isPlaying && kRemoveChevron == YES) {
			topGrabberView.hidden = YES;
		}
		
		else {
			topGrabberView.hidden = NO;
		}
		
		SBUIChevronView *bottomGrabberView = [self valueForKey:@"_bottomGrabberView"];
		bottomGrabberView.alpha = 1;
		bottomGrabberView.hidden = NO;
		[self addSubview:bottomGrabberView];
		[self sendSubviewToBack:bottomGrabberView];

		if (kRemoveChevron == YES) {
   		  bottomGrabberView.hidden = YES;
		}
		
		//Fix the slide to unlock vibrancy bug 
		
		SBWallpaperEffectView *slideToUnlockBackgroundView = [self valueForKey:@"_slideToUnlockBackgroundView"];
		slideToUnlockBackgroundView.alpha = 0;
		
		//Add back the notification system gesture to present the NC
		//Apple really didn't want nobody to get any of this working with a simple BOOL statement did they?
		UIScreenEdgePanGestureRecognizer *ncSwipeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(ncSwipeGestureAction)];
		ncSwipeGesture.edges = UIRectEdgeTop;
		//Thanks to Nougat :) from  Shade-Zepheri 
		[[%c(FBSystemGestureManager) sharedInstance] addGestureRecognizer:ncSwipeGesture toDisplay:[%c(FBDisplayManager) mainDisplay]];
		
		//Add back the notification system gesture to present the CC
		//Apple really didn't want nobody to get any of this working with a simple BOOL statement did they?
		UIScreenEdgePanGestureRecognizer *ccPanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(ccPanGestureAction)];
		ccPanGesture.edges = UIRectEdgeBottom;
		[self addGestureRecognizer:ccPanGesture];
		
		//Two tap touch to lock the device!
		if (kDoubleTap == YES) {
		lockTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapLockAction)];
		lockTapGesture.numberOfTouchesRequired = 2;
		[self addGestureRecognizer:lockTapGesture];
		
	}
	
		
	}
	
	
	else {
		%orig;
	}
}

//New methods 
//double tap to lock
%new -(void)doubleTapLockAction {
	[((SpringBoard *)[%c(SpringBoard) sharedApplication]) _simulateLockButtonPress];
			  
}

//present the notification center
%new -(void)ncSwipeGestureAction {
	[[%c(SBNotificationCenterController) sharedInstance] presentAnimated:YES];
}

//present the control center
%new -(void)ccPanGestureAction {
	[[%c(SBControlCenterController) sharedInstance] presentAnimated:YES];
}



//Add back the media controls
//again Apple broke things and this is a pain Why?
-(void)_layoutMediaControlsView { 
	  if (kEnabled == YES && mediaController.isPlaying) {
		  UIView *_foregroundLockView = MSHookIvar<UIView*>(self, "_foregroundLockView");
		  for (UIView* sub in _foregroundLockView.subviews) {
			
			if ([sub class] == NSClassFromString(@"SkittyBlockLSMediaView")) {
      				return;
    			}
		}
		
		 int deviceHeight = [UIScreen mainScreen].bounds.size.height;
    
    switch (deviceHeight) {
            
            //iPhone 5.5 inch
        case 736:
		  
		mediaControls = [[objc_getClass("SkittyBlockLSMediaView") alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-20,  200)];
	[_foregroundLockView addSubview:mediaControls];
		mediaControls.userInteractionEnabled = YES;
		
		    break;
			
			  case 667:  //iPhone 4.7 inch
			  
			  mediaControls = [[objc_getClass("SkittyBlockLSMediaView") alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-20,  200)];
			
			  [_foregroundLockView addSubview:mediaControls];
			mediaControls.userInteractionEnabled = YES;
		
		    break;
			
		       case 568: //iPhone 4 inch
			  	  
			  mediaControls = [[objc_getClass("SkittyBlockLSMediaView") alloc] initWithFrame:CGRectMake(5.5, 10, 300, 200)];
			  [_foregroundLockView addSubview:mediaControls];
			  mediaControls.userInteractionEnabled = YES;
		
		break;
		   default: //use 4inch code 
			     	  
			  mediaControls = [[objc_getClass("SkittyBlockLSMediaView") alloc] initWithFrame:CGRectMake(5.5, 10, 300, 200)];
			  [_foregroundLockView addSubview:mediaControls];
			  mediaControls.userInteractionEnabled = YES;
		
		break;
		
		 }
		         if (kRemoveMediaPlayerBlur == NO) {
		             mediaEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			mediaVisualEffect = [[UIVisualEffectView alloc] initWithEffect:mediaEffect];
			mediaVisualEffect.frame = [[UIScreen mainScreen] bounds];
			[self addSubview:mediaVisualEffect];
			[self sendSubviewToBack:mediaVisualEffect];
			
			}
			
			else if (kRemoveMediaPlayerBlur == YES) {
				mediaVisualEffect = nil;
			}
	  }
	  
  }
  
  //layout the media controls if media is playing otherwise remove them from the view.
  -(void)setMediaControlsView:(id)arg1 {
	  if (kEnabled == YES && mediaController.isPlaying) {
		  [self _layoutMediaControlsView];
	  }
	  
	  else if (kEnabled == YES && mediaController.isPaused && kRemoveMediaPlayerBlur == NO) {
	                 [mediaControls removeFromSuperview];
		   [mediaVisualEffect removeFromSuperview];
	  }
	  
	  else if (kEnabled == YES && mediaController.isPaused && kRemoveMediaPlayerBlur == TRUE) {
	                 [mediaControls removeFromSuperview];
	   }
	  
	  else {
		  %orig;
	  }
  }
  
  -(void)dealloc {
	  %orig;
  }
  
 %end

//Try to get Touch ID to work
//Again Apple revokes Mesa unlcoking on the old lockscreen Why?
%hook SBUIPasscodeLockViewBase
-(void)setBiometricAuthenticationAllowed:(BOOL)arg1 {
	if (kEnabled == YES) {
		%orig;
		arg1 = TRUE;
	}
	
	else {
		%orig;
	}
}

-(BOOL)isBiometricAuthenticationAllowed {
	if (kEnabled == YES) {
		return %orig;
		return TRUE;
	}
	
	else {
		return %orig;
	}
}
%end

//Hook the time label to hide and unhide if media isn't playing!	
%hook SBFLockScreenDateView 
-(void)layoutSubviews {
	  if (kEnabled == YES && mediaController.isPlaying) {
	timeLabel = [self valueForKey:@"_timeLabel"];
	timeLabel.hidden = YES;
	}
	
	else if (kEnabled == YES && mediaController.isPaused) {
		%orig;
		timeLabel = [self valueForKey:@"_timeLabel"];
		timeLabel.hidden = NO;
		  [mediaControls removeFromSuperview];
		  [mediaVisualEffect removeFromSuperview];
	}
	
	
	else {
	  %orig;	
		
	}
}

%end	

	
//Hide the volume hud if the device is locked and music is playing on the lockscreen
//had to add this since Apple removed the ability to adjust volume
%hook SBVolumeHUDView
- (void)layoutSubviews {
	SBLockScreenManager *lsManager = [%c(SBLockScreenManager) sharedInstance];
	  if (kEnabled == YES && [lsManager isUILocked])  {
		%orig;
	    [self setHidden:YES];	
	}
	
	else {
		%orig;
	}
	
}

%end

//Try to disable the "press home to open" gesture don't undestand why this still does this since I disabled the dashboard????
%hook SBLockScreenViewControllerBase 
-(id)createHomeButtonShowPasscodeRecognizerForHomeButtonPress {
	if (kEnabled == YES) {
		return NULL;
	}
	
	else {
		return %orig;
	}
}

//Try to get Touch ID to work
//Again Apple revokes Mesa unlcoking on the old lockscreen Why?
-(void)handleBiometricEvent:(unsigned long long)arg1 {
		 %orig;
		  SBLockScreenManager *manager = [%c(SBLockScreenManager) sharedInstance];
	  if (kEnabled == YES && [manager isUILocked] && manager.bioAuthenticatedWhileMenuButtonDown && arg1 == kTouchIDSuccess) {
			   SystemSoundID soundID;
			   AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:unlockSound],&soundID);
	AudioServicesPlaySystemSound(soundID);
			   
	  }		
				
	  else if (kEnabled == YES && [manager isUILocked] && manager.bioAuthenticatedWhileMenuButtonDown && arg1 == kTouchIDNotMatched) {
					  %orig;
					 
	                 
				}
					
				 
				 else {
					 %orig;
				 }
}

%end
	
//Try to get Touch ID to work
//Again Apple revokes Mesa unlcoking on the old lockscreen Why?
%hook SBFUserAuthenticationController

-(void)_handleSuccessfulAuthentication:(id)arg1 responder:(id)arg2 {
			%orig;		
  
}

-(void)_handleFailedAuthentication:(id)arg1 error:(id)arg2 responder:(id)arg3 {
  			%orig;
   
}
%end
	
	
%hook SBLockScreenViewController 
//Try to get Touch ID to work
//Again Apple revokes Mesa unlcoking on the old lockscreen Why?
-(void)handleBiometricEvent:(unsigned long long)arg1 {
		 %orig;
		  SBLockScreenManager *manager = [%c(SBLockScreenManager) sharedInstance];
	  if (kEnabled == YES && [manager isUILocked] && manager.bioAuthenticatedWhileMenuButtonDown && arg1 == kTouchIDSuccess) {
			   SystemSoundID soundID;
			   AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:unlockSound],&soundID);
	AudioServicesPlaySystemSound(soundID);
			   
	  }		
				
	  else if (kEnabled == YES && [manager isUILocked] && manager.bioAuthenticatedWhileMenuButtonDown && arg1 == kTouchIDNotMatched) {
					  %orig;
					 
	                 
				}
					
				 
				 else {
					 %orig;
				 }
}

//Try to get Touch ID to work
//Again Apple revokes Mesa unlcoking on the old lockscreen Why?
-(void)prepareForMesaUnlockWithCompletion:(id)arg1 {
		  %orig;
	
}
//Try to get Touch ID to work
//Again Apple revokes Mesa unlcoking on the old lockscreen Why?
-(void)handleSuccessfulAuthenticationRequest:(id)arg1 {
	%orig;
}

//new method to present the media controls
%new -(void)presentMediaControls {
  [[%c(SBLockscreenView) sharedInstance] _layoutMediaControlsView];	
}

//Handle the volume events!
-(BOOL)handleVolumeUpButtonPressed { 
		return %orig;
}

-(BOOL)handleVolumeDownButtonPressed {
	           return %orig;
}

//attempt to keep the device from locking itself
-(BOOL)canUIUnlockFromSource:(int)arg1 {
	if (kEnabled == YES) {
		return YES;
	
	}
	
	else {
		return %orig;
	}
}		

//hide the date if the media controls are shown
 -(BOOL)_shouldShowDate {
	if (kEnabled == YES && mediaController.isPlaying) {
		return FALSE;
	}
	
	else {
		return %orig;
	}
}	

//show the status bar time when media is playing
-(BOOL)shouldShowLockStatusBarTime {
	if (kEnabled == YES && mediaController.isPlaying) {
		return TRUE;
	}
	
	else {
		return %orig;
	}
}	
	
//Show the "slide to unlock" text ASAP!
- (BOOL)shouldShowSlideToUnlockTextImmediately {
	if (kEnabled == YES) {
		return TRUE;
	}
	
	else {
		return %orig;
	}
}

//attempt to handle a menu button tap
-(BOOL)handleMenuButtonDoubleTap {
	if (kEnabled == YES) {
		return %orig;
	}
	
	else {
		return %orig;
	}
}

//allow use of external headsets such as the Apple Airpods/Earpods.
-(BOOL)handleHeadsetButtonPressed:(BOOL)arg1 {
	if (kEnabled == YES) {
		return %orig;
	}
	
	else {
		return %orig;
	}
}

//This is crucial!
//Apple broke this method originally! 
//Without this method the screen won't turn on after the UI has been locked and the screen times out
//I had to figure this out myself!
-(void)_handleDisplayTurnedOnWhileUILocked:(id)arg1 {
	if (kEnabled == YES &&  [self valueForKey:@"_isInScreenOffMode"]) {
		YES;
	        
		
	}
	
	else {
		%orig;
	}
}

//Try to get Touch ID to work
//Again Apple revokes Mesa unlcoking on the old lockscreen Why?
-(void)passcodeLockViewPasscodeEnteredViaMesa:(id)arg1 {
	SBLockScreenManager *manager = [%c(SBLockScreenManager) sharedInstance];
	if (kEnabled == YES && [manager isUILocked] && manager.bioAuthenticatedWhileMenuButtonDown) {
		%orig;
	}
	
	else {
		%orig;
	}
}
%end

//Here is where we disable the "new" lockscreen and bring back the "old" lockscreen
//I could've added the views to the Dashboard but it wouldn't have been the same	
%hook SBLockScreenDefaults
-(void)setUseDashBoard:(BOOL)arg1 {
    if (kEnabled == YES) {
	     NO;	
}

   else {

      %orig; //do original thing! 

}

}

-(BOOL)useDashBoard {
     if (kEnabled ==  YES) {
	return FALSE;
     }
	 
    else {
	return %orig;	
    }	 
}

-(void)_bindAndRegisterDefaults {
	if (kEnabled == YES) {
		%orig;
		[self performSelector:@selector(setUseDashBoard:)];
	}
	
	else {
		%orig;
	}
}	
%end


//Interface implementations :P
//Thanks SkittyBlock for media controls part
//Thank myself for most of the album art part
//Thanks to s1ris for Helius!	
@implementation SkittyBlockLSMediaView
-(id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self != nil) {
   _mediaController = [[objc_getClass("MPULockScreenMediaControlsViewController") alloc] init];
    _mediaController.view.frame = frame;
    [self addSubview:_mediaController.view];
   
    //notifcation for media info changing borrowed from Helius
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAlbumArtInfo:) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];		
	
  }
  return self;
}

-(void)layoutSubviews {
	
	int devicesHeight = [UIScreen mainScreen].bounds.size.height;
    
    switch (devicesHeight) {
            
            //iPhone 5.5 inch
        case 736:
			  
		artworkFrame = CGRectMake(32.5, 230, 360, 360);
			  _artworkImageView = [[UIImageView alloc] initWithFrame:artworkFrame];
			  [self addSubview:_artworkImageView];
			
			break;
			
			
			  case 667:  //iPhone 4.7 inch
			  
			  artworkFrame = CGRectMake(30, 230, 320, 320);
			  _artworkImageView = [[UIImageView alloc] initWithFrame:artworkFrame];
			  [self addSubview:_artworkImageView];
			
			break;
			
		 case 568: //iPhone 4 inch
		 artworkFrame = CGRectMake(40, 210, 240, 240);
			_artworkImageView = [[UIImageView alloc] initWithFrame:artworkFrame];
			[self addSubview:_artworkImageView];  
		
		break;
		default: //iPad
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
			//artwork thanks to Helius by s1ris https://github.com/s1ris/Helius
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		__block UIImage *artwork = [UIImage imageWithData:[(__bridge NSDictionary *)information objectForKey:(NSData *)(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]] ? [UIImage imageWithData:[(__bridge NSDictionary *)information objectForKey:(NSData *)(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]] : [[UIImage alloc] initWithContentsOfFile:noAlbumImagePath];
	
				//this part is mine :P		  
			   _artworkImageView.image = artwork;
			   
			   });
}

-(void)dealloc {
  [_mediaController release];
  [_artworkImageView release];
  [super dealloc];
}
@end

//Prefs new 
//Using libcephei instead of the old crappy way
//ws.hbang.common is your friend 

HBPreferences *preferences;
extern NSString *const HBPreferencesDidChangeNotification;
static void loadPrefs()
{
  
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.ikilledappl3.durango.plist"];
    if(prefs)
    {  

	
		kCustomText = ( [prefs objectForKey:@"kCustomText"] ? [prefs objectForKey:@"kCustomText"] : kCustomText );
		[kCustomText retain];

  }
}  

//our constructor 
%ctor {

    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.ikilledappl3.durango"];

      //check the bool value from the plist
	[preferences registerBool:&kEnabled default:NO forKey:@"kEnabled"];
	[preferences registerBool:&kDoubleTap default:NO forKey:@"kDoubleTap"];
	[preferences registerBool:&kRemoveChevron default:NO forKey:@"kRemoveChevron"];
	[preferences registerBool:&kRemoveMediaPlayerBlur default:NO forKey:@"kRemoveMediaPlayerBlur"];
	[preferences registerBool:&kCustomSliderText default:NO forKey:@"kCustomSliderText"];
	
	
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.ikilledappl3.durango-prefsreload"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	loadPrefs();
	

}
