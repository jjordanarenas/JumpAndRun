#import "GameScene.h"

#define BACKGROUND_DURATION 10

// Number of floors
#define NUM_FLOORS 15

// Number of platforms
#define NUM_PLATFORMS 15

// Number of different platforms
#define kPLATFORM_TYPES 6

// Number of different floors
#define kFLOOR_TYPES 4

// Value for the blocks speed
#define kBLOCKS_SPEED 220.0f

@implementation GameScene
{
    // Declaring a private CCSprite instance variable
    Yeti *_yeti;
    
    // Declare initial floor
    Floor *_floor;
    
    // Declare initial platform
    Platform *_platform;
    
    // Declare global variable for screen size
    CGSize _screenSize;
    
    // Declare global batch node
    CCSpriteBatchNode *_batchNode;
    
    // Declare background scrolling node
    CCParallaxNode *_backGroundScrollingNode;
    
    // Array of floors
    NSMutableArray *_arrayOfFloors;
    
    // Array of platforms
    NSMutableArray *_arrayOfPlatforms;
    
    // Declare top platform's position
    float _platformPositionUp;
    
    // Declare bottom platform's position
    float _platformPositionDown;
    
    // Declare gravity acceleration
    double _gravity;
    
    // Declare background scroll loop
    CCActionRepeatForever *_loop;
    
    // Declare yeti's offset
    double _yetiOffset;
    
    // Declare small abyss' width
    float _smallAbyss;
    
    // Declare big abyss' width
    float _bigAbyss;
    
    // Declare next platform's position
    float _nextPlatformPosition;
    
    // Declare next floor's position
    float _nextFloorPosition;
    
    // Declare jump
    CCActionJumpBy *_yetiJump;
    
    // Declare difficulty
    NSInteger _difficulty;

    // Declare array of pinecones
    NSMutableArray *_arrayOfPinecones;
    
    // Score count
    int _gameScore;

    // Label to show the score
    CCLabelTTF *_scoreLabel;

}

+ (GameScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);

    // Initialize screen size variable
    _screenSize = [CCDirector sharedDirector].viewSize;
    
    // Load texture atlas
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"jumpandrun-hd.plist"];
    
    // Load batch node with texture atlas
    _batchNode = [CCSpriteBatchNode batchNodeWithFile:@"jumpandrun-hd.png"];
    
    // Add the batch node to the scene
    [self addChild:_batchNode];
    
    // Configure initial scene
    [self configureInitialScene];
    
    // Add main character
    [self configureYeti];

    // Set platform's default position
    _platformPositionUp = _floor.floorSprite.contentSize.height + 2 * _yeti.yetiSprite.contentSize.height;
    _platformPositionDown = _floor.floorSprite.contentSize.height + _yeti.yetiSprite.contentSize.height;
    
    // Set gravity acceleration
    _gravity = -20.0f;
    
    // Configure background scrolling
    [self configureBackgroundScrolling];

    // Configure whole scene
    [self configureWholeScene];
    
    // Enable touches management
    self.userInteractionEnabled = TRUE;
    
    // Initialize score count
    _gameScore = 0;
    
    // Initialize and place score label
    _scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"SCORE: %i", _gameScore] fontName:@"Chalkduster" fontSize:15];
    _scoreLabel.position = CGPointMake(_screenSize.width - 40, _screenSize.height - 40);
    _scoreLabel.anchorPoint = CGPointMake(1.0, 0.5);
    
    // Add score label to scene
   [self addChild:_scoreLabel];

    return self;
}

-(void) configureYeti{
    // Init yeti
    _yeti = [[Yeti alloc] initYeti];

    // Set yeti's initial position
    [_yeti setPosition:CGPointMake(_screenSize.width/8, _screenSize.height/2)];
    
    // Run initial action
    [_yeti.yetiSprite runAction:_yeti.actionStill];
    
    // Add yeti to the scene
    [_batchNode addChild:_yeti.yetiSprite z:1];
    
    // Initialize offset's value
    _yetiOffset = _yeti.yetiSprite.contentSize.height/5;
}

