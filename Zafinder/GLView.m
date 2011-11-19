#import "GLView.h"

@implementation GLView

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	if ([self inLiveResize]) {
		[[NSColor redColor] setFill];
		NSRectFill(dirtyRect);
	} else {
		[[NSColor greenColor] setFill];
		NSRectFill(dirtyRect);
	}
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)event {
}

- (void)keyUp:(NSEvent *)event {
	//NSLog(@"ćepka %d", event.keyCode);
	if (event.keyCode == 53)  // Escape
		[NSApp terminate:self];
	else if (event.keyCode == 115)  // Home
		[[[NSApplication sharedApplication] delegate] scrollToTop];
	else if (event.keyCode == 119)  // End
		[[[NSApplication sharedApplication] delegate] scrollToBottom];
	else if (event.keyCode == 116 || event.keyCode == 123 || event.keyCode == 126)  // PgUp ili Left ili Up
		[[[NSApplication sharedApplication] delegate] scrollPageUp];
	else if (event.keyCode == 121 || event.keyCode == 124 || event.keyCode == 125)  // PgDn ili Right ili Down
		[[[NSApplication sharedApplication] delegate] scrollPageDown];
}

@end
