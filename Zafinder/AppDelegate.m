#import "AppDelegate.h"

#define max(a, b) ((a) > (b) ? (a) : (b))
#define min(a, b) ((a) < (b) ? (a) : (b))


@implementation AppDelegate

@synthesize window = _window, scrollview = _scrollview, glview = _glview;

- (void)resize {
	// vidljivi dio i ukupna duljina
	//NSRect visible = [NSWindow contentRectForFrameRect:_window.frame styleMask:NSTitledWindowMask];
	//visible.size = [NSScrollView contentSizeForFrameSize:visible.size hasHorizontalScroller:NO hasVerticalScroller:YES borderType:NSNoBorder];
	clip = _scrollview.contentView.bounds.size;
	full = NSMakeSize(clip.width, clip.height * max(files ? files.count : 0, 1));
	// veličine viewova
	[_glview setFrameSize:clip];
	[_scrollview.documentView setFrameSize:full];
	// brzine scrollera
	[_scrollview setVerticalPageScroll:0];
	[_scrollview setVerticalLineScroll:clip.height];
	// položaj scrollera
	[_scrollview.documentView scrollPoint:NSMakePoint(0, full.height - (file + 1) * clip.height)];
}

- (void)reposition:(int)newfile {
	[_scrollview.documentView scrollPoint:NSMakePoint(0, full.height - (newfile + 1) * clip.height)];
}

- (void)scrollToTop {
	[self reposition:0];
}

- (void)scrollToBottom {
	[self reposition:(files ? (int)files.count-1 : 0)];
}

- (void)scrollPageUp {
	[self reposition:file-1];
}

- (void)scrollPageDown {
	[self reposition:file+1];
}

- (void)showFile:(int)newfile {
	file = max(0, min(newfile, (int)files.count-1));
	_window.title = [NSString stringWithFormat:@"%d/%d %@", file, files.count, [files objectAtIndex:file]];
}

- (void)showFolder:(NSString *)newfolder {
	[folder release];
	folder = [newfolder retain]; // retain?
	[files release];
	files = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:nil] retain]; // retain?
}

- (void)applicationDidFinishLaunching:(NSNotification *)n {
	//[self showFolder:[[NSBundle mainBundle] bundlePath]];
	[self showFolder:@"/Volumes/Ante/Modeli3D"];
	//[self showFolder:@"/Users/ante/Documents"];
	[self showFile:0];
	[self resize];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedWindowDidResize:) name:NSWindowDidResizeNotification object:_window];

	_scrollview.scrollsDynamically = NO;
	[[_scrollview contentView] setPostsBoundsChangedNotifications:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedViewBoundsDidChange:) name:NSViewBoundsDidChangeNotification object:[_scrollview contentView]];
}

- (void)notifiedWindowDidResize:(NSNotification *)n {
	resizing = YES;
	[self resize];
	resizing = NO;
}

- (void)notifiedViewBoundsDidChange:(NSNotification *)n {
	if (resizing || _scrollview.contentView.bounds.size.height != clip.height)  // da scroll ne preduhitri resize ili se uplete u nj
		return;
	int newfile = [files count]-1 - round(_scrollview.contentView.bounds.origin.y / clip.height);
	if (newfile != file)
		if (newfile >= 0 && newfile < (int)[files count]) {
			NSLog(@"Scrolling to %d = %.0f / %.0f / %.0f", newfile, _scrollview.contentView.bounds.origin.y, clip.height, [_scrollview.documentView frame].size.height);
			[self showFile:newfile];
		} else
			NSLog(@"INVALID OFFSET %d!", newfile);
}

- (void)dealloc {
	[files release];
	[folder release];
    [super dealloc];
}

@end