//
//  MTCalendarView.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-23.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "MTCalendarView.h"
#import "NSDate+Calculations.h"
#import "NSDate-Utilities.h"

@interface MTCalendarView(private)

- (void) monthUpdated;

@end

@implementation MTCalendarView
@synthesize selectedDate = _selectedDate;
@synthesize miniumDate = _miniumDate;
@synthesize monthBar = _monthBar;
@synthesize monthLabelButton = _monthLabelButton;
@synthesize monthBackButton = _monthBackButton;
@synthesize monthForwardButton = _monthForwardButton;
@synthesize calendarScrollView = _calendarScrollView;
@synthesize delegate;

static const CGFloat kDefaultMonthBarHeight = 36;
static const CGFloat kDefaultMonthBarButtonHeight = 36;
static const CGFloat kDefaultMonthBarButtonWidth = 36;
static const CGFloat kCalendarCellSideLength = 70;

- (void)setSelectedDate:(NSDate *)selectedDate {
    if (![selectedDate isEqualToDate:_selectedDate]) {
        NSDate *oldDate = [_selectedDate copy];
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
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        if ([oldDate isEarlierThanDate:_selectedDate]) {
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.calendarScrollView cache:YES]; 
        }else {
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.calendarScrollView cache:YES]; 
        }
        [oldDate release];
        [UIView commitAnimations];
        
    }
}

- (UIView *)monthBar {
    if (!_monthBar) {
        _monthBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kDefaultMonthBarHeight)];
        _monthBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _monthBar.backgroundColor = RGBCOLOR(235, 242, 218);
        _monthBar.layer.shadowOffset = CGSizeMake(0, 1.0);
        _monthBar.layer.shadowRadius = 0;
        _monthBar.layer.shadowColor = RGBCOLOR(200, 213, 162).CGColor;
        _monthBar.layer.shadowOpacity = 1;
        [_monthBar addSubview:self.monthBackButton];
        [_monthBar addSubview:self.monthLabelButton];
        [_monthBar addSubview:self.monthForwardButton];
    }
    
    return _monthBar;
}

- (UIButton *)monthBackButton {
    if (!_monthBackButton) {
        _monthBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (kDefaultMonthBarHeight - kDefaultMonthBarButtonHeight)/2, kDefaultMonthBarButtonWidth, kDefaultMonthBarButtonHeight)];
        [_monthBackButton setBackgroundImage:[UIImage imageNamed:@"calendar-back.png"] forState:UIControlStateNormal];
        //[_monthBackButton setBackgroundImage:[UIImage imageNamed:@"calendar-back-disable"] forState:UIControlStateDisabled];
        //[_monthBackButton setTitle:@"<" forState:UIControlStateNormal];
        [_monthBackButton setTitleColor:RGBCOLOR(99, 159, 40) forState:UIControlStateNormal];
        [_monthBackButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_monthBackButton addTarget:self action:@selector(monthBack) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _monthBackButton;
}

- (UIButton *)monthForwardButton {
    if (!_monthForwardButton) {
        float x = self.monthBar.frame.size.width - kDefaultMonthBarButtonWidth;
        _monthForwardButton = [[UIButton alloc] initWithFrame:CGRectMake(x, (kDefaultMonthBarHeight - kDefaultMonthBarButtonHeight)/2, kDefaultMonthBarButtonWidth, kDefaultMonthBarButtonHeight)];
        [_monthForwardButton setBackgroundImage:[UIImage imageNamed:@"calendar-forward.png"] forState:UIControlStateNormal];
        //[_monthForwardButton setBackgroundImage:[UIImage imageNamed:@"calendar-forward-disable"] forState:UIControlStateDisabled];
        //[_monthForwardButton setTitle:@">" forState:UIControlStateNormal];
        [_monthForwardButton setTitleColor:RGBCOLOR(99, 159, 40) forState:UIControlStateNormal];
        [_monthForwardButton addTarget:self action:@selector(monthForward) forControlEvents:UIControlEventTouchUpInside];
    }
    return _monthForwardButton;
}

- (void)_showMonthPicker {
    if ([self.delegate respondsToSelector:@selector(didTouchDateBar)]) {
        [self.delegate didTouchDateBar];
    }
}

- (UIButton *)monthLabelButton {
    if (!_monthLabelButton) {
        _monthLabelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.monthBar.frame.size.width / 4, 0, self.monthBar.frame.size.width / 2, kDefaultMonthBarHeight)];
        [_monthLabelButton setTitleColor:RGBCOLOR(99, 159, 40) forState:UIControlStateNormal];
        _monthLabelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_monthLabelButton addTarget:self action:@selector(_showMonthPicker) forControlEvents:UIControlEventTouchUpInside];
    }
    return _monthLabelButton;
}

- (UIScrollView *)calendarScrollView {
    if (!_calendarScrollView) {
        CGRect rect = self.bounds;
        rect.size.height -= kDefaultMonthBarHeight;
        rect.origin.y = kDefaultMonthBarHeight;
        _calendarScrollView = [[UIScrollView alloc] initWithFrame:rect];
        _calendarScrollView.backgroundColor = RGBCOLOR(226, 236, 203);
        _calendarScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _calendarScrollView;
}

- (MTCalendarCellView *)cellForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startDate = [self.selectedDate beginningOfMonth];
    int dayInCalendar = [calendar components:NSDayCalendarUnit fromDate:startDate toDate:date options:0].day;
    if (dayInCalendar > 0 && dayInCalendar <= [self.selectedDate daysInMonth]) {
        return (MTCalendarCellView *)[self.calendarScrollView viewWithTag:date.day];
    }
    return nil;
}

