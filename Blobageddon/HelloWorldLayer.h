//
//  HelloWorldLayer.h
//  Blobageddon
//
//  Created by David Magee on 1/8/14.
//  Copyright David Magee 2014. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Blobs.h"
#import "Powerups.h"


#define BLUE_GLOB 0
#define WIZARD_GLOB 1

#define LARGE_GLOB 0
#define SMALL_GLOB 1

#define ZOMBIE 0
#define WIZARD 1
#define QUEEN 2
#define FIREMAN 3

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    NSMutableArray *arrayOfSprites;
    
    NSMutableArray *arrayOfPowerups;
    
    NSMutableArray *largeSpriteAnim;
    
    BOOL swipedGlob;
    BOOL tappedWizardPowerup;
    
    int globalBlobType;
    
    int swipedGlobIndex;
    
    CGFloat startingX;
    CGFloat startingY;
    
    CADisplayLink *gameTimer;
    
    Blobs *selectedBlob;
    
    CGSize winSize;
    
    CCSprite *electricSprite;
    
    CCSprite *pausePlayButton;
    CCSprite *loseButton;
    BOOL pausePlay;
    
    int blobScore;
    
    
    CCLabelTTF *scoreLabel;
    
    CCSpriteBatchNode *largeSpritesheet;
    CCSpriteBatchNode *powerupSpriteSheet;
    CCSpriteBatchNode *powerUpBoxes;
    CCSpriteBatchNode *wizardSpritesheet;
    
    CCSprite *wizardPowerUpBox;
    
    NSTimer *wizardPowerupTimer;
    
    BOOL wizardPowerUpUsed;
    BOOL wizardPowerUpCollected;
    
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
