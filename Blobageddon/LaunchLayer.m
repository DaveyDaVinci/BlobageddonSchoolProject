//
//  LaunchLayer.m
//  Blobageddon
//
//  Created by David Magee on 1/28/14.
//  Copyright 2014 David Magee. All rights reserved.
//

#import "LaunchLayer.h"
#import "HelloWorldLayer.h"
#import "CreditsLayer.h"
#import "DirectionsLayer.h"
#import "Achievements.h"

#import <Parse/Parse.h>


@implementation LaunchLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LaunchLayer *layer = [LaunchLayer node];
	
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
        
        [self setTouchEnabled:TRUE];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"smallspriteanimation.plist"];
        // CCSpriteBatchNode *largeBlueBlobSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"spriteanimated.png"];
        
        smallSpriteNode = [CCSpriteBatchNode batchNodeWithFile:@"smallspriteanimation.png"];
        [self addChild:smallSpriteNode];
        
        
        smallSpriteAnims = [NSMutableArray array];
        for (int i = 1;  i <= 3; i++)
        {
            [smallSpriteAnims addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                                        [NSString stringWithFormat:@"smallblob%d.png", i]]];
        }
        
        CCAnimation *smallBlueAnimation = [CCAnimation animationWithSpriteFrames:smallSpriteAnims delay:0.1f];
        CCRepeatForever * smallBlueMovement = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:smallBlueAnimation]];
        
        CCSprite *smallBlueSprite = [CCSprite spriteWithSpriteFrameName:@"smallblob1.png"];
        smallBlueSprite.position = ccp(100,100);
        [smallBlueSprite runAction:smallBlueMovement];
        [smallSpriteNode addChild:smallBlueSprite];
        
        
        CCSprite *background;
        
       
       // background.scaleX = size.width / 325;
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height == 568) {
            // code for iPhone 5
            background = [CCSprite spriteWithFile:@"labpngiphone.png"];
            
        } else {
            // code for all other iOS devices
            background = [CCSprite spriteWithFile:@"labpng.png"];
        }        
                  
        background.position = [self scalePoint:ccp(240, 160)];          
        NSLog(@"Winsize = %f, %f  background = %d, %d  scale = %f, %f", size.width, size.height, 325, 192, background.scaleX, background.scaleY);
        
        [self addChild:background z:-10];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mainmenubuttons.plist"];
        CCSpriteBatchNode *buttonSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"mainmenubuttons.png"];
        [self addChild:buttonSpriteSheet];
        
        startButton = [CCSprite spriteWithSpriteFrameName:@"startbutton.png"];
        startButton.scale = 1.5;
        [buttonSpriteSheet addChild:startButton z:10];
        startButton.position = ccp(size.width / 5, size.height / 5);
        
        directionsButton = [CCSprite spriteWithSpriteFrameName:@"directionsbutton.png"];
        directionsButton.scale = 1.5;
        [buttonSpriteSheet addChild:directionsButton z:10];
        directionsButton.position = ccp(size.width / 2, size.height / 5);
        
        creditsButton = [CCSprite spriteWithFile:@"localbutton.png"];
        creditsButton.scale = .75;
        [self addChild:creditsButton];
        creditsButton.position = ccp((size.width / 5) * 4, size.height / 5);
        
        PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
        testObject[@"foo"] = @"bar";
        [testObject saveInBackground];
        
        
        /*
		CCSprite *background;
		
        
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);
        
		// add the label as a child to this Layer
		[self addChild: background];
         */
	}
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint(startButton.boundingBox, location) || CGRectContainsPoint(creditsButton.boundingBox, location) ||
        CGRectContainsPoint(directionsButton.boundingBox, location))
    {
        buttonPressed = TRUE;
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint(startButton.boundingBox, location) && buttonPressed == TRUE)
    {
        buttonPressed = FALSE;
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
    }
    else if (CGRectContainsPoint(creditsButton.boundingBox, location) && buttonPressed == TRUE)
    {
        buttonPressed = FALSE;
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:.5 scene:[Achievements scene]]];
    }
    else if (CGRectContainsPoint(directionsButton.boundingBox, location) && buttonPressed == TRUE)
    {
        buttonPressed = FALSE;
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:.5 scene:[DirectionsLayer scene]]];
    }
}

/*
-(void) onEnter
{
	[super onEnter];
    NSLog(@"This scene was hit");
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:5.0 scene:[HelloWorldLayer scene] ]];
}
*/
-(CGPoint) scalePoint:(CGPoint)point
{
    CGSize designSize = {480, 320};
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGSize scaleFactor = CGSizeMake(winSize.width / designSize.width,
                                    winSize.height / designSize.height);
    return CGPointMake(point.x * scaleFactor.width, point.y * scaleFactor.height);
}

@end