- (void)touchedCellView:(MTCalendarCellView *)cellView {
    self.selectedDate = cellView.date;
    [self.delegate calendarView:self didSelectDate:self.selectedDate];
}

- (void)monthBack {
    if ([[self.selectedDate beginningOfMonth] timeIntervalSince1970] <= [self.miniumDate timeIntervalSince1970]) {
        return;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *monthStep = [[NSDateComponents new] autorelease];
    monthStep.month = -1;
    self.selectedDate = [calendar dateByAddingComponents: monthStep toDate: self.selectedDate options: 0];
    [self.delegate monthDidChangeOnCalendarView:self];
    
}

- (void)monthForward {
    if ([[self.selectedDate beginningOfMonth] timeIntervalSince1970] >= [[[NSDate date] beginningOfMonth] timeIntervalSince1970]) { 
        return;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *monthStep = [[NSDateComponents new] autorelease];
    monthStep.month = 1;
    self.selectedDate = [calendar dateByAddingComponents: monthStep toDate: self.selectedDate options: 0];
    [self.delegate monthDidChangeOnCalendarView:self];
}

- (void)reload {
    [self monthUpdated];
}

- (void)monthUpdated {
    
    //disable month back button when current month equal minium date month
    if ([[self.selectedDate beginningOfMonth] timeIntervalSince1970] <= [self.miniumDate timeIntervalSince1970]) {
        self.monthBackButton.enabled = NO;
    }else {
        self.monthBackButton.enabled = YES;
    }
    
    //disable month forward button when current month
    NSDate *now = [NSDate date];
    if ([[self.selectedDate beginningOfMonth] timeIntervalSince1970] >= [[now beginningOfMonth] timeIntervalSince1970]) {
        self.monthForwardButton.enabled = NO;
    }else {
        self.monthForwardButton.enabled = YES;
    }
    

    //remove all calendar cell views from the scroll view
    for (MTCalendarCellView *cellView in self.calendarScrollView.subviews) {
        [cellView removeFromSuperview];
    }
    
    //add calendar cell views for selected month
    int days = [self.selectedDate daysInMonth];
    NSDate *date = [self.selectedDate beginningOfMonth];
    for (int i = 1; i <= days; i++) {
        MTCalendarCellView *cellView = [[MTCalendarCellView alloc] initWithFrame:CGRectMake(0, 0, kCalendarCellSideLength, kCalendarCellSideLength)];
        //disable cell if date before minium date
        if ([date timeIntervalSince1970] < [self.miniumDate timeIntervalSince1970]) {
            cellView.enabled = NO;
            cellView.alpha = 0.5;
        }
        if ([date isLaterThanDate:[NSDate date]]) {
            cellView.enabled = NO;
            cellView.alpha = 0.5;
        }
        cellView.date = date;
        cellView.backgroundColor = [UIColor grayColor];
        cellView.tag = i;
        [cellView addTarget:self action:@selector(touchedCellView:) forControlEvents:UIControlEventTouchUpInside];
        [self.calendarScrollView addSubview:cellView];
        date = [date dateByAddingDays:1];
        [cellView release];
        
    }
    
    CGFloat marginWidth = (self.frame.size.width - 4 * kCalendarCellSideLength) / 5;
    self.calendarScrollView.contentSize = CGSizeMake(self.frame.size.width, (kCalendarCellSideLength + marginWidth) * ceil([self.selectedDate daysInMonth] / 4.0) + marginWidth);
    CGRect cellFrame = CGRectMake(0, 0, kCalendarCellSideLength, kCalendarCellSideLength);
    
    int i = 0;
    for (MTCalendarCellView *cellView in self.calendarScrollView.subviews) {
        if (cellView.tag > 0) {
            cellFrame.origin.x = (kCalendarCellSideLength + marginWidth) * (i % 4) + marginWidth;
            cellFrame.origin.y = (kCalendarCellSideLength + marginWidth) * (i / 4) + marginWidth;
            cellView.frame = cellFrame;
        }
        
        i++;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat marginWidth = (self.frame.size.width - 4 * kCalendarCellSideLength) / 5;
    self.calendarScrollView.contentSize = CGSizeMake(self.frame.size.width, (kCalendarCellSideLength + marginWidth) * ceil([self.selectedDate daysInMonth] / 4.0) + marginWidth);
    CGRect cellFrame = CGRectMake(0, 0, kCalendarCellSideLength, kCalendarCellSideLength);
    
    int i = 0;
    for (MTCalendarCellView *cellView in self.calendarScrollView.subviews) {
        if (cellView.tag > 0) {
            cellFrame.origin.x = (kCalendarCellSideLength + marginWidth) * (i % 4) + marginWidth;
            cellFrame.origin.y = (kCalendarCellSideLength + marginWidth) * (i / 4) + marginWidth;
            cellView.frame = cellFrame;
        }
        
        i++;
    }
    
    
}

- (id)init {
    self = [super init];
    if (self) {
        [self addSubview:self.monthBar];
        [self addSubview:self.calendarScrollView];
        self.selectedDate = [NSDate date];
        self.miniumDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubview:self.monthBar];
        [self addSubview:self.calendarScrollView];
        self.selectedDate = [NSDate date];
        self.miniumDate = [NSDate dateWithTimeIntervalSince1970:0];
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
        self.miniumDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return self;
}

- (void)dealloc {
    [_selectedDate release];
    [_miniumDate release];
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
