#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	NSScrollView *_scrollview;
	NSView *_glview;
	NSString *folder;
	NSArray *files;
	int file;
	NSSize clip, full;
	bool resizing;
}
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSScrollView *scrollview;
@property (assign) IBOutlet NSView *glview;

@end
