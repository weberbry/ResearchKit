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
}

- (instancetype)initWithStep:(ORKStep *)step {
    self = [super initWithStep:step];
    if (self) {
        self.suspendIfInactive = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.activeStepView.stepViewFillsAvailableSpace = YES;
    
    _drawingContentView = [[ORKDrawingContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 500)];
    _drawingContentView.backgroundColor = [UIColor lightGrayColor];
    self.activeStepView.activeCustomView = _drawingContentView;
}

- (ORKStepResult *)result {
    ORKStepResult *sResult = [super result];
    sResult.results = _drawingContentView.paths;
    return sResult;
}

@end
