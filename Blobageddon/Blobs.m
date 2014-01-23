//
//  Blobs.m
//  Blobageddon
//
//  Created by David Magee on 1/10/14.
//  Copyright (c) 2014 David Magee. All rights reserved.
//

#import "Blobs.h"

@implementation Blobs
@synthesize blobSize, blobSprite, blobType, blobVelocity, interactable, blobTag, blobPosition, appeared;


-(id) initWithBlobType:(int)type blobSize:(int)size startTime:(CGFloat)time velocity:(CGPoint)velocity location:(CGPoint)location blobInterract:(BOOL)interract tag:(int)tag appeared:(BOOL)appear
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
        appeared = appear;
        
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
  
    blobPosition = ccp(blobPosition.x + blobVelocity.x, blobPosition.y + blobVelocity.y);
     
}



@end
