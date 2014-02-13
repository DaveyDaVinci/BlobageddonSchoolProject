//
//  Powerups.m
//  Blobageddon
//
//  Created by David Magee on 2/10/14.
//  Copyright (c) 2014 David Magee. All rights reserved.
//

#import "Powerups.h"

@implementation Powerups
@synthesize powerupType, spriteAppeared, spriteLocation, spriteVelocity, powerUpSprite, spriteInteractive, spriteCollected;


-(id)initWithPowerupType:(int)type position:(CGPoint)position velocity:(CGPoint)velocity appeared:(BOOL)appeared interactive:(BOOL)interactive collected:(BOOL)collected
{
    self = [super init];
    
    if (self)
    {
        powerupType = type;
        spriteLocation = position;
        spriteVelocity = velocity;
        spriteAppeared = appeared;
        spriteInteractive = interactive;
        spriteCollected = collected;
        
    }
    
    return self;
}

-(void)updateLocation
{
    spriteLocation = ccp(spriteLocation.x + spriteVelocity.x, spriteLocation.y + spriteVelocity.y);
}

@end
