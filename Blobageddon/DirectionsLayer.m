//
//  DirectionsLayer.m
//  Blobageddon
//
//  Created by David Magee on 1/29/14.
//  Copyright 2014 David Magee. All rights reserved.
//

#import "DirectionsLayer.h"


@implementation DirectionsLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DirectionsLayer *layer = [DirectionsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id)init
{
    if( (self=[super init])) {
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *backgroundimage = [CCSprite spriteWithFile:@"towers.png"];
        backgroundimage.position = ccp(size.width/2, size.height/2);
        [self addChild:backgroundimage z:-10];
        
        [self setTouchEnabled:TRUE];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"allsprites.plist"];
        // CCSpriteBatchNode *largeBlueBlobSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"spriteanimated.png"];
        
        smallSpriteNode = [CCSpriteBatchNode batchNodeWithFile:@"allsprites.png"];
        [self addChild:smallSpriteNode];
        
        
        backButton = [CCSprite spriteWithFile:@"backbutton.png"];
        backButton.scale = .75;
        backButton.position = ccp(size.width / 5, size.height / 5);
        [self addChild:backButton];
        
        CCSprite *wizardSprite = [CCSprite spriteWithSpriteFrameName:@"wizard.png"];
        int randomWidth = arc4random() % abs(size.width);
        int randomHeight = arc4random() % abs(size.height);
        wizardSprite.position = ccp(randomWidth, randomHeight);
        
        CCSprite *queenSprite = [CCSprite spriteWithSpriteFrameName:@"Queen.png"];
        randomWidth = arc4random() % abs(size.width);
        randomHeight = arc4random() % abs(size.height);
        queenSprite.position = ccp(randomWidth, randomHeight);
        queenSprite.scaleX *= -1;
        
        CCSprite *firemanSprite = [CCSprite spriteWithSpriteFrameName:@"Fireman.png"];
        randomWidth = arc4random() % abs(size.width);
        randomHeight = arc4random() % abs(size.height);
        firemanSprite.position = ccp(randomWidth, randomHeight);
        
        CCSprite *ghostSprite = [CCSprite spriteWithSpriteFrameName:@"ghosttransparent.png"];
        randomWidth = arc4random() % abs(size.width);
        randomHeight = arc4random() % abs(size.height);
        ghostSprite.position = ccp(randomWidth, randomHeight);
        
        CCSprite *zombieSprite = [CCSprite spriteWithSpriteFrameName:@"zombie.png"];
        randomWidth = arc4random() % abs(size.width);
        randomHeight = arc4random() % abs(size.height);
        zombieSprite.position = ccp(randomWidth, randomHeight);
        
        [smallSpriteNode addChild:queenSprite];
        [smallSpriteNode addChild:wizardSprite];
        [smallSpriteNode addChild:firemanSprite];
        [smallSpriteNode addChild:ghostSprite];
        [smallSpriteNode addChild:zombieSprite];
        
        CCLabelTTF *creditsLabel = [CCLabelTTF labelWithString:@"Directions:\n\n\n Swipe blobs toward electrified post\n\nsmall blobs disappear\n\nbig blobs break apart into smaller blobs" fontName: @"Courier" fontSize:20.0];
        [creditsLabel setPosition:ccp(size.width / 2, (size.height / 3) * 2)];
        [self addChild:creditsLabel z:20];
    }
    
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint(backButton.boundingBox, location))
    {
        buttonPressed = TRUE;
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint(backButton.boundingBox, location) && buttonPressed == TRUE)
    {
        buttonPressed = FALSE;
        [[CCDirector sharedDirector] popScene];
        
    }
}

@end
