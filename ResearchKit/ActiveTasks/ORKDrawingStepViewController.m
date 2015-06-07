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
    
    
    self.view.backgroundColor = [UIColor yellowColor];
//    _touchDownRecognizer = [UIGestureRecognizer new];
//    _touchDownRecognizer.delegate = self;
//    [self.view addGestureRecognizer:_touchDownRecognizer];
    
    self.activeStepView.stepViewFillsAvailableSpace = YES;
    
    self.timerUpdateInterval = 0.1;
    
    //_drawingContentView = [[ORKDrawingContentView alloc] init];
    
    _drawingContentView = [[ORKDrawingContentView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
    _drawingContentView.backgroundColor = [UIColor orangeColor];
    self.activeStepView.activeCustomView = _drawingContentView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _viewSize = self.view.frame.size;
}

- (void)receiveTouch:(UITouch *)touch onButton:(ORKTappingButtonIdentifier)buttonIdentifier {
    if (_expired || self.samples == nil) {
        return;
    }
    
    NSTimeInterval mediaTime = CACurrentMediaTime();
    
    if (_tappingStart == 0) {
        _tappingStart = mediaTime;
    }
    
    
    CGPoint location = [touch locationInView:self.view];
    
    // Add new sample
    mediaTime = mediaTime-_tappingStart;
    
    ORKTappingSample *sample = [[ORKTappingSample alloc] init];
    sample.buttonIdentifier = buttonIdentifier;
    sample.location = location;
    sample.timestamp = mediaTime;
    
    [self.samples addObject:sample];
    
    if (buttonIdentifier == ORKTappingButtonIdentifierLeft || buttonIdentifier == ORKTappingButtonIdentifierRight) {
        _hitButtonCount++;
    }
    // Update label
    //[_tappingContentView setTapCount:_hitButtonCount];
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
    
    _expired = YES;
    [_drawingContentView finishStep:self];
    [self goForward];
}

- (void)start {
    [super start];
}

#pragma mark buttonAction

- (IBAction)buttonPressed:(id)button forEvent:(UIEvent *)event {
    
//    if (self.samples == nil) {
//        // Start timer on first touch event on button
//        _samples = [NSMutableArray array];
//        _hitButtonCount = 0;
//        [self start];
//    }
//    
//    NSInteger index = (button == _tappingContentView.tapButton1) ? ORKTappingButtonIdentifierLeft : ORKTappingButtonIdentifierRight;
//    
//    [self receiveTouch:[[event touchesForView:button] anyObject] onButton:index];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint location = [touch locationInView:self.view];
    
    BOOL shouldReceive = !(CGRectContainsPoint(_buttonRect1, location) || CGRectContainsPoint(_buttonRect2, location));
    
    if (shouldReceive && touch.phase == UITouchPhaseBegan) {
        [self receiveTouch:touch onButton:ORKTappingButtonIdentifierNone];
    }
    
    return NO;
}

@end
