//
//  GameScene.m
//  ColouredStones
//
//  Created by Raúl Uranga on 5/17/11.
//  Copyright GrupoW 2011. All rights reserved.
//

// Import the interfaces
#import "GameScene.h"


// GameScene implementation
@implementation GameScene

@synthesize score,allowTouch,remainingTime,bar;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		self.allowTouch = YES;
		
		CCSpriteBatchNode * sSheet = [CCSpriteBatchNode batchNodeWithFile:@"colouredSheet.png"];
		[self addChild:sSheet z:1 tag:kSSheet];
		/*/
		CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
		[self addChild:background z:0];
		/*/
		CCSprite *background = [CCSprite spriteWithBatchNode:sSheet rect:CGRectMake(504, 1,480,320)];
		[sSheet addChild:background z:0];
		//*/
		CGSize size = [[CCDirector sharedDirector] winSize];
		[background setPosition:ccp(size.width/2,size.height/2)];
		
		
		
		/*/
		CCSprite *gridBackground = [CCSprite spriteWithFile:@"grid.png"];
		[self addChild:gridBackground z:0];
		/*/
		CCSprite *gridBackground = [CCSprite spriteWithBatchNode:sSheet rect:CGRectMake(166, 1,337, 301)];
		[sSheet addChild:gridBackground z:0];
		//*/
		
		[gridBackground setPosition:ccp(305,160)];
		
		for(int i =0; i< GRID_WIDTH ; i++)
		{
			for(int j =0; j< GRID_HEIGHT ; j++)
			{
				Stone * s = [[Stone alloc]initWithGame:self];
				grid[i][j] = s;
				[s release];
			}
		}
		
		[self placeStones];
		
		remainingTime = MAX_TIME;
		
		bar = [CCSprite spriteWithFile:@"bar.png"];
		[self addChild:bar];
		[bar setPosition:ccp(113,25)];
		[bar setScaleY:remainingTime];
		[bar setAnchorPoint:ccp(0.5,0)];
		
		[self schedule:@selector(drainTime) interval:0.20];

		
	}
	return self;
}

-(void)drainTime
{
	if (remainingTime > 0) {
		remainingTime--;
	}
	
	[bar setScaleY:remainingTime];
	
	if (remainingTime <= 0) {
		score = 0;
		NSLog(@"You Lost!");
		remainingTime = MAX_TIME;
	}
}

-(void)changeTime:(int)time
{
	remainingTime += time;
	
	if (remainingTime > MAX_TIME) {
		
		remainingTime = MAX_TIME;
		
	} else if (remainingTime <= 0) {
		remainingTime = 0;
	}
}


-(void)placeStones
{
	for (int i=0; i<GRID_WIDTH; i++) {
		for (int j=0; j<GRID_HEIGHT; j++) {
			
			Stone *leftS = nil;
			Stone *leftMostS = nil;
			Stone *topS = nil;
			Stone *topMostS = nil;
			
			int prohibitedLeft = -1;
			int prohibitedTop = -1;
			
			if (i >= 2) {
				leftS = (Stone *) grid[i-1][j];
				leftMostS = (Stone *) grid[i-2][j];
			}
			
			if (j >= 2) {
				topS = (Stone *) grid[i][j-1];
				topMostS = (Stone *) grid[i][j-2];
			}
			
			if (leftS && leftMostS && leftS.stoneType == leftMostS.stoneType) {
				prohibitedLeft = leftS.stoneType;
			}
			
			if (topS && topMostS && topS.stoneType == topMostS.stoneType) {
				prohibitedTop = topS.stoneType;
			}
			
			[grid[i][j] placeInGrid:ccp(42*i + GRID_OFFSET.x, 42*j + GRID_OFFSET.y) pt:prohibitedTop p1:prohibitedLeft];
			
		}
	}
	
}

-(void)swapStones:(Stone *) stone dir:(int)dir
{
	
	NSLog(@"swapStones: %d", dir);
	
	for (int i=0; i<GRID_WIDTH; i++) {
		for (int j=0; j<GRID_HEIGHT; j++) {
			if (grid[i][j] == stone) {
				switch (dir) {
					case 1:
						
						if (i<GRID_WIDTH-1) {
							grid[i][j] = grid[i+1][j];
							grid[i+1][j] = stone;
							
							[grid[i][j].mySprite setPosition:ccp(42*i + GRID_OFFSET.x, 42*j + GRID_OFFSET.y)];
							[grid[i + 1][j].mySprite setPosition:ccp(42*(i+1) + GRID_OFFSET.x, 42*j + GRID_OFFSET.y)];

						}
						
						[self checkGroups:YES];
						
						return;
						break;
						
					case 2:
						
						if (i>0) {
							grid[i][j] = grid[i-1][j];
							grid[i-1][j] = stone;
							
							[grid[i][j].mySprite setPosition:ccp(42*i + GRID_OFFSET.x, 42*j + GRID_OFFSET.y)];
							[grid[i - 1][j].mySprite setPosition:ccp(42*(i-1) + GRID_OFFSET.x, 42*j + GRID_OFFSET.y)];
							
						}
						[self checkGroups:YES];
						return;
						break;
						
					case 3:
						
						if (j<GRID_HEIGHT-1) {
							grid[i][j] = grid[i][j+1];
							grid[i][j+1] = stone;
							
							[grid[i][j].mySprite setPosition:ccp(42*i + GRID_OFFSET.x, 42*j + GRID_OFFSET.y)];
							[grid[i][j+1].mySprite setPosition:ccp(42*(i) + GRID_OFFSET.x, 42*(j+1) + GRID_OFFSET.y)];
							
						}
						[self checkGroups:YES];
						return;
						break;
						
					case 4:
						
						if (j>0) {
							grid[i][j] = grid[i][j-1];
							grid[i][j-1] = stone;
							
							[grid[i][j].mySprite setPosition:ccp(42*i + GRID_OFFSET.x, 42*j + GRID_OFFSET.y)];
							[grid[i][j-1].mySprite setPosition:ccp(42*(i) + GRID_OFFSET.x, 42*(j-1) + GRID_OFFSET.y)];
							
						}
						[self checkGroups:YES];
						return;
						break;
				}
			}
		}
	}
}

