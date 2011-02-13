//
//  LongBranchAppDelegate.h
//  LongBranch
//
//  Created by Stefan Arentz on 11-02-13.
//  Copyright 2011 Arentz Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LongBranchViewController;

@interface LongBranchAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet LongBranchViewController *viewController;

@end
