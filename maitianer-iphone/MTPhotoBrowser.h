//
//  MTPhotoBrowser.h
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-17.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTPhotoProtocol.h"
//Delegate
@class MTPhotoBrowser;
@protocol MTPhotoBrowserDelegate <NSObject>
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MTPhotoBrowser *)photoBrowser;
- (id<MTPhotoProtocol>)photoBrowser:(MTPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;
@optional

@end

@interface MTPhotoBrowser : UIViewController <UIScrollViewDelegate> {
    // Data
    id <MTPhotoBrowserDelegate> _delegate;
    NSUInteger _photoCount;
    NSMutableArray *_photos;
    
    // Views
    UIScrollView *_pagingScrollView;
    
    // Paging
    NSUInteger _currentPageIndex;
}

@property (nonatomic, assign) id <MTPhotoBrowserDelegate> delegate;
@property (nonatomic, assign) NSUInteger photoCount;
@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic, retain) UIScrollView *pagingScrollView;
@property (nonatomic, assign) NSUInteger currentPageIndex;

// Init
- (id)initWithDelegate:(id <MTPhotoBrowserDelegate>)delegate;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setInitialPageIndex:(NSUInteger)index;

@end
