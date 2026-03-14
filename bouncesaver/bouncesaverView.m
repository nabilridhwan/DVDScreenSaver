//
//  bouncesaverView.m
//  bouncesaver
//

#import "bouncesaverView.h"

@implementation bouncesaverView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        const CGFloat fps = 60.0;
        [self setAnimationTimeInterval:1.0 / fps];

        // Scale speed to current view width so traversal time feels consistent.
        CGFloat viewWidth = NSWidth(frame);
        if (viewWidth <= 0) {
            viewWidth = 1920.0; // safe fallback
        }
        const CGFloat speed = viewWidth / (10.0 * fps);

        self.dvdWidth = 512.0 / 2.0;
        self.dvdHeight = 256.0 / 2.0;

        CGFloat maxX = MAX(0.0, NSWidth(frame) - self.dvdWidth);
        CGFloat maxY = MAX(0.0, NSHeight(frame) - self.dvdHeight);

        self.x = maxX / 2.0;
        self.y = maxY / 2.0;
        self.dirtyRect = NSMakeRect(self.x, self.y, self.dvdWidth, self.dvdHeight);

        self.xSpeed = speed * ((arc4random() % 2 == 0) ? 1.0 : -1.0);
        self.ySpeed = speed * ((arc4random() % 2 == 0) ? 1.0 : -1.0);

        NSString *dvdPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"dvdvideologo" ofType:@"png"];
        self.dvdLogo = [[NSImage alloc] initWithContentsOfFile:dvdPath];

        [self hitWall];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rectParam
{
    [[NSColor blackColor] setFill];
    NSRectFill(rectParam);

    NSRect logoRect = NSMakeRect(self.x, self.y, self.dvdWidth, self.dvdHeight);
    [self.dvdLogo drawInRect:logoRect];
}

- (void)animateOneFrame
{
    NSRect oldRect = NSMakeRect(self.x, self.y, self.dvdWidth, self.dvdHeight);

    self.x += self.xSpeed;
    self.y += self.ySpeed;

    CGFloat maxX = NSWidth(self.bounds) - self.dvdWidth;
    CGFloat maxY = NSHeight(self.bounds) - self.dvdHeight;

    BOOL hit = NO;

    if (self.x <= 0.0) {
        self.x = 0.0;
        self.xSpeed = fabs(self.xSpeed);
        hit = YES;
    } else if (self.x >= maxX) {
        self.x = maxX;
        self.xSpeed = -fabs(self.xSpeed);
        hit = YES;
    }

    if (self.y <= 0.0) {
        self.y = 0.0;
        self.ySpeed = fabs(self.ySpeed);
        hit = YES;
    } else if (self.y >= maxY) {
        self.y = maxY;
        self.ySpeed = -fabs(self.ySpeed);
        hit = YES;
    }

    if (hit) {
        [self hitWall];
    }

    NSRect newRect = NSMakeRect(self.x, self.y, self.dvdWidth, self.dvdHeight);
    self.dirtyRect = NSUnionRect(oldRect, newRect);
    [self setNeedsDisplayInRect:self.dirtyRect];
}

- (void)hitWall
{
    NSArray *colors = @[
        [NSColor redColor],
        [NSColor blueColor],
        [NSColor yellowColor],
        [NSColor cyanColor],
        [NSColor orangeColor],
        [NSColor magentaColor],
        [NSColor greenColor]
    ];

    self.dvdColor = colors[arc4random() % [colors count]];

    [self.dvdLogo lockFocus];
    [self.dvdColor set];
    NSRect imageRect = { NSZeroPoint, [self.dvdLogo size] };
    NSRectFillUsingOperation(imageRect, NSCompositingOperationSourceAtop);
    [self.dvdLogo unlockFocus];
}

@end
