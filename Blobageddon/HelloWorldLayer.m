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
        winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *backgroundimage = [CCSprite spriteWithFile:@"towers.png"];
        backgroundimage.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:backgroundimage z:-10];
        
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"splat.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"whoosh.m4a"];
        
        /*
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
        */
        self.touchEnabled = TRUE;
       
        
        
        
        
        electricSprite = [CCSprite spriteWithFile:@"electric.png"];
        
        electricSprite.position = ccp(winSize.width/2 + (winSize.width/3), winSize.height/2 + (electricSprite.scaleY/2));
        electricSprite.tag = 0;
        
        
        [self addChild:electricSprite];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mediumzaps.wav"];
        
        
        
        
        
        
        //Test with blob class
        Blobs *largeBlobObject = [[Blobs alloc] initWithBlobType:0 blobSize:0 startTime:0.0 velocity:ccp(0,0) location:ccp(40, 90) blobInterract:TRUE tag:1];
        [arrayOfSprites addObject:largeBlobObject];
        
        Blobs *smallBlobObject = [[Blobs alloc] initWithBlobType:0 blobSize:1 startTime:0.0 velocity:ccp(0, 0) location:ccp(100, winSize.height/2) blobInterract:TRUE tag:2];
        [arrayOfSprites addObject:smallBlobObject];
        
       
        
        
        //Creates a cadisplaylink timers that will update the display every time the screen refreshes
       gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplay:)];
        
        //adds loop
      [gameTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        
    }
		return self;
}

// on "dealloc" you need to release all your retained objects


-(void)updateDisplay:(CADisplayLink *)sender
{
    
    
    if (arrayOfSprites.count != 0)
    {
        
        
        for (Blobs *blob in arrayOfSprites)
        {
            
            [self removeChild:blob.blobSprite];
            [blob updateModelWithTime:sender.timestamp];
                
                
                
            //blob.blobSprite.position = blob.blobPosition;
                
            blob.blobSprite.position = ccp(blob.blobPosition.x + blob.blobVelocity.x, blob.blobPosition.y + blob.blobVelocity.y);
            blob.blobSprite.scale = 1.5;
            [self addChild:blob.blobSprite];
            [self checkCollisionWithScreenEdges:blob];
                
            if (blob.interactable == TRUE)
            {
                
                [self checkCollisionWithElectricity:blob];
            }
                
            
            
        }
    }
    
     
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
   
    
    for (Blobs *blob in arrayOfSprites)
    {
        if (CGRectContainsPoint(blob.blobSprite.boundingBox, location))
        {
            
            
            
            swipedGlob = TRUE;
            
            
            //selectedBlob = blob;
            swipedGlobIndex = blob.blobTag;
            
            
            startingX = location.x;
            startingY = location.y;
        }
    }
    
   
}



-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (swipedGlob == TRUE)
    {
       // CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        CGFloat endLocationX = location.x;
        CGFloat endLocationY = location.y;
        
        CGFloat velocityX = startingX - endLocationX;
        CGFloat velocityY = startingY - endLocationY;
        
        
        for (Blobs *blob in arrayOfSprites)
        {
            if (blob.blobTag == swipedGlobIndex)
            {
                blob.blobVelocity = ccp(-velocityX/60, -velocityY/60);
                
                [[SimpleAudioEngine sharedEngine] playEffect:@"whoosh.m4a"];
                
                
                
            }
        }
        
        
        
        
        swipedGlob = FALSE;
        
        selectedBlob = nil;
    }
         
}

