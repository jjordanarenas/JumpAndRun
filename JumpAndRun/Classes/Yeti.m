#import "Yeti.h"

// Number of run animation frames
#define NUM_RUN_FRAMES 2

// Number of jump animation frames
#define NUM_JUMP_FRAMES 1

// Number of still animation frames
#define NUM_STILL_FRAMES 1

@implementation Yeti

- (Yeti *) initYeti {
    self = [super init];
    if (!self) return(nil);
    
    // Initialize state
    _yetiState = yetiStill;
    
    // Initialize sprite with the file name
    _yetiSprite = [[CCSprite alloc] initWithImageNamed:@"JumpAndRunAtlas/yeti.png"];
    
    // Set yeti's anchor point
    _yetiSprite.anchorPoint = CGPointMake(0.0, 0.0);
    self.anchorPoint = CGPointMake(0.0, 0.0);
    
    // Set content size
    _contentSize = CGSizeMake(_yetiSprite.contentSize.width, _yetiSprite.contentSize.height);

    // Initialize an array of frames
    NSMutableArray *yetiRunFrames = [NSMutableArray arrayWithCapacity: NUM_RUN_FRAMES];
    
    for (int i = 1; i <= NUM_RUN_FRAMES; i++) {
        // Create a sprite frame
        CCSpriteFrame *yetiRunFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"JumpAndRunAtlas/yeti%i.png", i]];
        
        // Add sprite frame to the array
        [yetiRunFrames addObject:yetiRunFrame];
    }
    
    // Create an animation with the array of frames
    CCAnimation *yetiRunAnimation = [CCAnimation animationWithSpriteFrames:yetiRunFrames delay:0.2];
    
    // Create an animate action with the animation
    CCActionAnimate *yetiWalkAction = [CCActionAnimate actionWithAnimation:yetiRunAnimation];
    
    // Create run action
    _actionRun = [CCActionRepeatForever actionWithAction:yetiWalkAction];
    
    // Initialize an array of frames
    NSMutableArray *yetiJumpFrames = [NSMutableArray arrayWithCapacity: NUM_JUMP_FRAMES];
    
    for (int i = 0; i < NUM_JUMP_FRAMES; i++) {
        // Create a sprite frame
        CCSpriteFrame *yetiJumpFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"JumpAndRunAtlas/yeti_jump.png"];
        
        // Add sprite frame to the array
        [yetiJumpFrames addObject:yetiJumpFrame];
    }
    
    // Create an animation with the array of frames
    CCAnimation *yetiJumpAnimation = [CCAnimation animationWithSpriteFrames:yetiJumpFrames delay:0.1f];
    
    // Create an animate action with the animation
    _actionJump = [CCActionAnimate actionWithAnimation:yetiJumpAnimation];
    
    // Initialize an array of frames
    NSMutableArray *yetiStillFrames = [NSMutableArray arrayWithCapacity: NUM_STILL_FRAMES];
    
    // Create a sprite frame
    CCSpriteFrame *yetiStillFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"JumpAndRunAtlas/yeti.png"];
    
    // Add sprite frame to the array
    [yetiStillFrames addObject:yetiStillFrame];
    
    // Create an animation with the array of frames
    CCAnimation *yetiStillAnimation = [CCAnimation animationWithSpriteFrames:yetiStillFrames delay:0.1];
    
    // Create an animate action with the animation
    _actionStill = [CCActionAnimate actionWithAnimation:yetiStillAnimation];    
    
    return self;

}

- (void) setPosition:(CGPoint)position {
    _yetiSprite.position = position;
    [super setPosition:position];
}

@end
