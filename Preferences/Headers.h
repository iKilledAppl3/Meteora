#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>

static NSString *meteoraImagePath = @"/Library/Application Support/Meteora/Durango.png";

@interface HBListController : PSListController
@end 

@interface MeteoraListController: HBListController
- (void)_returnKeyPressed:(id)notification;
@end
