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
        
        self.touchEnabled = TRUE;
       
        //SpriteAnimationStuff
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spriteanimated.plist"];
       // CCSpriteBatchNode *largeBlueBlobSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"spriteanimated.png"];
        
        largeSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"spriteanimated.png"];
        [self addChild:largeSpritesheet];
       // [self addChild:largeBlueBlobSpritesheet];
        
        
       // NSMutableArray *largeSpriteAnim = [NSMutableArray array];
        
        largeSpriteAnim = [NSMutableArray array];
        for (int i = 1;  i <= 3; i++)
        {
            [largeSpriteAnim addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                                        [NSString stringWithFormat:@"sprite%d.png", i]]];
        }
        
        
        
        electricSprite = [CCSprite spriteWithFile:@"electric.png"];
        
        electricSprite.position = ccp(winSize.width/2 + (winSize.width/3), winSize.height/2 + (electricSprite.scaleY/2));
        electricSprite.tag = 0;
        
        
        [self addChild:electricSprite];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mediumzaps.wav"];
        
        
        pausePlayButton = [CCSprite spriteWithFile:@"pausebutton.png"];
        pausePlayButton.position = ccp(winSize.width - (pausePlayButton.boundingBox.size.width * .3), 0 + (pausePlayButton.boundingBox.size.height * .3));
        pausePlayButton.scale = .4;
        [self addChild:pausePlayButton z:100];
        pausePlay = FALSE;
        
        
        loseButton = [CCSprite spriteWithFile:@"lose.png"];
        loseButton.position = ccp(40, winSize.height/10 * 9);
        loseButton.scale = .4;
        [self addChild:loseButton z:100];
        
        
        /*
        //Test with blob class
        Blobs *largeBlobObject = [[Blobs alloc] initWithBlobType:0 blobSize:0 startTime:0.0 velocity:ccp(0,0) location:ccp(40, 90) blobInterract:TRUE tag:1 appeared:TRUE];
        [arrayOfSprites addObject:largeBlobObject];
        
        Blobs *smallBlobObject = [[Blobs alloc] initWithBlobType:0 blobSize:1 startTime:0.0 velocity:ccp(0, 0) location:ccp(100, winSize.height/2) blobInterract:TRUE tag:2 appeared:TRUE];
        [arrayOfSprites addObject:smallBlobObject];
        
        Blobs *smallObject2 = [[Blobs alloc] initWithBlobType:0 blobSize:1 startTime:0.0 velocity:ccp(0, 0) location:ccp(175, winSize.height/2) blobInterract:TRUE tag:3 appeared:TRUE];
        [arrayOfSprites addObject:smallObject2];
        */
        
        for (int i = 0; i < 50; i++)
        {
            Blobs *largeBlob = [[Blobs alloc] initWithBlobType:BLUE_GLOB blobSize:LARGE_GLOB startTime:0.0 velocity:ccp(0, 0) location:ccp(40, 90) blobInterract:TRUE tag:i appeared:FALSE];
            
            
            
            Blobs *smallBlob = [[Blobs alloc] initWithBlobType:BLUE_GLOB blobSize:SMALL_GLOB startTime:0.0 velocity:ccp(0, 0) location:ccp(75, winSize.height/3) blobInterract:TRUE tag:i + 50 appeared:FALSE];
            
            [arrayOfSprites addObject:smallBlob];
            
            
            if (largeBlob.blobTag <= 5)
            {
                largeBlob.appeared = TRUE;
                int randomX = arc4random() % abs(electricSprite.boundingBox.origin.x - 70);
                int randomY = arc4random() % abs(winSize.height);
                
                 largeBlob.blobPosition = ccp(randomX, randomY);
                
                
                
               
            }
            
            [arrayOfSprites addObject:largeBlob];
        }
        
        
        
        for (Blobs *blob in arrayOfSprites)
        {
           // blob.blobSprite.position = blob.blobPosition;
            
            if (blob.appeared == TRUE)
            {
                if (blob.blobSize == LARGE_GLOB)
                {
                    
                    blob.blobSprite = [CCSprite spriteWithSpriteFrameName:@"sprite1.png"];
                    blob.blobSprite.position = blob.blobPosition;
                    CCAnimation *largeBlueBlobAnimation = [CCAnimation animationWithSpriteFrames:largeSpriteAnim delay:0.1f];
                    CCRepeatForever * largeBlueBlobMovement = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:largeBlueBlobAnimation]];
                    [blob.blobSprite runAction:largeBlueBlobMovement];
                   // [largeBlueBlobSpritesheet addChild:blob.blobSprite];
                    [largeSpritesheet addChild:blob.blobSprite];
                    //[self addChild:blob.blobSprite];
                }
                else if (blob.blobSize == SMALL_GLOB)
                {
                    [self addChild:blob.blobSprite];
                    blob.blobSprite.position = blob.blobPosition;
                }
            }
            
            
        }
        
        
        //Creates a cadisplaylink timers that will update the display every time the screen refreshes
       gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplay:)];
        
        //adds loop
       [gameTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        blobScore = 0;
        
        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d/10", blobScore] fontName: @"Courier" fontSize:20.0];
        [scoreLabel setPosition:ccp(winSize.width - 40, winSize.height - 30)];
        [self addChild:scoreLabel z:20];
        
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
            if (blob.appeared == TRUE)
            {
                //[self removeChild:blob.blobSprite];
                [blob updateModelWithTime:sender.timestamp];
                
                
                blob.blobSprite.position = ccp(blob.blobPosition.x + blob.blobVelocity.x, blob.blobPosition.y + blob.blobVelocity.y);
                
                if (blob.blobVelocity.x > blob.blobVelocity.y)
                {
                    blob.blobSprite.flipX = TRUE;
                }
                else if (blob.blobVelocity.y > blob.blobVelocity.x)
                {
                    blob.blobSprite.rotation = 90;
                }
                
                [self checkCollisionWithScreenEdges:blob];
                
                if (blob.interactable == TRUE)
                {
                    
                    [self checkCollisionWithElectricity:blob];
                    [self checkCollisionWithOtherBlob:blob];
                }
            }
            
            
        }
    }
    
     
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint(pausePlayButton.boundingBox, location))
    {
        //If not paused
        if (!pausePlay)
        {
            [self pauseOrResume];
        }
        else if (pausePlay)
        {
            [self pauseOrResume];
        }
    }
    
    if (CGRectContainsPoint(loseButton.boundingBox, location))
    {
        [self winLoseGame:FALSE];
    }
    
    
    for (Blobs *blob in arrayOfSprites)
    {
        if (CGRectContainsPoint(blob.blobSprite.boundingBox, location))
        {
            
            swipedGlob = TRUE;
            
            //selectedBlob = blob;
            swipedGlobIndex = blob.blobTag;
            
            startingX = location.x;
            startingY = location.y;
            NSLog(@"appeared = %d", blob.appeared);
            NSLog(@"interactable = %d", blob.interactable);
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
       // NSLog(@"Hit at top");
        CGFloat x = blob.blobVelocity.x;
        CGFloat y = blob.blobVelocity.y;
        
        blob.blobVelocity = ccp(x, -1 * abs(y));
        
        
    }
    else if (blob.blobSprite.position.y <= 0)
    {
      //  NSLog(@"Hit bottom");
        CGFloat x = blob.blobVelocity.x;
        CGFloat y = blob.blobVelocity.y;
        
        blob.blobVelocity = ccp(x, abs(y));
        
        
        
    }
    else if (blob.blobSprite.position.x >= winSize.width)
    {
       // NSLog(@"Hit right");
        CGFloat x = blob.blobVelocity.x;
        CGFloat y = blob.blobVelocity.y;
        
        blob.blobVelocity = ccp(-1 * abs(x), y);
        
        
    }
    else if (blob.blobSprite.position.x <= 0)
    {
       // NSLog(@"hit left");
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
            //NSLog(@"hit the top");
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
            if (blob.blobSize == LARGE_GLOB)
            {
               // Blobs *smallBlob1;
                //Blobs *smallBlob2;
                [self removeChild:blob.blobSprite];
                [largeSpritesheet removeChild:blob.blobSprite];
                
                blob.appeared = FALSE;
                
                [self determineSpriteDirection:ccp(blob.blobVelocity.x, - 1 * blob.blobVelocity.y) position:blob.blobPosition];
                [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                
                
                
                
                
                //OLD CODE WILL DELETE LATER
                
                /*
                for (int i = 0; i < arrayOfSprites.count; i++)
                {
                    Blobs *tempblob = [arrayOfSprites objectAtIndex:i];
                    if (tempblob.blobType == BLUE_GLOB && tempblob.blobSize == SMALL_GLOB && tempblob.appeared == FALSE)
                    {
                        smallBlob1 = tempblob;
                        tempblob.appeared = TRUE;
                        break;
                    }
                   
                }
                for (int i = 0; i < arrayOfSprites.count; i++)
                {
                    Blobs *tempblob = [arrayOfSprites objectAtIndex:i];
                    if (tempblob.blobType == BLUE_GLOB && tempblob.blobSize == SMALL_GLOB && tempblob.appeared == FALSE)
                    {
                        smallBlob2 = tempblob;
                        tempblob.appeared = TRUE;
                        break;
                    }
                    
                }
                
                [self addChild:smallBlob1.blobSprite];
                [self addChild:smallBlob2.blobSprite];
                
                
                
                smallBlob1.blobVelocity = ccp(blob.blobVelocity.x, - 1 * blob.blobVelocity.y);
                smallBlob2.blobVelocity = ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y);
                
                
                
                smallBlob1.blobPosition = blob.blobPosition;
                smallBlob2.blobPosition = blob.blobPosition;
                
                smallBlob1.interactable = FALSE;
                smallBlob2.interactable = FALSE;
                
                [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(changeInteraction:) userInfo:smallBlob1 repeats:FALSE];
                [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(changeInteraction:) userInfo:smallBlob2 repeats:FALSE];
                */
                
                
                 
            }
            else
            {
                [self removeChild:blob.blobSprite];
                blob.appeared = FALSE;
                blobScore ++;
            }
            
            //OLD CODE WILL DELETE LATER
            /*
            NSLog(@"hit the top");
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
            
          
           
            //blob.blobSprite.position = ccp(blob.blobPosition.x + blob.blobVelocity.x, blob.blobPosition.y + blob.blobVelocity.y + 25);
            blob.blobVelocity = ccp(blob.blobVelocity.x, abs(blob.blobVelocity.y));
            
            blob.interactable = FALSE;
            
            [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(changeInteraction:) userInfo:blob repeats:FALSE];
            
          */
            
            
        }
        //Hit the bottom
        else if (yIntersect - 5 <= electricSprite.boundingBox.origin.y)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
            if (blob.blobSize == LARGE_GLOB)
            {
                [self removeChild:blob.blobSprite];
                [largeSpritesheet removeChild:blob.blobSprite];
                
                blob.appeared = FALSE;
                
                [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                [self determineSpriteDirection:ccp(blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
            }
            else
            {
                [self removeChild:blob.blobSprite];
                blob.appeared = FALSE;
                blobScore ++;
            }
            
            /*
            //blob.blobSprite.position = ccp(blob.blobPosition.x + blob.blobVelocity.x, blob.blobPosition.y + blob.blobVelocity.y + 25);
            blob.blobVelocity = ccp(blob.blobVelocity.x, -1* abs(blob.blobVelocity.y));
            
            blob.interactable = FALSE;
            
            [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(changeInteraction:) userInfo:blob repeats:FALSE];
            */
          
            
        }
        //Hit the left
        else if (xIntersect <= electricSprite.boundingBox.origin.x)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
            //NSLog(@"hit the left");
            if (blob.blobSize == LARGE_GLOB)
            {
                [self removeChild:blob.blobSprite];
                [largeSpritesheet removeChild:blob.blobSprite];
                
                blob.appeared = FALSE;
                
                [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, blob.blobVelocity.y) position:blob.blobPosition];
            }
            else
            {
                [self removeChild:blob.blobSprite];
                blob.appeared = FALSE;
                blobScore ++;
            }
           
            /*
            //blob.blobSprite.position = ccp(blob.blobPosition.x + blob.blobVelocity.x, blob.blobPosition.y + blob.blobVelocity.y + 25);
            blob.blobVelocity = ccp(-1 * abs(blob.blobVelocity.x), blob.blobVelocity.y);
            
            blob.interactable = FALSE;
            
            [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(changeInteraction:) userInfo:blob repeats:FALSE];
             */
            
        }
        //Hit the right
        else 
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
           // NSLog(@"hit the left");
            if (blob.blobSize == LARGE_GLOB)
            {
                [self removeChild:blob.blobSprite];
                [largeSpritesheet removeChild:blob.blobSprite];
                
                blob.appeared = FALSE;
                
                [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, blob.blobVelocity.y) position:blob.blobPosition];
            }
            else
            {
                [self removeChild:blob.blobSprite];
                blob.appeared = FALSE;
                blobScore ++;
            }
            
            /*
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
            
            //blob.blobSprite.position = ccp(blob.blobPosition.x + blob.blobVelocity.x, blob.blobPosition.y + blob.blobVelocity.y + 25);
            blob.blobVelocity = ccp(abs(blob.blobVelocity.x), blob.blobVelocity.y);
            
            blob.interactable = FALSE;
            
            [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(changeInteraction:) userInfo:blob repeats:FALSE];
            */
           
        }
        
        
        [scoreLabel setString:[NSString stringWithFormat:@"%d/10", blobScore]];
        
        if (blobScore == 10)
        {
            [self winLoseGame:TRUE];
        }
        
        
    }
}

