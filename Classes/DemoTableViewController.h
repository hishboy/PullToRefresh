//
//  RootViewController.h
//  PullToRefresh
//
//  Created by Leah Culver on 7/25/10.
//  Copyright Plancast 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBPullToRefreshTableViewController.h"

@interface DemoTableViewController : HBPullToRefreshTableViewController {
    NSMutableArray *items;
}

@end
