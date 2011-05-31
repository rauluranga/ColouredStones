//
//  Global.h
//  ColouredStones
//
//  Created by Raúl Uranga on 5/25/11.
//  Copyright 2011 GrupoW. All rights reserved.
//

/*
#import "cocos2d.h"
#import "GameScene.h"
*/

#define GRID_WIDTH 8
#define GRID_HEIGHT 7
#define GRID_OFFSET ccp(158,35)
#define MAX_TIME 230
#define STONE_TYPES 4
#define MAX_TIME 230

#define kSSheet 1 
#define kGBack 2
#define kBack 3
#define kScoreLabel 4

typedef enum tagState {
	kStateGrabbed,
	kStateUnGrabbed
} touchState;

