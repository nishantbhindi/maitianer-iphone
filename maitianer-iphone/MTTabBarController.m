//
//  MTTabBarController.m
//  maitianer-iphone
//
//  Created by lee rock on 11-12-10.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "MTTabBarController.h"
#import "MTTab.h"
#import "UIViewController+iconImage.h"

@implementation MTTabBarController
@synthesize tabBar = _tabBar;
@synthesize viewControllers = _viewControllers;
@synthesize selectedViewController = _selectedViewController;
@synthesize contentView = _contentView;

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    if (_selectedViewController != selectedViewController) {
        UIViewController *oldVC = _selectedViewController;
        [_selectedViewController release];
        _selectedViewController = [selectedViewController retain];
        [oldVC viewWillDisappear:NO];
        [_selectedViewController viewWillAppear:NO];
        [oldVC.view removeFromSuperview];
        _selectedViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44);
        [self.view addSubview:_selectedViewController.view];
        [oldVC viewDidDisappear:NO];
        [_selectedViewController viewDidAppear:NO];
    }
}

- (void)_loadTabs {
    NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:[self.viewControllers count]];
    for (UIViewController *vc in self.viewControllers) {
        [tabs addObject:[[MTTab alloc] initWithIconImageName:[vc iconImageName]]];
    }
    self.tabBar.tabs = tabs;
}

- (void)dealloc {
    [_tabBar release];
    [_viewControllers release];
    [_selectedViewController release];
    [_contentView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
    self.tabBar = [[[MTTabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - tabBarGradient.size.height * 2, self.view.frame.size.width, tabBarGradient.size.height * 2)] autorelease];
    self.tabBar.delegate = self;
    [self.view addSubview:self.tabBar];
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - tabBarGradient.size.height * 2)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view sendSubviewToBack:self.contentView];
    [self _loadTabs];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Maitianer tab bar delegate
- (void)tabBar:(MTTabBar *)tabBar didSelectTabAtIndex:(NSInteger)index {
    UIViewController *vc = [self.viewControllers objectAtIndex:index];
    if (self.selectedViewController != vc) {
        self.selectedViewController = vc;
    }
}

@end
