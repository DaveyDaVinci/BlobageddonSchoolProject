//
//  Achievements.h
//  Blobageddon
//
//  Created by David Magee on 2/25/14.
//  Copyright 2014 David Magee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Achievements : CCLayer <UITableViewDataSource, UITableViewDelegate>
{
    
    UITableView *tableView;
    
    NSMutableArray *arrayOfAchievements;
}





+(CCScene *) scene;
@end
