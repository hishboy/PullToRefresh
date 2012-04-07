//
//  DemoPullToRefreshView.m
//  PullToRefresh
//
//  Created by Hicham Bouabdallah on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DemoPullToRefreshView.h"

@implementation DemoPullToRefreshView

- (id)init
{
    self = [super init];
    if (self) {
        self.refreshHeaderView.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

@end
