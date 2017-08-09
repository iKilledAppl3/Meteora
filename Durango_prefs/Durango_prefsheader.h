//libcephei prefs headers we need 
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBTintedTableCell.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBTwitterCell.h>
#import <CepheiPrefs/HBImageTableCell.h>
#import <CepheiPrefs/HBPackageNameHeaderCell.h>
//regular ones we need 
#import <UIKit/UIKit.h>

//image path
static NSString *durangoImagePath = @"/Library/Application Support/Durango/Durango.png";

//preferences interface 

@interface DurangoListController: HBListController {
}
- (void)_returnKeyPressed:(id)notification;
@end
