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


#define BLUE_GLOB 0
#define LARGE_GLOB 0
#define SMALL_GLOB 1

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    NSMutableArray *arrayOfSprites;
    
    NSMutableArray *largeSpriteAnim;
    
    BOOL swipedGlob;
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
    
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
