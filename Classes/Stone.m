//
//  Stone.m
//  ColouredStones
//
//  Created by Raúl Uranga on 5/17/11.
//  Copyright 2011 GrupoW. All rights reserved.
//

#import "GameScene.h"
#import "Stone.h"


@interface Stone (private)
-(BOOL) containsTouchLocation:(UITouch *)touch;
-(CGRect)rect;
@end


@implementation Stone

@synthesize mySprite;
@synthesize theGame;
@synthesize stoneType;
@synthesize curVGroup;
@synthesize curHGroup;
@synthesize state;
@synthesize disappearing;
@synthesize initDir;
@synthesize isSelected;

-(id) initWithGame:(GameScene *) game
{
	if ((self = [super init])) {
		self.theGame = game;
		[game addChild:self];
		self.state = kStateUnGrabbed;
	}
	return self;
}

-(void) placeInGrid:(CGPoint)place pt:(int)pt p1:(int)p1
{
	int sType = arc4random() % 4;
	
	if (sType == pt || sType == p1) {
		
		[self placeInGrid:place pt:pt p1:p1];
		
	} else {
		
		
		/*/
		NSString* color = [self setStoneColor:sType];
		mySprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"s%@.png",color]];
		[self addChild:mySprite z:1];
		/*/
		CCSpriteBatchNode * s = (CCSpriteBatchNode *)[theGame getChildByTag:kSSheet];
		mySprite = [CCSprite spriteWithBatchNode:s rect:[self setStoneColor:sType]];
		[s addChild:mySprite z:1];
		//*/
		
		[self setAnimation];
		
		
		self.stoneType = sType;
		[self.mySprite setPosition:place];
	}
}

-(void)setAnimation
{
	[self.mySprite stopAllActions];
	CCAnimation *animation;
	switch (self.stoneType) {
		case 0:
			break;
		case 1:
			
			//TODO: *** deprecated ***
			//animation =  [CCAnimation animationWithName:@"fBlue" delay:0.1f frames:theGame.blueFrames];
			
			animation = [CCAnimation animationWithFrames:theGame.blueFrames delay:0.1f];
			
			[self.mySprite runAction:[CCRepeatForever actionWithAction:
														[CCSequence actions:
															[CCDelayTime actionWithDuration:arc4random()%5],
															[CCAnimate actionWithAnimation:animation restoreOriginalFrame:0],
															nil] ]];

			break;
		case 2:
			break;
		case 3:
			break;
	}
}

/*/
-(NSString *) setStoneColor:(int) stoneT
{
	self.stoneType = stoneT;
	NSString *color;
	switch (self.stoneType) {
		case 0:
			color = @"Red";
			break;
		case 1:
			color = @"Blue";
			break;
		case 2:
			color = @"Yellow";
			break;
		case 3:
			color = @"Green";
			break;
	}
	return color;
}
/*/
-(CGRect)setStoneColor:(int)stoneT
{
	self.stoneType = stoneT;
	CGRect color;
	switch (self.stoneType) {
		case 0:
			color = CGRectMake(68,2,32,32);
			break;
		case 1:
			color = CGRectMake(132,2,32,32);
			break;
		case 2:
			color = CGRectMake(2,2,32,32);
			break;
		case 3:
			color = CGRectMake(100,2,32,32);
			break;
	}
	
	return color;
}
//*/
#pragma mark-
#pragma mark added/removed handlers

-(void)onEnter 
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

-(void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

#pragma mark-
#pragma mark touches handlers


// dispatcher methods:
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	
//	NSLog(@"state: %d",state);
//	NSLog(@"containsTouchLocation: %d",(int)[self containsTouchLocation:touch]);
//	NSLog(@"allowTouch: %d", (int)theGame.allowTouch);
	
	if (state != kStateUnGrabbed) {
		return NO;
	}
	
	if (![self containsTouchLocation:touch]) {
		return NO;
	}
	
	if (!theGame.allowTouch) {
		return NO;
	}
	
	NSLog(@"Touch Began");
	
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	self.initDir = location;
	
	state = kStateGrabbed;
	
	self.isSelected = YES;
	[self.mySprite setOpacity:100];
	
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	//NSLog(@"Touch Moved:%@", touch);
}




/*
 *	The preceding method has one problem.
 *	What happens if the user touches a stone and then wants to cancel? 
 *	He can't! Can you guess a way to solve that? I'll give you a hint:
 *	Try checking the positions of the centre of the touch stone and where the finger was lifted off.
 *	If the distance between them is a little one, you can avoid calling the swapStones method.
 *
 *  [To find out the distance between two CGPoints use the ccpDistance method, which takes two CGPoints as its parameters.]
 */

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSLog(@"Touch Ended");
	
	NSAssert(state == kStateGrabbed, @"Unexpected stage!!!");
	
	CGPoint location = [touch locationInView:[touch view]];
	
	//The CCDirector's convertToGL method takes the location of the touch
	//and changes it to match the current orientation the device was set to.
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	CGPoint aux = ccpNormalize(ccp(location.x-initDir.x,location.y-initDir.y));
	
	int dir = 0;
	
	//Depending on the type of your variable, one of abs(int), labs(long),
	//llabs(long long), imaxabs(intmax_t), fabsf(float), fabs(double), 
	//or fabsl(long double).
	
	if (fabsl(aux.x) >= fabsl(aux.y)) {
		if (aux.x >= 0) {
			dir = 1;
		}else {
			dir = 2;
		}

	} else {
		if (aux.y >= 0) {
			dir = 3;
		}else {
			dir = 4;
		}
	}
	
	self.isSelected=NO;
	[self.mySprite setOpacity:255];

	
	NSLog(@"ccTouchEnded: %d",dir);
	
	[theGame swapStones:self dir:dir];
	
	state = kStateUnGrabbed;
			
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	//NSLog(@"Touch Cancelled:%@", touch);
}

/*
 *	The containsTouchLocation method checks whether the user is really touching the object or somewhere else.
 *	It does so by calling the CGRectContainsPoint method,
 *	which checks if a touch is within the boundaries of a CGRect.
 */
- (BOOL)containsTouchLocation:(UITouch *)touch
{	
	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

/*
 *	The rect method returns a CGRect object representing the boundaries of the object.
 *	In this case, we are making a CGRect of the exact size of the stone's sprite,
 *	but you could make it bigger or smaller if you needed to.
 */
-(CGRect)rect
{
	CGRect c = CGRectMake(mySprite.position.x-(self.mySprite.textureRect.size.width/2) * self.mySprite.scaleX ,
						  mySprite.position.y-(self.mySprite.textureRect.size.height/2)* self.mySprite.scaleY,
						  self.mySprite.textureRect.size.width* self.mySprite.scaleX,
						  self.mySprite.textureRect.size.height * self.mySprite.scaleY);
	return c;
}

-(void)draw
{
	if(isSelected)
	{
		[self.mySprite setOpacity:100];
		glColor4ub(255, 0, 0, 100);
		glPointSize(30);
		ccDrawPoint( self.mySprite.position);
	}
}


@end
