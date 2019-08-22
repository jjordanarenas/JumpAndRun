#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCAnimation.h"

typedef enum {
    yetiStill = 0,
    yetiRunning,
    yetiJumping,
    yetiFalling
} YetiStates;
@interface Yeti : CCNode {
    
}

// Property for the state
@property (readwrite, nonatomic) YetiStates *yetiState;
// Property for the sprite
@property (readwrite, nonatomic) CCSprite *yetiSprite;
// Property for still action
@property (readonly, nonatomic) CCActionAnimate *actionStill;
// Property for run action
@property (readonly, nonatomic) CCActionRepeatForever *actionRun;
// Property for jump action
@property (readonly, nonatomic) CCActionAnimate *actionJump;

// Declare init method
- (Yeti *) initYeti;
// Declare custom method to set the position
- (void) setPosition:(CGPoint)position;

@end
