//
//  HBDefaultPullToRefreshView.m
//
//  Created by Hicham Bouabdallah on 04/07/12 (Inspired by Leah Culver's PullRefreshTableViewController).
//  Copyright (c) 2012 Hicham Bouabdallah
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "HBDefaultPullToRefreshView.h"

@implementation HBDefaultPullToRefreshView
@synthesize refreshHeaderView;
@synthesize refreshLabel;
@synthesize refreshArrow;
@synthesize refreshSpinner;
@synthesize textPull;
@synthesize textRelease;
@synthesize textLoading;
@synthesize refreshAction;
@synthesize refreshTarget;

static const CGFloat kRefreshHeaderHeight = 52.0f;

-(id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 320, kRefreshHeaderHeight)];
    if (self) {
        self.textPull = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh...");
        self.textRelease = NSLocalizedString(@"Release to refresh...", @"Release to refresh...");
        self.textLoading = NSLocalizedString(@"Loading...", @"Loading...");
        
        self.refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - kRefreshHeaderHeight, 320, kRefreshHeaderHeight)];
        self.refreshHeaderView.backgroundColor = [UIColor clearColor];
        
        self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, kRefreshHeaderHeight)];
        self.refreshLabel.backgroundColor = [UIColor clearColor];
        self.refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
        self.refreshLabel.textAlignment = UITextAlignmentCenter;
        
        self.refreshArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]] autorelease];
        self.refreshArrow.frame = CGRectMake(floorf((kRefreshHeaderHeight - 27) / 2),
                                             (floorf(kRefreshHeaderHeight - 44) / 2),
                                             27, 44);
        
        self.refreshSpinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        self.refreshSpinner.frame = CGRectMake(floorf(floorf(kRefreshHeaderHeight - 20) / 2), floorf((kRefreshHeaderHeight - 20) / 2), 20, 20);
        self.refreshSpinner.hidesWhenStopped = YES;
        
        [self.refreshHeaderView addSubview:self.refreshLabel];
        [self.refreshHeaderView addSubview:self.refreshArrow];
        [self.refreshHeaderView addSubview:self.refreshSpinner];
        [self addSubview:self.refreshHeaderView];
    }
    return self;
}

- (void)dealloc {
    self.refreshHeaderView = nil;
    self.refreshLabel = nil;
    self.refreshArrow = nil;
    self.refreshSpinner = nil;
    self.textPull = nil;
    self.textRelease = nil;
    self.textLoading = nil;
    [super dealloc];
}

-(void)scrollingAboveView {
    self.refreshLabel.text = self.textRelease;
    [self.refreshArrow layer].transform = CATransform3DMakeRotation(-M_PI, 0, 0, 1);
}

-(void)scrollingInView {
    self.refreshLabel.text = self.textPull;
    [self.refreshArrow layer].transform = CATransform3DMakeRotation(-M_PI * 2, 0, 0, 1);    
}

-(void)setRefreshTarget:(id)t action:(SEL)a {
    self.refreshAction = a;
    self.refreshTarget = t;
}

-(void)refresh {
    if (!self.refreshAction || !self.refreshTarget) {
        NSLog(@"Missing refresh target or action. see (void)setRefereshTarget:(id)t action:(SEL)a");
    } else {
        [self.refreshTarget performSelector:refreshAction];
    }
}

-(void)tableWillBeganLoading {
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
}

-(void)tableDidEndLoading {
    self.refreshLabel.text = self.textPull;
    self.refreshArrow.hidden = NO;
    [self.refreshSpinner stopAnimating];
}

-(void)tableWillEndLoading {
    [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
}

@end