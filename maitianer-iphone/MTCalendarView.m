//
//  MTCalendarView.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-23.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "MTCalendarView.h"

@interface MTCalendarView(private)

- (void) monthUpdated;

@end

@implementation MTCalendarView
@synthesize selectedDate = _selectedDate;
@synthesize monthBar = _monthBar;
@synthesize monthLabelButton = _monthLabelButton;
@synthesize monthBackButton = _monthBackButton;
@synthesize monthForwardButton = _monthForwardButton;
@synthesize calendarScrollView = _calendarScrollView;
@synthesize delegate;

static const CGFloat kDefaultMonthBarHeight = 28;
static const CGFloat kDefaultMonthBarButtonWidth = 60;

- (void)setSelectedDate:(NSDate *)selectedDate {
    if (![selectedDate isEqualToDate:_selectedDate]) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        int oldMonth = [calendar components:NSMonthCalendarUnit fromDate:self.selectedDate].month;
        int newMonth = [calendar components:NSMonthCalendarUnit fromDate:selectedDate].month;
        
        int year = [calendar components:NSYearCalendarUnit fromDate:selectedDate].year;
        
        [_selectedDate release];
        _selectedDate = [selectedDate retain];
        
        if (oldMonth != newMonth) {
            [self monthUpdated];
        }
        
        [self.monthLabelButton setTitle:[NSString stringWithFormat:@"%d年%02d月", year, newMonth] forState:UIControlStateNormal];
    }
}

- (UIView *) monthBar {
    if (!_monthBar) {
        _monthBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kDefaultMonthBarHeight)];
        _monthBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _monthBar.backgroundColor = [UIColor blackColor];
        [_monthBar addSubview:self.monthBackButton];
        [_monthBar addSubview:self.monthLabelButton];
        [_monthBar addSubview:self.monthForwardButton];
    }
    
    return _monthBar;
}

- (UIButton *)monthBackButton {
    if (!_monthBackButton) {
        _monthBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kDefaultMonthBarButtonWidth, kDefaultMonthBarHeight)];
        [_monthBackButton setTitle:@"<" forState:UIControlStateNormal];
        [_monthBackButton addTarget:self action:@selector(monthBack) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _monthBackButton;
}

- (UIButton *)monthForwardButton {
    if (!_monthForwardButton) {
        float x = self.monthBar.frame.size.width - kDefaultMonthBarButtonWidth;
        _monthForwardButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, kDefaultMonthBarButtonWidth, kDefaultMonthBarHeight)];
        [_monthForwardButton setTitle:@">" forState:UIControlStateNormal];
        [_monthForwardButton addTarget:self action:@selector(monthForward) forControlEvents:UIControlEventTouchUpInside];
    }
    return _monthForwardButton;
}

- (UIButton *)monthLabelButton {
    if (!_monthLabelButton) {
        _monthLabelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.monthBar.frame.size.width / 4, 0, self.monthBar.frame.size.width / 2, kDefaultMonthBarHeight)];
    }
    return _monthLabelButton;
}

- (UIScrollView *)calendarScrollView {
    if (!_calendarScrollView) {
        CGRect rect = self.bounds;
        rect.size.height -= self.monthBar.frame.size.height;
        rect.origin.y = self.monthBar.frame.size.height;
        _calendarScrollView = [[UIScrollView alloc] initWithFrame:rect];
        _calendarScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _calendarScrollView;
}

- (MTCalendarCellView *)cellForDate:(NSDate *)date {
    return nil;
}

- (void)touchedCellView:(MTCalendarCellView *)cellView {
    self.selectedDate = cellView.date;
    [self.delegate calendarView:self didSelectDate:self.selectedDate];
}

- (void)monthBack {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *monthStep = [[NSDateComponents new] autorelease];
    monthStep.month = -1;
    self.selectedDate = [calendar dateByAddingComponents: monthStep toDate: self.selectedDate options: 0];
}

- (void)monthForward {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *monthStep = [[NSDateComponents new] autorelease];
    monthStep.month = 1;
    self.selectedDate = [calendar dateByAddingComponents: monthStep toDate: self.selectedDate options: 0];
}

- (void)monthUpdated {
    //remove all calendar cell views from the scroll view
    for (MTCalendarCellView *cellView in self.calendarScrollView.subviews) {
        [cellView removeFromSuperview];
    }
    
    //selected month
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.selectedDate];
    
    int selectedMonth = [calendar components:NSMonthCalendarUnit fromDate:self.selectedDate].month;
    NSDateComponents *dayStep = [[NSDateComponents alloc] init];
    dayStep.day = 1;
//    int month = [calendar components:NSMonthCalendarUnit fromDate:date].month;
    
    //add cell view as calendar scroll view's subview for selected month
//    while (month <= selectedMonth) {
//        MTCalendarCellView *cellView = [[[MTCalendarCellView alloc] init] autorelease];
//        cellView.date = date;
//        [cellView addTarget:self action:@selector(touchedCellView:) forControlEvents:UIControlEventTouchUpInside];
//        [self.calendarScrollView addSubview:cellView];
//        date = [calendar dateByAddingComponents:dayStep toDate:date options:0];
//        month = [calendar components: NSMonthCalendarUnit fromDate:date].month;
//    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float cellSideLength = self.calendarScrollView.frame.size.width / 4;
    CGRect cellFrame = CGRectMake(0, 0, cellSideLength, cellSideLength);
    
    int i = 0;
    for (MTCalendarCellView *cellView in self.calendarScrollView.subviews) {
        cellFrame.origin.x = cellFrame.size.width * (i % 7);
        cellFrame.origin.y = cellFrame.size.height * (i / 7);
        cellView.frame = cellFrame;
        
        i++;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        [self addSubview:self.monthBar];
        [self addSubview:self.calendarScrollView];
        self.selectedDate = [NSDate date];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubview:self.monthBar];
        [self addSubview:self.calendarScrollView];
        self.selectedDate = [NSDate date];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.monthBar];
        [self addSubview:self.calendarScrollView];
        self.selectedDate = [NSDate date];
    }
    return self;
}

- (void)dealloc {
    [_selectedDate release];
    [_monthBar release];
    [_monthBackButton release];
    [_monthForwardButton release];
    [_monthLabelButton release];
    [_calendarScrollView release];
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