-(void) configureInitialScene{
    
    // Initialize floors' array with capacity
    _arrayOfFloors = [NSMutableArray arrayWithCapacity:NUM_FLOORS];
    
    // Initialize platforms' array with capacity
    _arrayOfPlatforms = [NSMutableArray arrayWithCapacity:NUM_PLATFORMS];

    // Init floor
    _floor = [[Floor alloc] initFloorWithSize:(FloorSize)L];

    // Set floor's initial position
    [_floor setPosition:CGPointMake(0.0, 0.0)];
    
    // Add floor to the scene
    [_batchNode addChild:_floor.floorSprite];
    
    // Add floor to array
    [_arrayOfFloors addObject:_floor];
    
    // Define yeti's jump
    _yetiJump = [CCActionJumpBy actionWithDuration:0.75f position:CGPointMake(0.0, 0.0) height:_screenSize.height - _yeti.yetiSprite.contentSize.height jumps:1];
    
    // Initialize difficulty with user defaults
    _difficulty = [[NSUserDefaults standardUserDefaults] integerForKey:kGameDifficulty];

     // Initialize pinecones' array with capacity
    _arrayOfPinecones = [NSMutableArray arrayWithCapacity:NUM_FLOORS * NUM_PLATFORMS];
}

-(void) configureBackgroundScrolling{
    
    // Create the layers that will take part in the background scrolling
    CCSprite *background1 = [CCSprite spriteWithImageNamed:@"JumpAndRunAtlas/background.png"];
    CCSprite *background2 = [CCSprite spriteWithImageNamed:@"JumpAndRunAtlas/background.png"];
    CCSprite *background3 = [CCSprite spriteWithImageNamed:@"JumpAndRunAtlas/background.png"];
    
    // Define start positions
    CGPoint backgroundOffset1 = CGPointZero;
    CGPoint backgroundOffset2 = CGPointMake(background1.contentSize.width - 1, 0);
    CGPoint backgroundOffset3 = CGPointMake(background1.contentSize.width + background2.contentSize.width - 2, 0);
    
    // Initialize background scrolling node
    _backGroundScrollingNode = [CCParallaxNode node];
    
    // Add parallax childs defining z-order, ratio and offset
    [_backGroundScrollingNode addChild:background1 z:0 parallaxRatio:CGPointMake(1, 0) positionOffset:backgroundOffset1];
    [_backGroundScrollingNode addChild:background2 z:0 parallaxRatio:CGPointMake(1, 0) positionOffset:backgroundOffset2];
    [_backGroundScrollingNode addChild:background3 z:0 parallaxRatio:CGPointMake(1, 0) positionOffset:backgroundOffset3];
    
    // Add the node to the scene
    [_batchNode addChild:_backGroundScrollingNode z:-1];
    
    // Create the move actions
    CCActionMoveBy *move1 = [CCActionMoveBy actionWithDuration:BACKGROUND_DURATION position:CGPointMake(-(background1.contentSize.width + background2.contentSize.width), 0)];
    CCActionMoveBy *move2 = [CCActionMoveBy actionWithDuration:0 position:CGPointMake(background1.contentSize.width + background2.contentSize.width, 0)];
    
    // Create a sequence with both movements
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[move1, move2]];
    
    // Create an infinite loop for the movement action
    _loop = [CCActionRepeatForever actionWithAction:sequence];
}

- (void)update:(NSTimeInterval)delta {
    // Make the yeti fall
    [_yeti setPosition:CGPointMake(_yeti.yetiSprite.position.x, _yeti.yetiSprite.position.y + _gravity)];
    //Check collisions
    [self checkBlockCollisionWithYeti];
    
    // Check pinecone collision
    [self checkPineconeCollected];
}

