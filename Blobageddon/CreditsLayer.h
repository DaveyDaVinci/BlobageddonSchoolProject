//
//  CreditsLayer.h
//  Blobageddon
//
//  Created by David Magee on 1/29/14.
//  Copyright 2014 David Magee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SaveLeaderboardScores.h"

@interface CreditsLayer : CCLayer <UITableViewDataSource, UITableViewDelegate>
{
    CCSprite *backButton;
    
    CCSpriteBatchNode *smallSpriteNode;
    
    CCSprite *onlineButton;
    CCSprite *localButton;
    CCSprite *usernamesSortButton;
    CCSprite *highScoreSortButton;
    
    BOOL onlineButtonPressed;
    BOOL localButtonPressed;
    BOOL userNameButtonPressed;
    BOOL highScoreSortButtonPressed;
  
    
    BOOL buttonPressed;
    
    BOOL localShowing;
    
    NSMutableArray *localScores;
    NSMutableArray *onlineScores;
    
    SaveLeaderboardScores *saveObject;
    
    UITableView *tableView;
}
+(CCScene *) scene;
@end
