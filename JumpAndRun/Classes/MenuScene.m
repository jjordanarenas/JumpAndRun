#import "MenuScene.h"

@implementation MenuScene
{
    // Declare a layout for the menu
    CCLayoutBox *_menuLayout;
 
    // Declare global variable for screen size
    CGSize _screenSize;
    
    // Declare global batch node
    CCSpriteBatchNode *_batchNode;

}

+ (MenuScene *)scene
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
    
    // Initialize the background
    CCSprite *background = [CCSprite spriteWithImageNamed:@"JumpAndRunAtlas/menu_background.png"];
    // Set background position
    background.position = CGPointMake(0.0, 0.0);
    // Add background to the game scene
    [self addChild:background z:-1];
    
     // Create menu
    [self createMenuButtons];
    
    return self;
}

-(void) createMenuButtons {
    // Create button
    CCButton *buttonEasyDifficulty = [CCButton buttonWithTitle:@"Easy" fontName:@"Chalkduster" fontSize:20];
    // Set button selector
    [buttonEasyDifficulty setTarget:self selector:@selector(easySelected:)];
    
    // Create button
    CCButton *buttonMediumDifficulty = [CCButton buttonWithTitle:@"Medium" fontName:@"Chalkduster" fontSize:20];
    // Set button selector
    [buttonMediumDifficulty setTarget:self selector:@selector(mediumSelected:)];
    
    // Create button
    CCButton *buttonHardDifficulty = [CCButton buttonWithTitle:@"Hard" fontName:@"Chalkduster" fontSize:20];
    // Set button selector
    [buttonHardDifficulty setTarget:self selector:@selector(hardSelected:)];
    
    // Create menu
    _menuLayout = [[CCLayoutBox alloc] init];
    _menuLayout.direction = CCLayoutBoxDirectionVertical;
    _menuLayout.spacing = 20.0;
    
    // Set menu position
    _menuLayout.anchorPoint = CGPointMake(0.5, 0.5);
    _menuLayout.position = CGPointMake(_screenSize.width/2, _screenSize.height/2);
    
    // Add buttons to the menu
    [_menuLayout addChild:buttonHardDifficulty];
    [_menuLayout addChild:buttonMediumDifficulty];
    [_menuLayout addChild:buttonEasyDifficulty];
    
    // Add menu to the scene
    [_batchNode addChild:_menuLayout];
}

-(void) easySelected:(id)sender {
    // Create transition
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.15f];
    
    // Create new game scene
    GameScene *gameScene = [GameScene scene];

    // Store difficulty
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kGameDifficulty];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Push scene with transition
    [[CCDirector sharedDirector] pushScene:gameScene withTransition:transition];
}

-(void) mediumSelected:(id)sender {
    // Create transition
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.15f];
    
    // Create new game scene
    GameScene *gameScene = [GameScene scene];
    
    // Store difficulty
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:kGameDifficulty];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Push scene with transition
    [[CCDirector sharedDirector] pushScene:gameScene withTransition:transition];
}

-(void) hardSelected:(id)sender {
    // Create transition
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.15f];
    
    // Create new game scene
    GameScene *gameScene = [GameScene scene];
    
    // Store difficulty
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:kGameDifficulty];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Push scene with transition
    [[CCDirector sharedDirector] pushScene:gameScene withTransition:transition];
}

@end
