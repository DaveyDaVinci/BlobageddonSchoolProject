//
//  SaveLeaderboardScores.h
//  Blobageddon
//
//  Created by David Magee on 2/19/14.
//  Copyright (c) 2014 David Magee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SaveLeaderboardScores : NSObject
{
    NSString *dataBaseName;
}

-(id)init;

-(void)createOrLoadLeaderboard:(NSString *)userName score:(int)highScore;
-(NSMutableArray *)loadAllLeaderboardData;
-(void)saveToParse: (NSString *)username score:(int)finalScore;

-(NSMutableArray *)loadParseLeaderboardData;

@end
