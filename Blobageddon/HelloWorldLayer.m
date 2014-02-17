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
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mediumzaps.wav"];
        
        self.touchEnabled = TRUE;
       
        //SpriteAnimationStuff
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spriteanimated.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"powerupsprites.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"powerupbox.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"wizardblobs.plist"];
      
        
        largeSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"spriteanimated.png"];
        [self addChild:largeSpritesheet];
        powerupSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"powerupsprites.png"];
        [self addChild:powerupSpriteSheet z:-10];
        powerUpBoxes = [CCSpriteBatchNode batchNodeWithFile:@"powerupbox.png"];
        [self addChild:powerUpBoxes z:30];
        wizardSpritesheet = [CCSpriteBatchNode batchNodeWithFile:@"wizardblobs.png"];
        [self addChild:wizardSpritesheet];
        
        
        arrayOfPowerups = [NSMutableArray array];
        
        /*
        CCSprite *fireman = [CCSprite spriteWithSpriteFrameName:@"FiremanHat.png"];
        CCSprite *crown = [CCSprite spriteWithSpriteFrameName:@"crown.png"];
        CCSprite *wizard = [CCSprite spriteWithSpriteFrameName:@"wizardhat.png"];
        CCSprite *zombie = [CCSprite spriteWithSpriteFrameName:@"zombiebandage.png"];
        
        [powerupSpriteSheet addChild:fireman];
        [powerupSpriteSheet addChild:crown];
        [powerupSpriteSheet addChild:wizard];
        [powerupSpriteSheet addChild:zombie];
        */
        
        
        Powerups *zombiePowerUp = [[Powerups alloc] initWithPowerupType:ZOMBIE position:[self randomPoint] velocity:ccp(0,0) appeared:FALSE interactive:FALSE collected:FALSE];
        zombiePowerUp.powerUpSprite = [CCSprite spriteWithSpriteFrameName:@"zombiebandage.png"];
        //[powerupSpriteSheet addChild:zombiePowerUp.powerUpSprite];
        [arrayOfPowerups addObject:zombiePowerUp];
        
        Powerups *queenPowerUp = [[Powerups alloc] initWithPowerupType:QUEEN position:[self randomPoint] velocity:ccp(0,0) appeared:FALSE interactive:FALSE collected:FALSE];
        queenPowerUp.powerUpSprite = [CCSprite spriteWithSpriteFrameName:@"crown.png"];
        //[powerupSpriteSheet addChild:queenPowerUp.powerUpSprite];
        [arrayOfPowerups addObject:queenPowerUp];
        
        Powerups *wizardPowerUp = [[Powerups alloc] initWithPowerupType:WIZARD position:[self randomPoint] velocity:ccp(0,0) appeared:FALSE interactive:FALSE collected:FALSE];
        wizardPowerUp.powerUpSprite = [CCSprite spriteWithSpriteFrameName:@"wizardhat.png"];
        //[powerupSpriteSheet addChild:wizardPowerUp.powerUpSprite];
        [arrayOfPowerups addObject:wizardPowerUp];
        
        Powerups *firemanPowerUp = [[Powerups alloc] initWithPowerupType:FIREMAN position:[self randomPoint] velocity:ccp(0,0) appeared:FALSE interactive:FALSE collected:FALSE];
        firemanPowerUp.powerUpSprite = [CCSprite spriteWithSpriteFrameName:@"FiremanHat.png"];
        //[powerupSpriteSheet addChild:firemanPowerUp.powerUpSprite];
        [arrayOfPowerups addObject:firemanPowerUp];
       
        
        largeSpriteAnim = [NSMutableArray array];
        for (int i = 1;  i <= 3; i++)
        {
            [largeSpriteAnim addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                                        [NSString stringWithFormat:@"sprite%d.png", i]]];
        }
        
        
        
        
        
        //ElectricSprite Creation
        electricSprite = [CCSprite spriteWithFile:@"electric.png"];
        
        electricSprite.position = ccp(winSize.width/2 + (winSize.width/3), winSize.height/2 + (electricSprite.scaleY/2));
        electricSprite.tag = 0;
        
        
        [self addChild:electricSprite];
        
        
        
        
        
        //Button creation
        pausePlayButton = [CCSprite spriteWithFile:@"pausebutton.png"];
        pausePlayButton.position = ccp(winSize.width - (pausePlayButton.boundingBox.size.width * .3), 0 + (pausePlayButton.boundingBox.size.height * .3));
        pausePlayButton.scale = .4;
        [self addChild:pausePlayButton z:100];
        pausePlay = FALSE;
        
        
        loseButton = [CCSprite spriteWithFile:@"lose.png"];
        loseButton.position = ccp(40, winSize.height/10 * 9);
        loseButton.scale = .4;
        [self addChild:loseButton z:100];
        
        largeBlobsAppeared = 0;
        
        for (int i = 0; i < 50; i++)
        {
            Blobs *largeBlob = [[Blobs alloc] initWithBlobType:BLUE_GLOB blobSize:LARGE_GLOB startTime:0.0 velocity:ccp(0, 0) location:ccp(40, 90) blobInterract:TRUE tag:i appeared:FALSE];
            
            largeBlob.blobPosition = [self randomPoint];
            
            
            
            Blobs *smallBlob = [[Blobs alloc] initWithBlobType:BLUE_GLOB blobSize:SMALL_GLOB startTime:0.0 velocity:ccp(0, 0) location:ccp(75, winSize.height/3) blobInterract:TRUE tag:i + 50 appeared:FALSE];
            
            [arrayOfSprites addObject:smallBlob];
            
            /*
            if (largeBlob.blobTag <= 5)
            {
                largeBlob.appeared = TRUE;
                int randomX = arc4random() % abs(electricSprite.boundingBox.origin.x - 70);
                int randomY = arc4random() % abs(winSize.height);
                
                 largeBlob.blobPosition = ccp(randomX, randomY);
                
               
            }
             */
            
            [arrayOfSprites addObject:largeBlob];
        }
        
        /*
        for (Blobs *blob in arrayOfSprites)
        {
          
            if (blob.appeared == TRUE)
            {
                if (blob.blobSize == LARGE_GLOB)
                {
                    
                    blob.blobSprite = [CCSprite spriteWithSpriteFrameName:@"sprite1.png"];
                    blob.blobSprite.position = blob.blobPosition;
                    CCAnimation *largeBlueBlobAnimation = [CCAnimation animationWithSpriteFrames:largeSpriteAnim delay:0.1f];
                    CCRepeatForever * largeBlueBlobMovement = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:largeBlueBlobAnimation]];
                    [blob.blobSprite runAction:largeBlueBlobMovement];
                    [largeSpritesheet addChild:blob.blobSprite];
                  
                }
                else if (blob.blobSize == SMALL_GLOB)
                {
                    [self addChild:blob.blobSprite];
                    blob.blobSprite.position = blob.blobPosition;
                }
            }
            
            
        }
         */
        
        
        //Creates a cadisplaylink timers that will update the display every time the screen refreshes
       gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplay:)];
        
        //adds loop
       [gameTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        blobScore = 0;
        
        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d/10", blobScore] fontName: @"Courier" fontSize:20.0];
        [scoreLabel setPosition:ccp(winSize.width - 40, winSize.height - 30)];
        [self addChild:scoreLabel z:20];
        
        
        
        
        wizardPowerUpBox = [CCSprite spriteWithSpriteFrameName:@"powerupspotsmall.png"];
        wizardPowerUpBox.position = ccp(winSize.width/6, winSize.height / 9);
        [powerUpBoxes addChild:wizardPowerUpBox z:10];
        
        globalBlobType = BLUE_GLOB;
        
        wizardPowerUpUsed = FALSE;
        
        timeKeep = 0;
        gameWinTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gameWinTimer) userInfo:nil repeats:TRUE];
        timerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Time: 0"] fontName: @"Courier" fontSize:20.0];
        [timerLabel setPosition:ccp(winSize.width/2, winSize.height - 30)];
        [self addChild:timerLabel  z:20];
        
        
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
    
    
    int random = arc4random() % 300;
    if (random == 25)
    {
       
        Powerups *wizard = [arrayOfPowerups objectAtIndex:2];
        
        if (wizard.spriteAppeared == FALSE && wizard.spriteCollected == FALSE)
        {
            wizard.spriteAppeared = TRUE;
            [powerupSpriteSheet addChild:wizard.powerUpSprite z:-10];
            wizard.powerUpSprite.position = wizard.spriteLocation;
            
            [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(changePowerupInteraction:) userInfo:wizard repeats:FALSE];
            wizardPowerupTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(removePowerupFromScreen:) userInfo:wizard repeats:FALSE];
            wizard.spriteVelocity = [self randomVelocity:wizard.spriteLocation];
        }
                
        
        
    }
    else if (random > 30 && random < 35)
    {
        NSLog(@"random hit");
        
        if (largeBlobsAppeared < 25)
        {
            largeBlobsAppeared ++;
            for (Blobs *blob in arrayOfSprites)
            {
                if (blob.appeared == FALSE)
                {
                    
                    blob.appeared = TRUE;
                    blob.blobPosition = [self randomPoint];
                    blob.blobVelocity = [self randomVelocity:blob.blobPosition];
                    
                    blob.blobSprite = [CCSprite spriteWithSpriteFrameName:@"sprite1.png"];
                    blob.blobSprite.position = blob.blobPosition;
                    CCAnimation *largeBlueBlobAnimation = [CCAnimation animationWithSpriteFrames:largeSpriteAnim delay:0.1f];
                    CCRepeatForever * largeBlueBlobMovement = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:largeBlueBlobAnimation]];
                    [blob.blobSprite runAction:largeBlueBlobMovement];
                    [largeSpritesheet addChild:blob.blobSprite];
                    
                    return;
                }
            }
        }
        
    }


    for (Powerups *powerup in arrayOfPowerups)
    {
        if (powerup.spriteAppeared == TRUE)
        {
            [powerup updateLocation];
            powerup.powerUpSprite.position = ccp(powerup.spriteLocation.x + powerup.spriteVelocity.x, powerup.spriteLocation.y + powerup.spriteVelocity.y);
            
            if (powerup.spriteInteractive == TRUE)
            {
                [self checkPowerupCollisionWithScreenEdges:powerup];
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
        [self winLoseGame];
    }
    
    if (CGRectContainsPoint(wizardPowerUpBox.boundingBox, location))
    {
        if (wizardPowerUpUsed != TRUE && wizardPowerUpCollected == TRUE)
        {
            tappedWizardPowerup = TRUE;
        }
        
    }
    
    
    for (Powerups *powerup in arrayOfPowerups)
    {
        if (CGRectContainsPoint(powerup.powerUpSprite.boundingBox, location))
        {
            
            wizardPowerUpCollected = TRUE;
            if (powerup.spriteCollected == FALSE)
            {
                powerup.spriteCollected = TRUE;
                powerup.spriteAppeared = FALSE;
                powerup.spriteVelocity = ccp(0,0);
                
                [wizardPowerupTimer invalidate];
                [powerupSpriteSheet removeChild:powerup.powerUpSprite];
                
                CGPoint wizardLoc = wizardPowerUpBox.position;
                [powerUpBoxes removeChild:wizardPowerUpBox];
                
                wizardPowerUpBox = [CCSprite spriteWithSpriteFrameName:@"powerupwithwizhat.png"];
                wizardPowerUpBox.position = wizardLoc;
                [powerUpBoxes addChild:wizardPowerUpBox];
                
                 //powerup.powerUpSprite.position = ccp(wizardPowerUpBox.position.x, wizardPowerUpBox.position.y);
               // [powerupSpriteSheet addChild:powerup.powerUpSprite];
                
                
               
                
                
            }
            
            
        }
     
    }
    
    
    for (Blobs *blob in arrayOfSprites)
    {
        if (CGRectContainsPoint(blob.blobSprite.boundingBox, location))
        {
            
            swipedGlob = TRUE;
            
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
    
    if (tappedWizardPowerup == TRUE)
    {
        wizardPowerUpCollected = FALSE;
        tappedWizardPowerup = FALSE;
        globalBlobType = WIZARD_GLOB;
        [self changeGlobType:WIZARD_GLOB];
        [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(revertToBlue:) userInfo:[NSNumber numberWithInt:WIZARD_GLOB] repeats:FALSE];
        CGPoint powerUpLocation = wizardPowerUpBox.position;
        [powerUpBoxes removeChild:wizardPowerUpBox];
    
        wizardPowerUpBox = [CCSprite spriteWithSpriteFrameName:@"powerupspotsmall.png"];
        wizardPowerUpBox.position = powerUpLocation;
        [powerUpBoxes addChild:wizardPowerUpBox];
        wizardPowerUpUsed = TRUE;
        
        
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
                if (blob.blobType == BLUE_GLOB)
                {
                    // Blobs *smallBlob1;
                    //Blobs *smallBlob2;
                    [self removeChild:blob.blobSprite];
                    [largeSpritesheet removeChild:blob.blobSprite];
                    
                    blob.appeared = FALSE;
                    
                    [self determineSpriteDirection:ccp(blob.blobVelocity.x, - 1 * blob.blobVelocity.y) position:blob.blobPosition];
                    [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                }
                else if (blob.blobType == WIZARD_GLOB)
                {
                    [self removeChild:blob.blobSprite];
                    [wizardSpritesheet removeChild:blob.blobSprite];
                    
                    blob.appeared = FALSE;
                    
                    [self determineSpriteDirection:ccp(blob.blobVelocity.x, - 1 * blob.blobVelocity.y) position:blob.blobPosition];
                    [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                }
                
                largeBlobsAppeared --;
        
                
            }
            else
            {
                [self removeChild:blob.blobSprite];
                blob.appeared = FALSE;
                blobScore ++;
            }
            
        }
        //Hit the bottom
        else if (yIntersect - 5 <= electricSprite.boundingBox.origin.y)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
            if (blob.blobSize == LARGE_GLOB)
            {
                if (blob.blobType == BLUE_GLOB)
                {
                    [self removeChild:blob.blobSprite];
                    [largeSpritesheet removeChild:blob.blobSprite];
                    
                    blob.appeared = FALSE;
                    
                    [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                    [self determineSpriteDirection:ccp(blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                }
                else if (blob.blobType == WIZARD_GLOB)
                {
                    [self removeChild:blob.blobSprite];
                    [wizardSpritesheet removeChild:blob.blobSprite];
                    
                    blob.appeared = FALSE;
                    
                    [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                    [self determineSpriteDirection:ccp(blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                }
                largeBlobsAppeared --;
                
            }
            else
            {
                [self removeChild:blob.blobSprite];
                blob.appeared = FALSE;
                blobScore ++;
            }
           
          
            
        }
        //Hit the left
        else if (xIntersect <= electricSprite.boundingBox.origin.x)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
            //NSLog(@"hit the left");
            if (blob.blobSize == LARGE_GLOB)
            {
                
                if (blob.blobType == BLUE_GLOB)
                {
                    [self removeChild:blob.blobSprite];
                    [largeSpritesheet removeChild:blob.blobSprite];
                    
                    blob.appeared = FALSE;
                    
                    [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                    [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, blob.blobVelocity.y) position:blob.blobPosition];
                }
                else if (blob.blobType == WIZARD_GLOB)
                {
                    [self removeChild:blob.blobSprite];
                    [wizardSpritesheet removeChild:blob.blobSprite];
                    
                    blob.appeared = FALSE;
                    
                    [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                    [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, blob.blobVelocity.y) position:blob.blobPosition];
                }
                largeBlobsAppeared --;
                
            }
            else
            {
                [self removeChild:blob.blobSprite];
                blob.appeared = FALSE;
                blobScore ++;
            }
           
        }
        //Hit the right
        else 
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"splat.wav"];
          
            if (blob.blobSize == LARGE_GLOB)
            {
                
                if(blob.blobType == BLUE_GLOB)
                {
                    [self removeChild:blob.blobSprite];
                    [largeSpritesheet removeChild:blob.blobSprite];
                    
                    blob.appeared = FALSE;
                    
                    [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                    [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, blob.blobVelocity.y) position:blob.blobPosition];
                }
                else if (blob.blobType == WIZARD_GLOB)
                {
                    [self removeChild:blob.blobSprite];
                    [wizardSpritesheet removeChild:blob.blobSprite];
                    
                    blob.appeared = FALSE;
                    
                    [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, -1 * blob.blobVelocity.y) position:blob.blobPosition];
                    [self determineSpriteDirection:ccp(-1 * blob.blobVelocity.x, blob.blobVelocity.y) position:blob.blobPosition];
                }
                largeBlobsAppeared --;
                
            }
            else
            {
                [self removeChild:blob.blobSprite];
                blob.appeared = FALSE;
                blobScore ++;
            }
           
           
        }
        
        
        [scoreLabel setString:[NSString stringWithFormat:@"%d/10", blobScore]];
        
        /*
        if (blobScore == 10)
        {
            [self winLoseGame:TRUE];
        }
        */
        
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
                    
                    CGPoint newVelocity = ccp((maxX - minX)/2, (maxY - minY)/2);
                    
                    largeBlobsAppeared ++;
                                        
                    for (Blobs *newGlob in arrayOfSprites)
                    {
                        if (newGlob.appeared == FALSE && newGlob.blobSize == LARGE_GLOB)
                        {
                            
                            if (globalBlobType == BLUE_GLOB)
                            {
                                blob.appeared = FALSE;
                                comparedBlob.appeared = FALSE;
                                [self removeChild:blob.blobSprite];
                                [self removeChild:comparedBlob.blobSprite];
                                
                                newGlob.blobPosition = comparedBlob.blobPosition;
                                newGlob.blobVelocity = newVelocity;
                                
                                newGlob.appeared = TRUE;
                                
                                newGlob.blobSprite = [CCSprite spriteWithSpriteFrameName:@"sprite1.png"];
                                CCAnimation *largeBlueBlobAnimation = [CCAnimation animationWithSpriteFrames:largeSpriteAnim delay:0.1f];
                                CCRepeatForever * largeBlueBlobMovement = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:largeBlueBlobAnimation]];
                                [newGlob.blobSprite runAction:largeBlueBlobMovement];
                                [largeSpritesheet addChild:newGlob.blobSprite];
                                break;
                            }
                            else if (globalBlobType == WIZARD_GLOB)
                            {
                                blob.appeared = FALSE;
                                comparedBlob.appeared = FALSE;
                                [self removeChild:blob.blobSprite];
                                [self removeChild:comparedBlob.blobSprite];
                                
                                newGlob.blobPosition = comparedBlob.blobPosition;
                                newGlob.blobVelocity = newVelocity;
                                
                                newGlob.appeared = TRUE;
                                newGlob.blobType = WIZARD_GLOB;
                                
                                newGlob.blobSprite = [CCSprite spriteWithSpriteFrameName:@"wizard.png"];
                                
                                [wizardSpritesheet addChild:newGlob.blobSprite];
                                break;
                            }
                            
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

-(void) winLoseGame
{
    if (blobScore >= 30)
    {
        CCLabelTTF *winLabel = [CCLabelTTF labelWithString:@"YOU WIN!" fontName:@"Courier" fontSize:36.0];
        [winLabel setPosition:ccp(winSize.width/2, winSize.height/2)];
        [self addChild:winLabel z:20];
        
        if (wizardPowerUpUsed == FALSE)
        {
            CCLabelTTF *powerUPLabel = [CCLabelTTF labelWithString:@"Power Up Bonus: 100" fontName:@"Courier" fontSize:28.0];
            [powerUPLabel setPosition:ccp(winSize.width/2, winSize.height/3)];
            [self addChild:powerUPLabel z:20];
        }
        else
        {
            CCLabelTTF *powerUPLabel = [CCLabelTTF labelWithString:@"Power Up Bonus: 0" fontName:@"Courier" fontSize:28.0];
            [powerUPLabel setPosition:ccp(winSize.width/2, winSize.height/3)];
            [self addChild:powerUPLabel z:20];
        }
        
        [gameTimer invalidate];
        [gameWinTimer invalidate];
    }
    else
    {
        CCLabelTTF *winLabel = [CCLabelTTF labelWithString:@"YOU LOSE!" fontName:@"Courier" fontSize:36.0];
        [winLabel setPosition:ccp(winSize.width/2, winSize.height/2)];
        [self addChild:winLabel z:20];
        [gameTimer invalidate];
        [gameWinTimer invalidate];
        
    }
    
    /*
    if (win)
    {
        CCLabelTTF *winLabel = [CCLabelTTF labelWithString:@"YOU WIN!" fontName:@"Courier" fontSize:36.0];
        [winLabel setPosition:ccp(winSize.width/2, winSize.height/2)];
        [self addChild:winLabel z:20];
        
        if (wizardPowerUpUsed == FALSE)
        {
            CCLabelTTF *powerUPLabel = [CCLabelTTF labelWithString:@"Power Up Bonus: 100" fontName:@"Courier" fontSize:28.0];
            [powerUPLabel setPosition:ccp(winSize.width/2, winSize.height/3)];
            [self addChild:powerUPLabel z:20];
        }
        else
        {
            CCLabelTTF *powerUPLabel = [CCLabelTTF labelWithString:@"Power Up Bonus: 0" fontName:@"Courier" fontSize:28.0];
            [powerUPLabel setPosition:ccp(winSize.width/2, winSize.height/3)];
            [self addChild:powerUPLabel z:20];
        }
        
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
    */
}

-(void)determineSpriteDirection: (CGPoint ) velocity position: (CGPoint )position
{
    int count = 0;
    for (int i = 0; i < arrayOfSprites.count; i++)
    {
        
        
        for (Blobs *blob in arrayOfSprites)
        {
            
            if (/*blob.blobType == BLUE_GLOB && */ blob.blobSize == SMALL_GLOB && blob.appeared == FALSE)
            {
                if (globalBlobType == BLUE_GLOB)
                {
                    count ++;
                    blob.appeared = TRUE;
                    blob.blobType = globalBlobType;
                    blob.blobSprite = [CCSprite spriteWithFile:@"smallblob1.png"];
                    [self addChild:blob.blobSprite];
                    blob.blobPosition = position;
                    blob.blobVelocity = velocity;
                    blob.interactable = FALSE;
                    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(changeInteraction:) userInfo:blob repeats:FALSE];
                    return;
                }
                else if (globalBlobType == WIZARD_GLOB)
                {
                    count ++;
                    blob.appeared = TRUE;
                    blob.blobSprite = [CCSprite spriteWithFile:@"smallwizardblob.png"];
                    blob.blobType = globalBlobType;
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
}


-(CGPoint)randomPoint
{
    CGPoint randomPoint;
    float lowX = -50;
    float highX = winSize.width + 50;
    
    float rndValueX = (((float)arc4random()/0x100000000)*(highX - lowX)+ lowX);
    float rndValueY;
    
    //If the value of rndx is outside the bounds of the screen, we'll want the rnd y to be within borders
    if (rndValueX > winSize.width && rndValueX < 0)
    {
        float lowY = 0;
        float highY = winSize.height;
        rndValueY = (((float)arc4random()/0x100000000)*(highY - lowY)+ lowY);
    }
    else
    {
        int random = arc4random() % 100;
        if (random >= 50)
        {
            float lowY = -50;
            float highY = 0;
            rndValueY = (((float)arc4random()/0x100000000)*(highY - lowY)+ lowY);
        }
        else
        {
            float lowY = winSize.height;
            float highY = winSize.height + 50;
            rndValueY = (((float)arc4random()/0x100000000)*(highY - lowY)+ lowY);
        }
    }
    
    randomPoint = ccp(rndValueX, rndValueY);
    
    return randomPoint;
}

-(CGPoint)randomVelocity: (CGPoint)position
{
    float x;
    float y;
    
    CGPoint velocity;
    
    if (position.x < winSize.width / 2)
    {
        x = (arc4random() % 5) +1;
        x = x / 2;
    }
    else
    {
        x = (arc4random() % 5) + 1;
        x = x * -1;
        x = x / 2;
    }
    
    if (position.y < winSize.height /2)
    {
        y = (arc4random() % 5) + 1;
        y = y / 2;
    }
    else
    {
        y = (arc4random() % 5) + 1;
        y = y * -1;
        y = y / 2;
    }
    
    velocity = ccp(x, y);
    
    return velocity;
}



-(void)checkPowerupCollisionWithScreenEdges: (Powerups *)powerUp
{
    
    
    if (powerUp.powerUpSprite.position.y  >= winSize.height)
    {
        // NSLog(@"Hit at top");
        CGFloat x = powerUp.spriteVelocity.x;
        CGFloat y = powerUp.spriteVelocity.y;
        
        powerUp.spriteVelocity = ccp(x, -1 * abs(y));
        
        
    }
    else if (powerUp.powerUpSprite.position.y <= 0)
    {
        //  NSLog(@"Hit bottom");
        CGFloat x = powerUp.spriteVelocity.x;
        CGFloat y = powerUp.spriteVelocity.y;
        
       powerUp.spriteVelocity = ccp(x, abs(y));
        
        
        
    }
    else if (powerUp.powerUpSprite.position.x >= winSize.width)
    {
        // NSLog(@"Hit right");
        CGFloat x = powerUp.spriteVelocity.x;
        CGFloat y = powerUp.spriteVelocity.y;
        
        powerUp.spriteVelocity = ccp(-1 * abs(x), y);
        
        
    }
    else if (powerUp.powerUpSprite.position.x <= 0)
    {
        // NSLog(@"hit left");
        CGFloat x = powerUp.spriteVelocity.x;
        CGFloat y = powerUp.spriteVelocity.y;
        
        powerUp.spriteVelocity = ccp(abs(x), y);
        
        
    }
    
}

-(void)changePowerupInteraction: (NSTimer *)powerUpTimer
{
    Powerups *powerup = [powerUpTimer userInfo];
    powerup.spriteInteractive = TRUE;
    
    
    
}


-(void)removePowerupFromScreen: (NSTimer *)powerUpTimer
{
    
    Powerups *powerup = [powerUpTimer userInfo];
    
        powerup.spriteInteractive = FALSE;
        powerup.spriteAppeared = FALSE;
        [powerupSpriteSheet removeChild:powerup.powerUpSprite];
    
    
}



-(void)changeGlobType: (int)blobType
{
    for (Blobs *blob in arrayOfSprites)
    {
        if (blob.appeared == TRUE)
        {
            blob.blobType = WIZARD_GLOB;
            if (blobType == WIZARD_GLOB)
            {
                
                
                if (blob.blobSize == LARGE_GLOB)
                {
                    [largeSpritesheet removeChild:blob.blobSprite];
                    blob.blobSprite = [CCSprite spriteWithSpriteFrameName:@"wizard.png"];
                    blob.blobSprite.position = blob.blobPosition;
                    [wizardSpritesheet addChild:blob.blobSprite];
                    
                }
                else if (blob.blobSize == SMALL_GLOB)
                {
                    [self removeChild:blob.blobSprite];
                    blob.blobSprite = [CCSprite spriteWithFile:@"smallwizardblob.png"];
                    [self addChild:blob.blobSprite];
                }
            }
            
                     
        }
    }
}

-(void)revertToBlue: (NSTimer *)blobType
{
    int type = [[blobType userInfo] intValue];
    if (type == WIZARD_GLOB)
    {
        for (Blobs *blob in arrayOfSprites)
        {
            
            blob.blobType = BLUE_GLOB;
            
            /*
            if (blob.blobSize == LARGE_GLOB)
            {
                blob.blobType = BLUE_GLOB;
                blob.blobSprite = [CCSprite spriteWithSpriteFrameName:@"sprite1.png"];
                if (blob.appeared == TRUE)
                {
                    
                }
            }
            else if (blob.blobSize == SMALL_GLOB)
            {
                blob.blobType = BLUE_GLOB;
                blob.blobSprite = [CCSprite spriteWithFile:@"smallblob1.png"];
                if (blob.appeared == TRUE)
                {
                    [self removeChild:blob.blobSprite];
                    //blob.blobType = BLUE_GLOB;
                    //blob.blobSprite = [CCSprite spriteWithFile:@"smallblob1.png"];
                    [self addChild:blob.blobSprite];
                }
            }
             */
            
            if (blob.appeared == TRUE)
            {
                
                    if (blob.blobSize == LARGE_GLOB)
                    {
                        
                        [wizardSpritesheet removeChild:blob.blobSprite];
                        blob.blobType = BLUE_GLOB;
                        blob.blobSprite = [CCSprite spriteWithSpriteFrameName:@"sprite1.png"];
                        CCAnimation *largeBlueBlobAnimation = [CCAnimation animationWithSpriteFrames:largeSpriteAnim delay:0.1f];
                        CCRepeatForever * largeBlueBlobMovement = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:largeBlueBlobAnimation]];
                        [blob.blobSprite runAction:largeBlueBlobMovement];
                        [largeSpritesheet addChild:blob.blobSprite];
             
             
                    }
                    else if (blob.blobSize == SMALL_GLOB)
                    {
                        [self removeChild:blob.blobSprite];
                        blob.blobType = BLUE_GLOB;
                        blob.blobSprite = [CCSprite spriteWithFile:@"smallblob1.png"];
                        [self addChild:blob.blobSprite];
                    }
             
                   
                
            }
             
        }
    }
    globalBlobType = BLUE_GLOB;
}

-(void)gameWinTimer
{
    timeKeep ++;
    [timerLabel setString:[NSString stringWithFormat:@"Time: %d", timeKeep]];
    NSLog(@"%d", largeBlobsAppeared);
    if (timeKeep == 60)
    {
        [self winLoseGame];
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
