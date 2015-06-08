//
//  ORKDrawingStepViewController.m
//  ResearchKit
//
//  Created by Bryan Weber on 6/6/15.
//  Copyright (c) 2015 researchkit.org. All rights reserved.
//

#import "ORKDrawingStepViewController.h"
#import "ORKDrawingContentView.h"
#import "ORKActiveStepViewController_internal.h"
#import "ORKVerticalContainerView.h"
#import "ORKStepViewController_Internal.h"
#import "ORKActiveStepTimer.h"
#import "ORKResult.h"
#import "ORKHelpers.h"
#import "ORKActiveStepView.h"


@interface ORKDrawingStepViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *samples;

@end

@implementation ORKDrawingStepViewController {
    ORKDrawingContentView *_drawingContentView;
    NSTimeInterval _tappingStart;
    BOOL _expired;
    
    CGRect _buttonRect1;
    CGRect _buttonRect2;
    CGSize _viewSize;
    
    NSUInteger _hitButtonCount;
    
    UIGestureRecognizer *_touchDownRecognizer;
}

- (instancetype)initWithStep:(ORKStep *)step {
    self = [super initWithStep:step];
    if (self) {
        self.suspendIfInactive = YES;
    }
    return self;
}

- (void)initializeInternalButtonItems {
   [super initializeInternalButtonItems];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.activeStepView.stepViewFillsAvailableSpace = YES;
    
    self.timerUpdateInterval = 0.1;
    
    _drawingContentView = [[ORKDrawingContentView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    _drawingContentView.backgroundColor = [UIColor orangeColor];
    self.activeStepView.activeCustomView = _drawingContentView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _viewSize = self.view.frame.size;
}

- (ORKStepResult *)result {
    ORKStepResult *sResult = [super result];
    
    // "Now" is the end time of the result, which is either actually now,
    // or the last time we were in the responder chain.
    NSDate *now = sResult.endDate;
    
    NSMutableArray *results = [NSMutableArray arrayWithArray:sResult.results];
    
    ORKTappingIntervalResult *tappingResult = [[ORKTappingIntervalResult alloc] initWithIdentifier:self.step.identifier];
    tappingResult.startDate = sResult.startDate;
    tappingResult.endDate = now;
    tappingResult.buttonRect1 = _buttonRect1;
    tappingResult.buttonRect2 = _buttonRect2;
    tappingResult.stepViewSize = _viewSize;
    
    tappingResult.samples = _samples;
    
    [results addObject:tappingResult];
    sResult.results = [results copy];
    
    return sResult;
}

- (void)stepDidFinish {
    [super stepDidFinish];
    
    self.samples = _drawingContentView.paths;
    
    _expired = YES;
    [_drawingContentView finishStep:self];
    [self goForward];
}

- (void)start {
    [super start];
}

@end
