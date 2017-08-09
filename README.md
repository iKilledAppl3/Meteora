# Meteora
Bring back the iOS 7 - 9 Lockscreen to iOS 10!
This tweak is named after the Meteora album by Linkin Park 
This tweak is also in honor of Chester Bennington.
I was originally going to charge $1.50 to $2.50 (with a free trial) because of how many things I had to re-write and add that Apple had broken on purpose!
This tweak isn't compatible with most iOS 10 lockscreen tweaks due to them modifying the SBDashBoardViewController.
I wish the community would understand this stuff isn't easy for developers to do!
The code is a bit messy! It works! most of the way!

# How to build?
- Simple! Use theos and libcephei! that's it!
- Need help contact me on Twitter @iKilledAppl3

# Things to Do!
- Touch ID (Sticktron has worked with me on this and has come to find out that Apple no longer accepts mesa (biometric) unlocking requests with the "old" lockscreeen) (maybe someone can make a work around? IDK though).
- iOS 9 styled Notifications (or notifications in general working) on the Lockscreen.
- Prevent the Lockscreen from relocking itself when you tap on a notification in the NC, tap to open the Music application on the Lockscreen (from the Control Center).
- Somehow add support for tweaks that modify SBDashBoardViewController since I disabled it with this tweak to make it more authentic to the user! (be that as bringing back all the old lockscren methods that Apple still has in iOS 10).

# Why doesn't certain things work?
- Simple the methods I use are from iOS 9 and although Apple has them in iOS 10 they're subclassed or rather the SBDashBoardViewController (and other SBDashBoard components) are the ones calling the shots here. 
- IOS 10's lockscreen mechanism is a bit weird it uses the dashboard as the main lockscreen view but still uses some old iOS 9 lockscreen components by subclassing them
- You can basically get the old lockscreen back by disabling the dashboard but by doing so MESA (Touch ID) authentication fails and gets revoked on the "old" lockscreen (thanks to Stricktron for figuring this out)

# Please! Please! Please! give credit to me if you make anything cool out of this mess!
I spent three weeks or more on this and I'm cutting losses! I wanted to make money off of this because I've been struggling to find a job lately (sorry for the sap story).
This was fun! if you can fix things let me know fork this project and make a pull request!

# Licensed under the MIT License Liscese!
Respect all the license states so on and so forth!
Give credit where credit is due!
If you re-distrubute the package you IT MUST CONTAIN ALL ORIGINAL ASSETS! AND MUST BE FREE!

# Donate!
What's the best thing you can do to help me out?
Simple! DONATE!
Donating helps me continue making tweaks and showing me that people actually care donate as much as you can!
Donate here: http://is.gd/donate2ToxicAppl3Inc

# Screenshots
Well here are some screenshots if you care! :P
(https://github.com/iKilledAppl3/Meteora/blob/master/Screenshot.jpg?raw=true)
(https://github.com/iKilledAppl3/Meteora/blob/master/Screenshot2.jpg?raw=true)

# Video
Watch it here: https://twitter.com/iKilledAppl3/status/892202494566203393