#import "AppDelegate.h"

@implementation AppDelegate

NSString* const SCRIPT = @"property m_status : \"\"\ntell application \"Spotify\"\nset m_track to current track\nset m_duration to duration of m_track\nset m_status to (name of m_track as string) & \" - \" & (artist of m_track as string) & \" [\" & (my to_time(player position div 1)) & \"/\" & (my to_time(m_duration) as string) & \"]\"\nend tell\nreturn m_status\non to_time(m_num)\nset num to m_num\nset h to 0\nset m to 0\nset s to 0\nset ret to \"\"\nrepeat while num > 3600\nset num to num - 3600\nset h to h + 1\nend repeat\nrepeat while num > 60\nset num to num - 60\nset m to m + 1\nend repeat\nset s to num\nif h > 0 then\nset ret to (ret & h as string) & \":\"\nend if\nset ret to (ret & m as string) & \":\"\nif length of (s as string) < 2 then\nset ret to (ret & \"0\" & s as string)\nelse\nset ret to (ret & s as string)\nend if\nreturn ret\nend to_time";

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    status_item = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength ] retain];
    [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateStatus) userInfo:nil repeats:YES];
}

- (void)updateStatus {
    NSDictionary *error = nil;
    NSAppleScript *script = [[[NSAppleScript alloc] initWithSource:SCRIPT] autorelease];
    NSAppleEventDescriptor *result = [script executeAndReturnError:&error];

    NSString* current_track = [result stringValue];
    
    [status_item setMenu:status_menu];
    [status_item setHighlightMode:YES];

    NSMutableAttributedString* attr_str;

    if([current_track length] <= 0) {
        attr_str = [[NSMutableAttributedString alloc] initWithString:@"Could not get track [0:00/0:00]"];
        [attr_str setAttributes:@{NSFontAttributeName: [NSFont systemFontOfSize:12]} range:NSMakeRange(0,current_track.length)];
    } else {
        attr_str = [[NSMutableAttributedString alloc] initWithString:current_track];
        [attr_str setAttributes:@{NSFontAttributeName: [NSFont systemFontOfSize:12]} range:NSMakeRange(0,current_track.length)];
    }

    
    [status_item setAttributedTitle:attr_str];
}

-(void)awakeFromNib {
    [self updateStatus];
}
    
@end
