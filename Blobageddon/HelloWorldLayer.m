//
//  HelloWorldLayer.m
//  Blobageddon
//
//  Created by David Magee on 1/8/14.
//  Copyright David Magee 2014. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
    
   
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    if ((self = [super init]))
    {
        arrayOfSprites = [[NSMutableArray alloc] init];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *backgroundimage = [CCSprite spriteWithFile:@"towers.png"];
        backgroundimage.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:backgroundimage z:-10];
        
        CCSprite *largeBlob = [CCSprite spriteWithFile:@"sprite1.png"];
        largeBlob.scale = 2.0f;
        largeBlob.position = ccp(100, winSize.height/2);
        largeBlob.tag = 1;
       
        [arrayOfSprites addObject:largeBlob];
        
        [self addChild:largeBlob];
        
        CCSprite *smallBlob = [CCSprite spriteWithFile:@"smallblob1.png"];
        smallBlob.scale = 1.7f;
        smallBlob.position = ccp(40, 90);
        smallBlob.tag = 2;
        [arrayOfSprites addObject:smallBlob];
        
        
        [self addChild:smallBlob];
        
        CCSprite *splatBlob = [CCSprite spriteWithFile:@"splat1.png"];
        
        splatBlob.position = ccp(240, 190);
        splatBlob.tag = 3;
        [arrayOfSprites addObject:splatBlob];
        
        [self addChild:splatBlob];
        
        CCSprite *electric = [CCSprite spriteWithFile:@"electric.png"];
        
        electric.position = ccp(400, 230);
        electric.tag = 4;
        [arrayOfSprites addObject:electric];
        
        [self addChild:electric];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mediumzaps.wav"];
        
        self.touchEnabled = TRUE;
        
        
    }
		return self;
}

// on "dealloc" you need to release all your retained objects


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
   
    
    
    for (CCSprite *blob in arrayOfSprites)
    {
        
        if (CGRectContainsPoint(blob.boundingBox, location))
        {
           NSLog(@"Sprite Touched");
            if(blob.tag==3){
               
                [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
                
            }
            else if (blob.tag == 4)
            {
                [[SimpleAudioEngine sharedEngine] playEffect:@"zap.wav"];
            }
            else if (blob.tag == 1)
            {
                [[SimpleAudioEngine sharedEngine] playEffect:@"whoosh.m4a"];
            }
        }
    }
    
    
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
