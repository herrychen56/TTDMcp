#import "BCTabBar.h"
#import "BCTab.h"
#define kTabMargin 2.0

#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width

@interface BCTabBar ()
@property (nonatomic, retain) UIImage *backgroundImage;

- (void)positionArrowAnimated:(BOOL)animated;
@end

@implementation BCTabBar
@synthesize tabs, selectedTab, backgroundImage, arrow, delegate;

- (id)initWithFrame:(CGRect)aFrame {

	if (self = [super initWithFrame:aFrame]) {
		self.backgroundImage = [UIImage imageNamed:@"tab_bg.png"];
		self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
		CGRect r = self.arrow.frame;
		r.origin.y = - (r.size.height - 2);
		self.arrow.frame = r;
		[self addSubview:self.arrow];
//        self.highlightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_highted.png"]];
//		CGRect rect = self.highlightView.frame;
//		rect.origin.y = 0;
//        rect.origin.x = -100;
//        rect.size.height = aFrame.size.height - rect.origin.y;
//		self.highlightView.frame = rect;
//		[self addSubview:self.highlightView];
		self.userInteractionEnabled = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | 
		                        UIViewAutoresizingFlexibleTopMargin;
						 
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIGraphicsBeginImageContext(CGSizeMake(Screen_width, self.backgroundImage.size.height));
    [self.backgroundImage drawInRect:CGRectMake(0, 0, Screen_width, self.backgroundImage.size.height)];
    self.backgroundImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
	[self.backgroundImage drawAtPoint:CGPointMake(0, 0)];
	[[UIColor blackColor] set];
	CGContextFillRect(context, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2));
}

- (void)setTabs:(NSArray *)array {
    if (tabs != array) {
        for (BCTab *tab in tabs) {
            [tab removeFromSuperview];
        }

        tabs = array;        
        
        for (BCTab *tab in tabs) {
            tab.userInteractionEnabled = YES;
            [tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchDown];
        }
        [self setNeedsLayout];

    }
}

- (void)setSelectedTab:(BCTab *)aTab animated:(BOOL)animated {
	if (aTab != selectedTab) {
		selectedTab = aTab;
		selectedTab.selected = YES;
		
		for (BCTab *tab in tabs) {
			if (tab == aTab) continue;
			
			tab.selected = NO;
		}
	}
	
	[self positionArrowAnimated:animated];
    [self positionHighlightAnimated:NO];
}

- (void)positionHighlightAnimated:(BOOL)animated {
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
	}
	CGRect rect = self.highlightView.frame;
	rect.origin.x = self.selectedTab.frame.origin.x + ((self.selectedTab.frame.size.width / 2) - (rect.size.width / 2));
	self.highlightView.frame = rect;
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)setSelectedTab:(BCTab *)aTab {
	[self setSelectedTab:aTab animated:YES];
}

- (void)tabSelected:(BCTab *)sender {
	[self.delegate tabBar:self didSelectTabAtIndex:[self.tabs indexOfObject:sender]];
}

- (void)positionArrowAnimated:(BOOL)animated {
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
	}
	CGRect f = self.arrow.frame;
	f.origin.x = self.selectedTab.frame.origin.x + ((self.selectedTab.frame.size.width / 2) - (f.size.width / 2));
	self.arrow.frame = f;
    	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = self.bounds;
	f.size.width /= self.tabs.count;
	f.size.width -= (kTabMargin * (self.tabs.count + 1)) / self.tabs.count;
	for (BCTab *tab in self.tabs) {
		f.origin.x += kTabMargin;
		tab.frame = CGRectMake(floorf(f.origin.x), f.origin.y, floorf(f.size.width), f.size.height);
		f.origin.x += f.size.width;
		[self addSubview:tab];
	}
	
	[self positionArrowAnimated:NO];
}

- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}


@end
