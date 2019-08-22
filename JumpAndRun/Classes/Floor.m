#import "Floor.h"

@implementation Floor

// Implement init method
- (Floor *) initFloorWithSize:(FloorSize)size {
    self = [super init];
    if (!self) return(nil);

    NSString *fileName;
    switch (size) {
        case M:
            // Assign image
            fileName = @"JumpAndRunAtlas/floor1.png";
            break;
        case L:
            // Assign image
            fileName = @"JumpAndRunAtlas/floor2.png";
            break;
        default:
            break;
    }
    
    // Set floor size
    _floorSize = size;
    
    // Initialize sprite with the file name
    _floorSprite = [[CCSprite alloc] initWithImageNamed:fileName];
    
    // Set floor's anchor point
    self.anchorPoint = CGPointMake(0.0, 0.0);
    _floorSprite.anchorPoint = CGPointMake(0.0, 0.0);
    
    // Set content size
    self.contentSize = CGSizeMake(_floorSprite.contentSize.width, _floorSprite.contentSize.height);
    
    return self;
}

- (void) setPosition:(CGPoint)position {
    _floorSprite.position = position;
    [super setPosition:position];
}

@end
