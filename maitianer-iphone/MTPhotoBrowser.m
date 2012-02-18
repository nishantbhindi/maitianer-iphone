//
//  MTPhotoBrowser.m
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-17.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "MTPhotoBrowser.h"
#import "MTCaptionView.h"

#define PADDING 10

@interface MTPhotoBrowser ()
// Data
- (NSUInteger)numberOfPhotos;
- (id<MTPhotoProtocol>)photoAtIndex:(NSUInteger)index;

// Frame
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;
- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index;
                                                        
@end

@implementation MTPhotoBrowser
@synthesize delegate = _delegate;
@synthesize photoCount = _photoCount;
@synthesize photos = _photos;
@synthesize pagingScrollView = _pagingScrollView;
@synthesize currentPageIndex = _currentPageIndex;

- (id)init {
    if (self = [super init]) {
        // Default
        self.wantsFullScreenLayout = YES;
        self.hidesBottomBarWhenPushed = YES;
        _photoCount = NSNotFound;
        _currentPageIndex = 0;
        _photos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithDelegate:(id<MTPhotoBrowserDelegate>)delegate {
    if (self = [self init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    [_photos release];
    [_pagingScrollView release];
    [super dealloc];
}

- (void)setInitialPageIndex:(NSUInteger)index {
    // Validate
    if (index >= [self numberOfPhotos]) index = [self numberOfPhotos] - 1;
    _currentPageIndex = index;
}

#pragma mark - Data
- (void)reloadData {
    // Reset
    _photoCount = NSNotFound;
    
    // Get data
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    [_photos removeAllObjects];
    for (int i = 0; i < numberOfPhotos; i++) [_photos addObject:[NSNull null]];
    
    // Update
    // TODO Layout
}

- (NSUInteger)numberOfPhotos {
    if (_photoCount == NSNotFound) {
        if ([_delegate respondsToSelector:@selector(numberOfPhotosInPhotoBrowser:)]) {
            _photoCount = [_delegate numberOfPhotosInPhotoBrowser:self];
        }
    }
    if (_photoCount == NSNotFound) _photoCount = 0;
    return _photoCount;
}

- (id<MTPhotoProtocol>)photoAtIndex:(NSUInteger)index {
    id <MTPhotoProtocol> photo = nil;
    if (index < _photos.count) {
        if ([_photos objectAtIndex:index] == [NSNull null]) {
            if ([_delegate respondsToSelector:@selector(photoBrowser:photoAtIndex:)]) {
                photo = [_delegate photoBrowser:self photoAtIndex:index];
            }
            if (photo) [_photos replaceObjectAtIndex:index withObject:photo];
        } else {
            photo = [_photos objectAtIndex:index];
        }
    }
    return photo;
}

#pragma mark - Frame
- (CGRect)frameForPagingScrollView {
    CGRect frame = self.view.bounds;
    frame.origin.x -= PADDING;
    frame.size.width += (2 + PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = _pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = _pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self numberOfPhotos], bounds.size.height);
}

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index {
    CGFloat pageWidth = _pagingScrollView.bounds.size.width;
    CGFloat newOffset = index + pageWidth;
    return CGPointMake(newOffset, 0);
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    // Super
    [super viewDidLoad];
    
    // View
    self.view.backgroundColor = [UIColor blackColor];
    
    // Setup paging scrolling view
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    _pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    _pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.delegate = self;
    _pagingScrollView.showsHorizontalScrollIndicator = NO;
    _pagingScrollView.showsVerticalScrollIndicator = NO;
    _pagingScrollView.backgroundColor = [UIColor blackColor];
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    [self.view addSubview:_pagingScrollView];
    
    // Navigation Bar
    
    // Caption View
    
    // Update
    [self reloadData];
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

@end
