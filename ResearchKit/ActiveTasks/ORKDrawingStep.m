//
//  ORKDrawingStep.m
//  ResearchKit
//
//  Created by Bryan Weber on 6/6/15.
//  Copyright (c) 2015 researchkit.org. All rights reserved.
//

#import "ORKDrawingStep.h"
#import "ORKDrawingStepViewController.h"


@implementation ORKDrawingStep

+ (Class)stepViewControllerClass {
    return [ORKDrawingStepViewController class];
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super initWithIdentifier:identifier];
    if (self) {
        self.shouldShowDefaultTimer = NO;
    }
    return self;
}

@end