-(void)checkCollisionWithScreenEdges: (Blobs *)blob
{
    
    
    if (blob.blobSprite.position.y  >= winSize.height)
    {
        NSLog(@"Hit at top");
        CGFloat x = blob.blobVelocity.x;
        CGFloat y = blob.blobVelocity.y;
        
        blob.blobVelocity = ccp(x, -1 * abs(y));
        
        
        
        
        
        
        
    }
    else if (blob.blobSprite.position.y <= 0)
    {
        NSLog(@"Hit bottom");
        CGFloat x = blob.blobVelocity.x;
        CGFloat y = blob.blobVelocity.y;
        
        blob.blobVelocity = ccp(x, abs(y));
        
        
        
    }
    else if (blob.blobSprite.position.x >= winSize.width)
    {
        NSLog(@"Hit right");
        CGFloat x = blob.blobVelocity.x;
        CGFloat y = blob.blobVelocity.y;
        
        blob.blobVelocity = ccp(-1 * abs(x), y);
        
        
    }
    else if (blob.blobSprite.position.x <= 0)
    {
        NSLog(@"hit left");
        CGFloat x = blob.blobVelocity.x;
        CGFloat y = blob.blobVelocity.y;
        
        blob.blobVelocity = ccp(abs(x), y);
        
        
    }
     
}

-(void)checkCollisionWithElectricity: (Blobs *)blob
{
    if (CGRectIntersectsRect(blob.blobSprite.boundingBox, electricSprite.boundingBox))
    {
               
        
        CGRect intersect = CGRectIntersection(blob.blobSprite.boundingBox, electricSprite.boundingBox);
        
       
        
        
        
        float yIntersect = intersect.origin.y;
        float xIntersect = intersect.origin.x;
        
        
        
        //Hit the top
        if (yIntersect + 5 >= electricSprite.boundingBox.size.height + electricSprite.boundingBox.origin.y)
        {
            NSLog(@"hit the top");
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
            
            [self removeChild:blob.blobSprite];
            blob.blobSprite.scale = 1.5;
            //blob.blobSprite.position = ccp(blob.blobPosition.x + blob.blobVelocity.x, blob.blobPosition.y + blob.blobVelocity.y + 25);
            blob.blobVelocity = ccp(blob.blobVelocity.x, abs(blob.blobVelocity.y));
            
            blob.interactable = FALSE;
            
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeInteraction:) userInfo:blob repeats:FALSE];
            
            [self addChild:blob.blobSprite];
            
            
        }
        //Hit the bottom
        else if (yIntersect - 5 <= electricSprite.boundingBox.origin.y)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
            [self removeChild:blob.blobSprite];
            blob.blobSprite.scale = 1.5;
            //blob.blobSprite.position = ccp(blob.blobPosition.x + blob.blobVelocity.x, blob.blobPosition.y + blob.blobVelocity.y + 25);
            blob.blobVelocity = ccp(blob.blobVelocity.x, -1* abs(blob.blobVelocity.y));
            
            blob.interactable = FALSE;
            
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeInteraction:) userInfo:blob repeats:FALSE];
            
            [self addChild:blob.blobSprite];
            
        }
        //Hit the left
        else if (xIntersect <= electricSprite.boundingBox.origin.x)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
            NSLog(@"hit the left");
            [self removeChild:blob.blobSprite];
            blob.blobSprite.scale = 1.5;
            //blob.blobSprite.position = ccp(blob.blobPosition.x + blob.blobVelocity.x, blob.blobPosition.y + blob.blobVelocity.y + 25);
            blob.blobVelocity = ccp(-1 * abs(blob.blobVelocity.x), blob.blobVelocity.y);
            
            blob.interactable = FALSE;
            
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeInteraction:) userInfo:blob repeats:FALSE];
            
            [self addChild:blob.blobSprite];
        }
        //Hit the right
        else 
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
            
            [self removeChild:blob.blobSprite];
            blob.blobSprite.scale = 1.5;
            //blob.blobSprite.position = ccp(blob.blobPosition.x + blob.blobVelocity.x, blob.blobPosition.y + blob.blobVelocity.y + 25);
            blob.blobVelocity = ccp(abs(blob.blobVelocity.x), blob.blobVelocity.y);
            
            blob.interactable = FALSE;
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeInteraction:) userInfo:blob repeats:FALSE];
            
            [self addChild:blob.blobSprite];
        }
        
        
        
        
        
    }
}


-(void)changeInteraction: (NSTimer *)blobTimer
{
    Blobs *blob = [blobTimer userInfo];
    blob.interactable = TRUE;
    
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
