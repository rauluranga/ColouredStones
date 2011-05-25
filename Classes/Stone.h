//
//  Stone.h
//  ColouredStones
//
//  Created by Raúl Uranga on 5/17/11.
//  Copyright 2011 GrupoW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Global.h"

@class GameScene;

@interface Stone : CCNode <CCTargetedTouchDelegate> {
	CCSprite *mySprite;
	GameScene *theGame;
	int stoneType;
	int curVGroup;
	int curHGroup;
	touchState state;
	BOOL disappearing;
	CGPoint initDir;
	BOOL isSelected;
}

@property (readwrite,nonatomic) touchState state;
@property (readwrite,nonatomic, retain) CCSprite *mySprite;
@property (readwrite,nonatomic, retain) GameScene *theGame;

@property (readwrite, assign) int stoneType;
@property (readwrite, assign) int curVGroup;
@property (readwrite, assign) int curHGroup;

@property (readwrite, assign) BOOL disappearing;
@property (readwrite, assign) CGPoint initDir;

@property(readwrite, assign)BOOL isSelected;

-(id) initWithGame:(GameScene *) game;
-(void) placeInGrid:(CGPoint)place pt:(int)pt p1:(int)p1;

//-(NSString *) setStoneColor:(int) stoneT;
-(CGRect)setStoneColor:(int)stoneT;
-(void)setAnimation;



@end