-(void)checkCollisionWithOtherBlob: (Blobs *)blob
{
    
    for (int i = 0; i < arrayOfSprites.count; i++)
    {
        Blobs *comparedBlob = [arrayOfSprites objectAtIndex:i];
        
        if (comparedBlob.appeared == FALSE)
        {
            continue;
        }
        else
        {
            if (comparedBlob != blob && CGRectIntersectsRect(blob.blobSprite.boundingBox, comparedBlob.blobSprite.boundingBox))
            {
               // NSLog(@"blobs intersected");
                
                if (comparedBlob.interactable == FALSE || blob.interactable == FALSE)
                {
                    return;
                }
                else if (blob.blobSize == SMALL_GLOB && comparedBlob.blobSize == SMALL_GLOB)
                {
                    CGPoint blob1Velocity = blob.blobVelocity;
                    CGPoint blob2Velocity = comparedBlob.blobVelocity;
                    
                    
                    int minX = MIN(blob1Velocity.x, blob2Velocity.x);
                    int maxX = MAX(blob1Velocity.x, blob1Velocity.x);
                    
                    int minY = MIN(blob1Velocity.y, blob2Velocity.y);
                    int maxY = MAX(blob1Velocity.y, blob2Velocity.y);
                    
                   // CGPoint newVelocity = ccp((maxX - minX) / 2, (maxY - minY) / 2);
                    
                    CGPoint newVelocity = ccp((maxX - minX)/2, (maxY - minY)/2);
                    
                 //   NSLog(@"min x = %d, max x = %d, min y = %d, max y = %d", minX, maxX, minY, maxY);
                    
                                        
                    for (Blobs *newGlob in arrayOfSprites)
                    {
                        if (newGlob.appeared == FALSE && newGlob.blobSize == LARGE_GLOB)
                        {
                            blob.appeared = FALSE;
                            comparedBlob.appeared = FALSE;
                            [self removeChild:blob.blobSprite];
                            [self removeChild:comparedBlob.blobSprite];
                            
                            newGlob.blobPosition = comparedBlob.blobPosition;
                            newGlob.blobVelocity = newVelocity;
                            
                            newGlob.appeared = TRUE;
                            
                            
                            //[self addChild:newGlob.blobSprite];
                            newGlob.blobSprite = [CCSprite spriteWithSpriteFrameName:@"sprite1.png"];
                            CCAnimation *largeBlueBlobAnimation = [CCAnimation animationWithSpriteFrames:largeSpriteAnim delay:0.1f];
                            CCRepeatForever * largeBlueBlobMovement = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:largeBlueBlobAnimation]];
                            [newGlob.blobSprite runAction:largeBlueBlobMovement];
                            [largeSpritesheet addChild:newGlob.blobSprite];
                            break;
                        }
                    }
                }
                else
                {
                    blob.blobVelocity = ccp(-1 * blob.blobVelocity.x, - 1 * blob.blobVelocity.y);
                    comparedBlob.blobVelocity = ccp(-1 * comparedBlob.blobVelocity.x, -1 * comparedBlob.blobVelocity.y);
                    
                    blob.interactable = FALSE;
                    comparedBlob.interactable = FALSE;
                    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(changeInteraction:) userInfo:blob repeats:FALSE];
                    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(changeInteraction:) userInfo:comparedBlob repeats:FALSE];
                    
                }
            }
        }
        
    }
    
}


