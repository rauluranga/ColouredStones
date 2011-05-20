//
//  ColouredStonesAppDelegate.h
//  ColouredStones
//
//  Created by Raúl Uranga on 5/17/11.
//  Copyright GrupoW 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ColouredStonesAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
