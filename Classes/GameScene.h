//
//  HelloWorldLayer.h
//  ColouredStones
//
//  Created by Raúl Uranga on 5/17/11.
//  Copyright GrupoW 2011. All rights reserved.
//
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Stone.h"


#define GRID_WIDTH 8
#define GRID_HEIGHT 7
#define GRID_OFFSET ccp(158,35)
#define MAX_TIME 230
#define STONE_TYPES 4
#define MAX_TIME 230

#define kSSheet 1 
#define kGBack 2

@class Stone;

// HelloWorld Layer
@interface GameScene : CCLayer
{
	Stone *grid[8][7];
	int *int_grid[8][7];
	BOOL allowTouch;
	int score;
	int remainingTime;
	CCSprite* bar;
	int timeStatus;
}

@property (readwrite, assign)BOOL allowTouch;
@property (readwrite, assign)int score;
@property (readwrite, assign)int remainingTime;
@property (readwrite, assign)int timeStatus;
@property (nonatomic, retain)CCSprite* bar;


// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

-(id)init;
-(void)placeStones;
-(void)checkGroups:(bool)firstTime;
-(void)moveStonesDown;
-(void)swapStones:(Stone *) stone dir:(int)dir;
-(void)checkGroupsAgain;

@end
