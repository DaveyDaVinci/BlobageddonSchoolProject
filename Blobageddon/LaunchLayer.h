//
//  LaunchLayer.h
//  Blobageddon
//
//  Created by David Magee on 1/28/14.
//  Copyright 2014 David Magee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LaunchLayer : CCLayer {
    
    CCSpriteBatchNode *smallSpriteNode;
    NSMutableArray *smallSpriteAnims;
    
    BOOL buttonPressed;
    
    CCSprite *startButton;
    CCSprite *directionsButton;
    CCSprite *creditsButton;
    
}

+(CCScene *) scene;

@end
