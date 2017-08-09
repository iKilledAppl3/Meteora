#import "Durango_prefsheader.h"

@implementation DurangoListController
+ (NSString *)hb_specifierPlist {
    return @"Durango";
    
}

//share button
-(void)loadView {
    [super loadView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(shareTapped)];
}

//tint color to use for toggles and buttons 
+ (UIColor *)hb_tintColor {
    return [UIColor colorWithRed:147.0/255.0 green:112.0/255.0 blue:219.0/255.0 alpha:1.0];
}

//share button action 
- (void)shareTapped {
  
    NSString *shareText = @"Slide to unlock isn't dead! I just brought it back with #Meteora by @iKilledAppl3! Download for $1.50";
   UIImage *image = [UIImage imageWithContentsOfFile:durangoImagePath];
   NSArray *itemsToShare = @[image, shareText];
    if ([UIActivityViewController alloc]) {
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        [(UINavigationController *)[super navigationController] presentViewController:activityViewController animated:YES completion:NULL];
    }else {
        //awesomeness
    }
}

- (void)_returnKeyPressed:(id)notification {
	//dismiss the keyboard
	 [self.view endEditing:YES];
	 [self performSelector:@selector(keyBoardRespring) withObject:nil afterDelay:2.0];
	 
}


-(void)keyBoardRespring {
UIAlertController *alertController =  [UIAlertController
	 alertControllerWithTitle:@"Meteora"
		 message:@"Your device is about to respring to apply the text!"
                                    preferredStyle:UIAlertControllerStyleAlert];
        
		UIAlertAction* ok = [UIAlertAction
				   actionWithTitle:@"OK"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
		 [self performSelector:@selector(respring) withObject:nil afterDelay:2.0];
                                     
		   }];
		     [alertController addAction:ok];
		     [self presentViewController:alertController animated:YES completion:nil];
}


-(void)respring {
    system ("killall SpringBoard");
}

@end

// vim:ft=objc