-(void)checkGroups:(bool)firstTime
{
	int curHGroup = 0;
	int curVGroup = 0;
	int lastGroup = -1;
	
	NSMutableArray *groupings = [[NSMutableArray alloc] init];
	
	for (int i=0; i<GRID_WIDTH; i++) {
		for (int j=0; j<GRID_HEIGHT; j++) {
			
			Stone *d = (Stone *) grid[i][j];
			d.disappearing = NO;
			Stone *l = nil;
			Stone *t = nil;
			
			if (i>0) {
				l = grid[i-1][j];
			}
			
			if (j>0) {
				t = grid[i][j-1];
			}
			
			//Horizontal Grouping
			if (l && l.stoneType == d.stoneType) 
			{
				[[groupings objectAtIndex:l.curHGroup] addObject:grid[i][j]];
				grid[i][j].curHGroup = l.curHGroup;
				
			} else {
				curHGroup = lastGroup + 1;
				NSMutableSet *group = [[NSMutableSet alloc] init];
				[groupings addObject:group];
				[group release];
				[[groupings objectAtIndex:curHGroup] addObject:grid[i][j]];
				grid[i][j].curHGroup = curHGroup;
				lastGroup = curHGroup;
			}
			
			//Vertical Grouping
			if (t && t.stoneType == d.stoneType) {
				
				[[groupings objectAtIndex:t.curVGroup] addObject:grid[i][j]];
				grid[i][j].curVGroup = t.curVGroup;
			} else {
				curVGroup = lastGroup + 1;
				
				NSMutableSet * group2 = [[NSMutableSet alloc]init];
				[groupings addObject:group2];
				[group2 release];
				[[groupings objectAtIndex:curVGroup] addObject:grid[i][j]];
				grid[i][j].curVGroup = curVGroup;
				lastGroup = curVGroup;
				
			}
		}
	}
	
	
	BOOL moveStones = NO;
	for (NSMutableSet * n in groupings)  {
		if ([n count] >= 3) {
			for(Stone * c in n){
				c.disappearing = YES;
				moveStones = YES;
				[c.mySprite setOpacity:95];
				//[c.mySprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"sSmile.png"]];
				//[c.mySprite setTextureRect:CGRectMake(34, 2, 32, 32)];
				score += 100 * [n count]; 
				NSLog(@"Score: %d",score);
			}
		}
		
		if ([n count] >= 4) {
			[self changeTime:50];
		}
	}
	
	[groupings release];
	
	//[self unschedule:@selector(moveStonesDown)];
	
	if (moveStones) {
		//[self moveStonesDown];
		[self schedule:@selector(moveStonesDown) interval:1.0];
	}else {
		
		if (firstTime) {
			[self changeTime:-50];
		}
		
		self.allowTouch = YES;
	}
	
}

-(void)moveStonesDown
{
	[self unschedule:@selector(moveStonesDown)];
	
	self.allowTouch = NO;
	
	NSMutableArray * removeds = [[NSMutableArray alloc]init];
	
	for(int i =0; i< GRID_WIDTH ; i++)
	{
		int nilCount =0;
		for(int j =0; j< GRID_HEIGHT ; j++)
		{
			Stone * stone = grid[i][j];
			if(nilCount >0)
			{
				grid[i][j] = nil;
				grid[i][j -nilCount] = stone;
			}
			
			if(stone.disappearing)
			{
				nilCount ++;
				[removeds addObject:stone];
			}
			
			if(nilCount >0 && !stone.disappearing)
			{
				[stone.mySprite setPosition:ccp(42*i + GRID_OFFSET.x,42*(j-nilCount) + GRID_OFFSET.y)];
			}
		}
		
		int q =0;
		for(Stone * stone in removeds)
		{
			[stone.mySprite setOpacity:255];
			int stoneT = arc4random() % STONE_TYPES;
			
			/*/
			NSString* color = [stone setStoneColor:stoneT];
			[stone.mySprite setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"s%@.png",color]]];			
			/*/
			CGRect color =[stone setStoneColor:stoneT];
			[stone.mySprite setTextureRect:color];
			//*/
			[stone.mySprite setPosition:ccp(42*i + GRID_OFFSET.x,42*(GRID_HEIGHT -nilCount +q) + GRID_OFFSET.y)];
			
			grid[i][GRID_HEIGHT -nilCount +q] = stone;
			q++;
		}
		[removeds removeAllObjects];
	}
	[self schedule:@selector(checkGroupsAgain) interval:1.0];
}

-(void)checkGroupsAgain
{
	[self unschedule:@selector(checkGroupsAgain)];
	[self checkGroups:NO];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
