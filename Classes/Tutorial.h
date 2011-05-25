//
//  Tutorial.h
//  ColouredStones
//
//  Created by Raúl Uranga on 5/25/11.
//  Copyright 2011 GrupoW. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "Global.h";

@class GameScene;


//TODO: <CCTargetedTouchDelegate> no esta marcado en el libro!!!
@interface Tutorial : CCNode <CCTargetedTouchDelegate> {
	
	GameScene *theGame;
	touchState state;
	CCSprite *back;
	CCLabelTTF *label;
	
}

@property (nonatomic, readwrite) touchState state;
@property (nonatomic, retain) GameScene *theGame;
@property (nonatomic, retain) CCSprite *back;
@property (nonatomic, retain) CCLabelTTF *label;

-(id)initWithText:(NSString *)text theGame:(GameScene *)game;

@end
