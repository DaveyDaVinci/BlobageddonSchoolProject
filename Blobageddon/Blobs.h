//
//  Blobs.h
//  Blobageddon
//
//  Created by David Magee on 1/10/14.
//  Copyright (c) 2014 David Magee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define BLUE_GLOB 0
#define LARGE_GLOB 0
#define SMALL_GLOB 1

#define GLOB_SIZE 20.0
#define VIEW_WIDTH 290.0
#define VIEW_HEIGHT 530.0

@interface Blobs : NSObject
{

    CCSprite * blobSprite;
    int blobType;
    int blobSize;
    CGPoint blobVelocity;
    CGPoint blobPosition;
    
    CGFloat lastTime;
    CGFloat timeDelta;
    
    int blobTag;
    
    BOOL interactable;
    
    BOOL appeared;
}


@property CGPoint blobVelocity;
@property int blobType;
@property int blobSize;
@property BOOL interactable;
@property BOOL appeared;
@property (retain)CCSprite *blobSprite;
@property int blobTag;
@property CGPoint blobPosition;

-(id) initWithBlobType:(int)blobType blobSize:(int)blobSize startTime:(CGFloat)time velocity:(CGPoint)velocity location:(CGPoint)location blobInterract:(BOOL)interract tag:(int)tag appeared:(BOOL)appear;


-(void) updateModelWithTime:(CFTimeInterval)timeStamp;

-(CCSprite *)blobView;
@end
