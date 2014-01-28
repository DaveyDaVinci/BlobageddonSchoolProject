//
//  LaunchLayer.m
//  Blobageddon
//
//  Created by David Magee on 1/28/14.
//  Copyright 2014 David Magee. All rights reserved.
//

#import "LaunchLayer.h"
#import "HelloWorldLayer.h"


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
-(void) onEnter
{
	[super onEnter];
    NSLog(@"This scene was hit");
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
}


@end