-(void)changeInteraction: (NSTimer *)blobTimer
{
    Blobs *blob = [blobTimer userInfo];
    blob.interactable = TRUE;
    
    
    
}

-(void)pauseOrResume
{
    
   if (!pausePlay)
   {
       [[CCDirector sharedDirector] stopAnimation];
       [[CCDirector sharedDirector] pause];
       
       [gameTimer invalidate];
       
       
       gameTimer.paused = TRUE;
       
       pausePlay = TRUE;
   }
    else if (pausePlay)
    {
        [[CCDirector sharedDirector] stopAnimation]; // call this to make sure you don't start a second display link!
        [[CCDirector sharedDirector] resume];
        [[CCDirector sharedDirector] startAnimation];
        
         gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplay:)];
        [gameTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        gameTimer.paused = FALSE;
        pausePlay = FALSE;
    }
    
}

- (void) applicationDidEnterBackground:(UIApplication *)application
{
    
    pausePlay = FALSE;
    [self pauseOrResume];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    pausePlay = FALSE;
    [self pauseOrResume];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    pausePlay = TRUE;
    [self pauseOrResume];
}

-(void) winLoseGame: (BOOL)win
{
    
    if (win)
    {
        CCLabelTTF *winLabel = [CCLabelTTF labelWithString:@"YOU WIN!" fontName:@"Courier" fontSize:36.0];
        [winLabel setPosition:ccp(winSize.width/2, winSize.height/2)];
        [self addChild:winLabel z:20];
        
        [gameTimer invalidate];
        //[[CCDirector sharedDirector] stopAnimation];
    }
    else if (!win)
    {
        CCLabelTTF *winLabel = [CCLabelTTF labelWithString:@"YOU LOSE!" fontName:@"Courier" fontSize:36.0];
        [winLabel setPosition:ccp(winSize.width/2, winSize.height/2)];
        [self addChild:winLabel z:20];
        [gameTimer invalidate];
    }
}

-(void)determineSpriteDirection: (CGPoint ) velocity position: (CGPoint )position
{
    int count = 0;
    for (int i = 0; i < arrayOfSprites.count; i++)
    {
        
        
        for (Blobs *blob in arrayOfSprites)
        {
            
            if (blob.blobType == BLUE_GLOB && blob.blobSize == SMALL_GLOB && blob.appeared == FALSE)
            {
                count ++;
                blob.appeared = TRUE;
                [self addChild:blob.blobSprite];
                blob.blobPosition = position;
                blob.blobVelocity = velocity;
                blob.interactable = FALSE;
                [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(changeInteraction:) userInfo:blob repeats:FALSE];
                return;
            }
            
        }
        
        
    }
}


#pragma mark GameKit delegate


-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	//AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	//[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	//AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	//[[app navController] dismissModalViewControllerAnimated:YES];
}
 
@end
