#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Yeti.h"

typedef enum {
    M = 0,
    L,
    SmallAbyss,
    BigAbyss
} FloorSize;
@interface Floor : CCNode {
    
}

// Property for floor size
@property (readwrite, nonatomic) FloorSize *floorSize;
// Property for the sprite
@property (readwrite, nonatomic) CCSprite *floorSprite;

// Declare init method
- (Floor *) initFloorWithSize:(FloorSize)size;
// Declare custom method to set the position
- (void) setPosition:(CGPoint)position;

@end
