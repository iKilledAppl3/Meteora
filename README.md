# Meteora
Meteora is a tweak to completly bring back the iOS 9 lockscreen to iOS 10+    
Currently it is a work in progress. Once this project is completed it will be released on BigBoss as a paid package.    
This tweak was mainly created by Me (iKilledAppl3) but I open sourced it hoping someone would help fix the bugs. Skitty decided to help so I could release it. Most things done in this tweak was written by me.    

# Things to Do!
- Notifications: The Notifications are only half completed and still need to be finished.
- Fix more bugs: Yeah, there's lots more bugs we know.
- Prevent the Lockscreen from relocking itself when you tap on a notification in the NC, tap to open the Music application on the Lockscreen (from the Control Center).
- Somehow add support for tweaks that modify SBDashBoardViewController since I disabled it with this tweak to make it more authentic to the user! (be that as bringing back all the old lockscren methods that Apple still has in iOS 10).

# Why doesn't certain things work?
- Simple the methods I use are from iOS 9 and although Apple has them in iOS 10 they're subclassed or rather the SBDashBoardViewController (and other SBDashBoard components) are the ones calling the shots here. 
- iOS 10's lockscreen mechanism is a bit weird it uses the dashboard as the main lockscreen view but still uses some old iOS 9 lockscreen components by subclassing them.
- You can basically get the old lockscreen back by disabling the dashboard but by doing so MESA (Touch ID) authentication fails and gets revoked on the "old" lockscreen (thanks to Sticktron for figuring this out).

# Licensed under MIT
You can use this source code in any of your projects as long as:    
We request that you give credit to the original project, although not legally required.    
Any redistributions of this work are required to be free, you can not sell any part of this source code without consent.    

# Donate!
This is a huge project that we took on because people requested it.  
If you would like to help us create more tweaks please donate any amount you would like.    
iKilledAppl3: http://is.gd/donate2ToxicAppl3Inc    
Skittyblock: http://paypal.me/Skittyblock

# Screenshots
![Screenshot](https://raw.githubusercontent.com/iKilledAppl3/Meteora/master/Screenshot1.jpg)
![Screenshot å2](https://raw.githubusercontent.com/iKilledAppl3/Meteora/master/Screenshot2.jpg)

# Video
See Meteora working on iOS 10: https://twitter.com/iKilledAppl3/status/892202494566203393
