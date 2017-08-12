#import "Headers.h"

@implementation MeteoraListController
+ (NSString *)hb_specifierPlist {
  return @"Meteora";
}

-(void)loadView {
  [super loadView];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(shareTapped)];
}

+ (UIColor *)hb_tintColor {
  return [UIColor colorWithRed:147.0/255.0 green:112.0/255.0 blue:219.0/255.0 alpha:1.0];
}

- (void)shareTapped {
  NSString *shareText = @"Slide to unlock isn't dead! I just brought it back with #Meteora by @iKilledAppl3!";
  UIImage *image = [UIImage imageWithContentsOfFile:meteoraImagePath];
  NSArray *itemsToShare = @[image, shareText];
  if ([UIActivityViewController alloc]) {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [(UINavigationController *)[super navigationController] presentViewController:activityViewController animated:YES completion:NULL];
  }
}

- (void)_returnKeyPressed:(id)notification {
  [self.view endEditing:YES];
  [self performSelector:@selector(keyBoardRespring) withObject:nil afterDelay:2.0];
	 
}

-(void)keyBoardRespring {
UIAlertController *alertController =  [UIAlertController
  alertControllerWithTitle:@"Meteora"
  message:@"Respring to apply changes."
  preferredStyle:UIAlertControllerStyleAlert];
	
  UIAlertAction* ok = [UIAlertAction
  actionWithTitle:@"OK"
  style:UIAlertActionStyleCancel
  handler:nil];
  
  [alertController addAction:ok];
  [self presentViewController:alertController animated:YES completion:nil];
}


-(void)respring {
  system ("killall -9 SpringBoard");
}

@end

// vim:ft=objc