- (void) checkBlockCollisionWithYeti {
    for (Floor *currentFloor in _arrayOfFloors) {
        if (_yeti.yetiSprite.position.x + _yeti.yetiSprite.contentSize.width > currentFloor.floorSprite.position.x && _yeti.yetiSprite.position.x < currentFloor.floorSprite.position.x + currentFloor.floorSprite.contentSize.width && _yeti.yetiSprite.position.y <= currentFloor.floorSprite.contentSize.height - _yetiOffset) {
            // If the yeti collides with some floor
                [_yeti setPosition:CGPointMake(_yeti.yetiSprite.position.x, currentFloor.floorSprite.contentSize.height - _yetiOffset)];
            
            if ([_yeti.yetiSprite numberOfRunningActions] == 0 && (int)_yeti.yetiState == yetiJumping) {
                // Run action
                [_yeti.yetiSprite runAction:_yeti.actionRun];
                // Update state
                _yeti.yetiState = yetiRunning;
            } else if ([_yeti.yetiSprite numberOfRunningActions] == 0 && (int)_yeti.yetiState == yetiStill) {
                [self makeYetiRun];
            }
        }
    }
    
    // Check collisions with platforms
    for (Platform *currentPlatform in _arrayOfPlatforms) {
        if (_yeti.yetiSprite.position.x + _yeti.yetiSprite.contentSize.width >= currentPlatform.platformSprite.position.x && _yeti.yetiSprite.position.x <= currentPlatform.platformSprite.position.x + currentPlatform.platformSprite.contentSize.width && _yeti.yetiSprite.position.y <= currentPlatform.platformSprite.position.y + currentPlatform.platformSprite.contentSize.height){
            
            // Top-platform-bottom-yeti collision
            [_yeti setPosition:CGPointMake(_yeti.yetiSprite.position.x, currentPlatform.platformSprite.position.y + currentPlatform.platformSprite.contentSize.height  - _yetiOffset/2)];
            
            if ([_yeti.yetiSprite numberOfRunningActions] == 0 && (int)_yeti.yetiState == yetiJumping) {
                // Run action
                [_yeti.yetiSprite runAction:_yeti.actionRun];
                // Update state
                _yeti.yetiState = yetiRunning;
            }
        }
    }
}

-(void) configureWholeScene{
    int floorType;
    int platformType;
    
    // Initialize abyss widths
    _smallAbyss = _screenSize.width / 5;
    _bigAbyss = _screenSize.width / 3;
    
    for (int i = 0; i < NUM_FLOORS; i++) {
        for (int j = 0; j < NUM_PLATFORMS; j++) {
            // Create random floor type
            floorType = arc4random_uniform(kFLOOR_TYPES);
            // Create random platform type
            platformType = arc4random_uniform(kPLATFORM_TYPES);
            
            switch (floorType) {
                case SmallAbyss:
                    _nextFloorPosition = _floor.floorSprite.position.x + _floor.floorSprite.contentSize.width + _smallAbyss;
                    _nextPlatformPosition = _floor.floorSprite.position.x + _floor.floorSprite.contentSize.width;
                    floorType = floorType - 2;
                    break;
                case BigAbyss:
                    _nextFloorPosition = _floor.floorSprite.position.x + _floor.floorSprite.contentSize.width + _bigAbyss;
                    _nextPlatformPosition = _floor.floorSprite.position.x + _floor.floorSprite.contentSize.width;
                    floorType = floorType - 2;
                    break;
                    
                default:
                    _nextFloorPosition += _floor.floorSprite.contentSize.width;
                    _nextPlatformPosition += _platform.platformSprite.contentSize.width + arc4random_uniform(_screenSize.width/5);
                    break;
            }
            
            // Init platform
            _platform = [[Platform alloc] initPlatformWithSize:(PlatformSize)platformType];
            switch (platformType) {
                case Platform_M_Up:
                case Platform_L_Up:
                case Platform_XL_Up:
                    [_platform setPosition:CGPointMake(_nextPlatformPosition, _platformPositionUp)];
                    break;
                case Platform_M_Down:
                case Platform_L_Down:
                case Platform_XL_Down:
                    [_platform setPosition:CGPointMake(_nextPlatformPosition, _platformPositionDown)];
                    break;
                default:
                    break;
            }
            // Add platform to array and scene
            [_batchNode addChild:_platform.platformSprite];
            [_arrayOfPlatforms addObject: _platform];
            
            // Init floor
            _floor = [[Floor alloc] initFloorWithSize:(FloorSize)floorType];
            [_floor setPosition:CGPointMake(_nextFloorPosition, 0.0)];
            
            // Add floor to the scene
            [_batchNode addChild:_floor.floorSprite z:0];
            // Add floor to array
            [_arrayOfFloors addObject: _floor];
            
            // Init pinecone's flag
            int loadPinecone = arc4random_uniform(2);
            
            // Declare pinecone sprite
            CCSprite *pineconeSprite;
            
            if (loadPinecone == 1) {
                // Create pinecone
                pineconeSprite = [[CCSprite alloc] initWithImageNamed:@"JumpAndRunAtlas/pinecone.png"];
                // Set pinecone position
                [pineconeSprite setPosition:CGPointMake(_nextPlatformPosition + _platform.platformSprite.contentSize.width / 2, _platform.platformSprite.position.y + _platform.platformSprite.contentSize.height)];
                // Add pinecone to the scene and the array
                [_batchNode addChild:pineconeSprite];
                [_arrayOfPinecones addObject: pineconeSprite];
            }
        }
    }
}

