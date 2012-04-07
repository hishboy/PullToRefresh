//
//  HBPullToRefreshTableViewController.m
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

#import "HBPullToRefreshTableViewController.h"

@interface HBPullToRefreshTableViewController(Private)
- (void)setup;
- (void)addPullToRefreshHeader;
- (void)removePullToRefreshHeader;
- (void)refresh;
- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end

@implementation HBPullToRefreshTableViewController

@synthesize enablePulltoRefresh;
@synthesize pullRefreshView;
@synthesize isLoading;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self setup];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.enablePulltoRefresh = YES;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(pullRefreshView))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(enablePulltoRefresh))];
    [self.tableView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    [super dealloc];
}


- (void)setup {
    // setup observers
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(pullRefreshView)) options:0 context:nil];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(enablePulltoRefresh)) options:0 context:nil];
    [self.tableView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:0 context:nil];
    
    // setup default refresh to pull view
    self.pullRefreshView = [[HBDefaultPullToRefreshView new] autorelease];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (@selector(enablePulltoRefresh) == NSSelectorFromString(keyPath) && (object == self)) {
        if (self.enablePulltoRefresh) {
            [self addPullToRefreshHeader]; 
        } else {
            [self removePullToRefreshHeader];
        }
    } else if (@selector(contentOffset) == NSSelectorFromString(keyPath) && (object == self.tableView)) {
        if (isLoading) return;
        
        [UIView beginAnimations:nil context:NULL];
        if (self.tableView.contentOffset.y < -self.pullRefreshView.frame.size.height) {
            [self.pullRefreshView scrollingAboveView];
        } else { 
            [self.pullRefreshView scrollingInView];
        }
        [UIView commitAnimations];
    } else if (@selector(pullRefreshView) == NSSelectorFromString(keyPath) && (object == self)) {
        [self addPullToRefreshHeader];
    }
}

-(void)willChangeValueForKey:(NSString *)key {
    if (@selector(pullRefreshView) == NSSelectorFromString(key)) {
        [self removePullToRefreshHeader];
    }
    [super willChangeValueForKey:key];
}

- (void)removePullToRefreshHeader {
    [self.pullRefreshView removeFromSuperview];
}

- (void)addPullToRefreshHeader {
    [self.tableView addSubview:self.pullRefreshView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -self.pullRefreshView.frame.size.height)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isLoading) return;
    if (scrollView.contentOffset.y <= -self.pullRefreshView.frame.size.height) {
        // Released above the header
        [self startLoading:YES];
    }
}

- (void)startLoading:(BOOL)animate {
    self.isLoading = YES;

    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:(animate ? 0.3f : 0.0f)];
    self.tableView.contentInset = UIEdgeInsetsMake(self.pullRefreshView.frame.size.height, 0, 0, 0);
    [self.pullRefreshView tableWillBeganLoading];
    [UIView commitAnimations];

    // Refresh action!
    [self.pullRefreshView refresh];
}


- (void)stopLoading:(BOOL)animate {
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:(animate ? 0.3f : 0.0f)];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = self.tableView.contentInset;
    tableContentInset.top = 0.0;
    self.tableView.contentInset = tableContentInset;
    [self.pullRefreshView tableWillEndLoading];
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    [self.pullRefreshView tableDidEndLoading];
    self.isLoading = NO;
}

@end
