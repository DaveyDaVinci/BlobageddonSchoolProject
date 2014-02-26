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
#import "SaveLeaderboardScores.h"

#define BLUE_GLOB 0
#define WIZARD_GLOB 1

#define LARGE_GLOB 0
#define SMALL_GLOB 1

#define ZOMBIE 0
#define WIZARD 1
#define QUEEN 2
#define FIREMAN 3

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, UITextFieldDelegate>
{
    NSMutableArray *arrayOfSprites;
    
    NSMutableArray *arrayOfPowerups;
    
    NSMutableArray *largeSpriteAnim;
    
    BOOL swipedGlob;
    BOOL tappedWizardPowerup;
    BOOL saveButtonTapped;
    BOOL shareButtonTapped;
    
    int globalBlobType;
    
    int swipedGlobIndex;
    
    int finalScore;
    
    CGFloat startingX;
    CGFloat startingY;
    
    CADisplayLink *gameTimer;
    
    NSTimer *gameWinTimer;
    
    Blobs *selectedBlob;
    
    CGSize winSize;
    
    CCSprite *electricSprite;
    
    CCSprite *pausePlayButton;
    CCSprite *loseButton;
    CCSprite *saveButton;
    CCSprite *shareButton;
    
    BOOL pausePlay;
    
    int blobScore;
    int timeKeep;
    
    int largeBlobsAppeared;
    
    
    CCLabelTTF *scoreLabel;
    CCLabelTTF *timerLabel;
    
    CCSpriteBatchNode *largeSpritesheet;
    CCSpriteBatchNode *powerupSpriteSheet;
    CCSpriteBatchNode *powerUpBoxes;
    CCSpriteBatchNode *wizardSpritesheet;
    
    CCSprite *wizardPowerUpBox;
    
    NSTimer *wizardPowerupTimer;
    
    BOOL wizardPowerUpUsed;
    BOOL wizardPowerUpCollected;
    
    UITextField *userNameField;
    
    SaveLeaderboardScores *save;
    
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
