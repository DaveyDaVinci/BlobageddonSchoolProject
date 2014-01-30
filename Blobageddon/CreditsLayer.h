//
//  CreditsLayer.h
//  Blobageddon
//
//  Created by David Magee on 1/29/14.
//  Copyright 2014 David Magee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CreditsLayer : CCLayer {
    CCSprite *backButton;
    
    CCSpriteBatchNode *smallSpriteNode;
  
    
    BOOL buttonPressed;
}
+(CCScene *) scene;
@end
