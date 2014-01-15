//
//  Blobs.m
//  Blobageddon
//
//  Created by David Magee on 1/10/14.
//  Copyright (c) 2014 David Magee. All rights reserved.
//

#import "Blobs.h"

@implementation Blobs
@synthesize blobSize, blobSprite, blobType, blobVelocity, interactable, blobTag, blobPosition;


-(id) initWithBlobType:(int)type blobSize:(int)size startTime:(CGFloat)time velocity:(CGPoint)velocity location:(CGPoint)location blobInterract:(BOOL)interract tag:(int)tag
{
    
    self = [super init];
    
    if (self)
    {
        
        
        blobTag = tag;
        blobType = type;
        blobSize = size;
        lastTime = time;
        blobVelocity = velocity;
        interactable = interract;
        blobPosition = location;
        
        blobSprite = [self blobView];
        
        
        
        
        
    }
    
    return self;
    
}


-(CCSprite *)blobView
{
    CCSprite *blob;
    if (blobType == BLUE_GLOB)
    {
        if (blobSize == LARGE_GLOB)
        {
           blob = [CCSprite spriteWithFile:@"sprite1.png"];
        }
        else if(blobSize == SMALL_GLOB)
        {
            blob = [CCSprite spriteWithFile:@"smallblob1.png"];
            
        }
    }
    
    return blob;
}

-(void) updateModelWithTime:(CFTimeInterval)timeStamp 
{
    
    
    /*
    if (lastTime == 0.0)
    {
        lastTime = timeStamp;
        
    }
    else
    {
        timeDelta = timeStamp - lastTime;
        
        lastTime = timeStamp;
        
        CGFloat x = blobVelocity.x;
        CGFloat y = blobVelocity.y;
        
        blobVelocity.x += x * timeDelta;
        blobVelocity.y += y * timeDelta;
        
       // blobVelocity = ccp(blobVelocity.x * timeDelta/100, blobVelocity.y * timeDelta/100);
       
        
    }
     */
    blobPosition = ccp(blobPosition.x + blobVelocity.x, blobPosition.y + blobVelocity.y);
    
   // NSLog(@"%f, %f", blobLocation.x, blobLocation.y);
        
        
        
        
        
        
        

    
    
    
}



@end
