//
//  MTTabBarController.m
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-19.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "MTTabBarController.h"
#import "PhotographViewController.h"

@interface MTTabBarController ()

@property (nonatomic, retain) UIView *transitionView;

- (MTTabBar *)loadTabBarFromNib;
- (void)displayViewAtIndex:(NSUInteger)index;
@end

@implementation MTTabBarController
@synthesize viewControllers = _viewControllers;
@synthesize tabBar = _tabBar;
@synthesize selectedIndex = _selectedIndex;
@synthesize tabBarHidden = _tabBarHidden;

@synthesize transitionView = _transitionView;

- (MTTabBar *)loadTabBarFromNib {
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"MTTabBar" owner:self options:nil];
    for (id object in bundle) {
        if ([object isKindOfClass:[MTTabBar class]]) {
            return object;
        }
    }
    return nil;
}

- (void)setTabBarHidden:(BOOL)tabBarHidden animated:(BOOL)animated {
    
}

- (void)displayViewAtIndex:(NSUInteger)index {
    // If target index is equal to current selected index, do nothing.
    if (_selectedIndex == index && [[_transitionView subviews] count]!= 0) {
        return;
    }
    
    // Don't use self.selectedIndex
    _selectedIndex = index;
    
    UIViewController *selectedVC = [self.viewControllers objectAtIndex:index];
    
    selectedVC.view.frame = self.transitionView.bounds;
    if ([selectedVC.view isDescendantOfView:self.transitionView]) {
        [self.transitionView bringSubviewToFront:selectedVC.view];
    }else {
        [self.transitionView addSubview:selectedVC.view];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self displayViewAtIndex:selectedIndex];
}

- (id)init {
    self = [super init];
    if (self) {
        _tabBar = [self loadTabBarFromNib];
        _tabBar.delegate = self;
        _tabBarHidden = NO;
        _transitionView = [[UIView alloc] init];
    }
    return self;
}

- (id)initWithControllers:(NSArray *)controllers {
    self = [self init];
    if (self) {
        _viewControllers = [controllers retain];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [_viewControllers release];
    [_tabBar release];
    [_transitionView release];
    [super dealloc];
}

#pragma mark - View lifecycle
- (void)loadView {
    [super loadView];
    // Frame
    self.view.frame = [UIScreen mainScreen].applicationFrame;
    self.transitionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBar.frame.size.height);
    CGRect tabBarFrame = self.tabBar.frame;
    tabBarFrame.origin.y = self.view.frame.size.height - tabBarFrame.size.height;
    self.tabBar.frame = tabBarFrame;
    
    [self.view addSubview:self.tabBar];
    [self.view addSubview:self.transitionView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Selected view at index 0 for default
    self.selectedIndex = 0;
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

#pragma mark - MTTabBar delegate methods
- (void)tabBar:(MTTabBar *)tabBar didSelectedTabBarButtonWithTag:(NSInteger)tag {
    // Validate
    if (tag < 0 || tag > [self.viewControllers count] - 1) {
        return;
    }
    if (tag == PHOTO_PICKER_BUTTON_TAG) {
        PhotographViewController *photographVC = [self.viewControllers objectAtIndex:tag];
        [photographVC photoLibraryAction];
    }else {
        [self displayViewAtIndex:tag];
    }
    
}

@end
