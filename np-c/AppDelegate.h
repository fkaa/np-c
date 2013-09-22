#import <Cocoa/Cocoa.h>
#import <libspotify/api.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu* status_menu;
    NSStatusItem* status_item;
}

FOUNDATION_EXPORT NSString* const SCRIPT;

- (void) updateStatus;

@end
