//
//  Tutorial.m
//  ColouredStones
//
//  Created by Raúl Uranga on 5/25/11.
//  Copyright 2011 GrupoW. All rights reserved.
//

#import "Tutorial.h"
#import "GameScene.h"

@interface Tutorial (private)
-(BOOL) containsTouchLocation:(UITouch *)touch;
-(CGRect)rect;
-(void)removal;
@end

@implementation Tutorial

@synthesize theGame;
@synthesize state;
@synthesize back;
@synthesize label;

-(id)initWithText:(NSString *)text theGame:(GameScene *)game
{
	if ((self = [super init])) {
		self.theGame = game;
		[theGame addChild:self z:5];
		
		back = [CCSprite spriteWithFile:@"tutorialBackground.png"];
		[back setPosition:ccp(240,160)];
		[back setOpacity:0];
		[self addChild:back];
				
		label = [CCLabelTTF labelWithString:text 
							dimensions:CGSizeMake(270, 110) 
							alignment:UITextAlignmentLeft 
							fontName:@"Helvetica" 
							fontSize:12];
		
		[label setPosition:ccp(240,160)];
		[label setColor:ccBLACK];
		[label setOpacity:0];
		
		[self addChild:label];
		
		[back runAction:[CCFadeIn actionWithDuration:1]];
		[label runAction:[CCFadeIn actionWithDuration:1]];
		
		[theGame unschedule:@selector(drainTime)];
		theGame.allowTouch = NO;
		
		self.state = kStateUnGrabbed;
		
		
	}
	return self;
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

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{		
	//NSLog(@"Touch Began:%@", touch);
	if (state != kStateUnGrabbed) {
		return NO;
	}
	
	if (![self containsTouchLocation:touch]) {
		return NO;
	}
	
	state = kStateGrabbed;
	
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	//NSLog(@"Touch Moved:%@", touch);
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	//NSLog(@"Touch Ended:%@", touch);
	NSAssert(state == kStateGrabbed, @"error, it should ne always grabbed when we get here");
	
	[back runAction:[CCFadeOut actionWithDuration:1]];
	[label runAction:[CCFadeOut actionWithDuration:1]];
	
	[self schedule:@selector(removal) interval:1];

}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	//NSLog(@"Touch Cancelled:%@", touch);
}

#pragma mark-
#pragma mark private methods
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
	CGRect c = CGRectMake(self.back.position.x-(self.back.textureRect.size.width/2) * self.back.scaleX ,
						  self.back.position.y-(self.back.textureRect.size.height/2)* self.back.scaleY,
						  self.back.textureRect.size.width* self.back.scaleX,
						  self.back.textureRect.size.height * self.back.scaleY);
	return c;
}

-(void)removal
{
	[self unschedule:@selector(removal)];
	[theGame schedule:@selector(drainTime) interval:0.20];
	theGame.allowTouch = YES;
	[theGame removeChild:self cleanup:YES];
}


@end
