#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    Platform_M_Up = 0,
    Platform_L_Up,
    Platform_XL_Up,
    Platform_M_Down,
    Platform_L_Down,
    Platform_XL_Down
} PlatformSize;
@interface Platform : CCNode {
    
}

// Property for platform size
@property (readwrite, nonatomic) PlatformSize *platformSize;
// Property for the sprite
@property (readwrite, nonatomic) CCSprite *platformSprite;

// Declare init method
- (Platform *) initPlatformWithSize:(PlatformSize)size;
// Declare custom method to set the position
- (void) setPosition:(CGPoint)position;

@end
