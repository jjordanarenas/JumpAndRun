#import "Platform.h"

@implementation Platform

// Implement init method
- (Platform *) initPlatformWithSize:(PlatformSize)size {
    self = [super init];
    if (!self) return(nil);
    
    NSString *fileName;
    
    switch (size) {
        case Platform_M_Up:
        case Platform_M_Down:
            // Assign image
            fileName = @"JumpAndRunAtlas/platform1.png";
            break;
        case Platform_L_Up:
        case Platform_L_Down:
            // Assign image
            fileName = @"JumpAndRunAtlas/platform2.png";
            break;
        case Platform_XL_Up:
        case Platform_XL_Down:
            // Assign image
            fileName = @"JumpAndRunAtlas/platform3.png";
            break;
        default:
            break;
    }
    
    // Set floor size
    _platformSize = size;
    
    // Initialize sprite with the file name
    _platformSprite = [[CCSprite alloc] initWithImageNamed:fileName];
    
    // Set floor's anchor point
    self.anchorPoint = CGPointMake(0.0, 0.0);
    _platformSprite.anchorPoint = CGPointMake(0.0, 0.0);
    
    // Set content size
    self.contentSize = CGSizeMake(_platformSprite.contentSize.width, _platformSprite.contentSize.height);
    
    return self;
}

- (void) setPosition:(CGPoint)position {
    _platformSprite.position = position;
    [super setPosition:position];
}

@end