-(void) makeYetiRun{
    // Run action
    [_yeti.yetiSprite runAction:_yeti.actionRun];
    // Update state
    _yeti.yetiState = yetiRunning;
    
    // Move platforms
    [self movePlatforms];
    // Move floors
    [self moveFloors];
    // Move pinecones
    [self movePinecones];
    
    // Run the scrolling action
    if ([_backGroundScrollingNode numberOfRunningActions] == 0) {
        [_backGroundScrollingNode runAction:_loop];
    }
}

-(void) movePlatforms{
    CCActionMoveTo *actionMovePlatform;
    float durationPlatform;
    for (Platform *platform in _arrayOfPlatforms) {
        if ([platform numberOfRunningActions] == 0) {
            // Set platform's last position
            CGPoint nextPosition = CGPointMake((-1) * platform.contentSize.width, platform.position.y);
            // Set movement's duration
            durationPlatform = ccpDistance(nextPosition, platform.position) / (kBLOCKS_SPEED * _difficulty);
            // Define movement
            actionMovePlatform = [CCActionMoveTo actionWithDuration:durationPlatform position:nextPosition];
            // Run movement
            [platform.platformSprite runAction:actionMovePlatform];
        }
    }
}

-(void) moveFloors{
    CCActionMoveTo *actionMoveFloor;
    float durationFloor;
    for (Floor *floor in _arrayOfFloors) {
        if ([floor numberOfRunningActions] == 0) {
            // Set floor's last position
            CGPoint nextPosition = CGPointMake((-1) * floor.contentSize.width, floor.position.y);
            // Set movement's duration
            durationFloor = ccpDistance(nextPosition, floor.position) / (kBLOCKS_SPEED * _difficulty);
            // Define movement
            actionMoveFloor = [CCActionMoveTo actionWithDuration:durationFloor position:nextPosition];
            // Run movement
            [floor.floorSprite runAction:actionMoveFloor];
        }
    }
}

-(void) movePinecones{
    CCActionMoveTo *actionMovePinecone;
    float durationPinecone;
    for (CCSprite *pinecone in _arrayOfPinecones) {
        if ([pinecone numberOfRunningActions] == 0) {
            // Set pinecone's last position
            CGPoint nextPosition = CGPointMake((-1.0f) * pinecone.contentSize.width, pinecone.position.y);
            // Set movement's duration
            durationPinecone = ccpDistance(nextPosition, pinecone.position) / (kBLOCKS_SPEED * _difficulty);
            // Define movement
            actionMovePinecone = [CCActionMoveTo actionWithDuration:durationPinecone position:nextPosition];
            // Run movement
            [pinecone runAction:actionMovePinecone];
        }
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Make the yeti jump
    [self jumpYeti];
}

-(void) jumpYeti{
    // Jump if the yeti is not already jumping
    if ([_yeti.yetiSprite numberOfRunningActions] == 1 && (int)_yeti.yetiState != yetiJumping) {
        _yeti.yetiState = yetiJumping;
        [_yeti.yetiSprite stopAllActions];
        [_yeti.yetiSprite runAction:_yeti.actionJump];
        [_yeti.yetiSprite runAction:_yetiJump];
    }
}

-(void) checkPineconeCollected {
    for (CCSprite *pinecone in _arrayOfPinecones) {
        if (CGRectIntersectsRect(pinecone.boundingBox, _yeti.yetiSprite.boundingBox)) {
            // Increase score
            [self increaseScore];
            // Make it dissapear
            [pinecone setVisible:FALSE];
        }
    }
}

-(void) increaseScore{
    _gameScore += 10;
    [_scoreLabel setString:[NSString stringWithFormat:@"SCORE: %i", _gameScore]];
}

@end
