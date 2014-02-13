//
//  Powerups.h
//  Blobageddon
//
//  Created by David Magee on 2/10/14.
//  Copyright (c) 2014 David Magee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define ZOMBIE 0
#define WIZARD  1
#define QUEEN  2
#define FIREMAN 3

@interface Powerups : NSObject
{
    int powerUpType;
    CGPoint spriteLocation;
    CGPoint spriteVelocity;
    BOOL spriteAppeared;
    BOOL spriteInteractive;
    BOOL spriteCollected;
    
    CCSprite * powerUpSprite;
}

-(id)initWithPowerupType:(int)type position:(CGPoint)position velocity:(CGPoint)velocity appeared:(BOOL)appeared interactive:(BOOL)interactive collected:(BOOL)collected;

-(void)updateLocation;

@property int powerupType;
@property CGPoint spriteLocation;
@property CGPoint spriteVelocity;
@property BOOL spriteAppeared;
@property CCSprite *powerUpSprite;
@property BOOL spriteInteractive;
@property BOOL spriteCollected;
@end
