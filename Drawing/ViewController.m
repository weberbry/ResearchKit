//
//  ViewController.m
//  Drawing
//
//  Created by Bryan Weber on 6/6/15.
//  Copyright (c) 2015 researchkit.org. All rights reserved.
//

#import "ViewController.h"
#import "ORKTappingIntervalStepViewController.h"
#import "ORKDrawingStepViewController.h"
#import "ORKDrawingStep.h"

@interface ViewController () <ORKTaskViewControllerDelegate>

@property (nonatomic) BOOL presented;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.presented) {
        ORKInstructionStep *introStep = [[ORKInstructionStep alloc] initWithIdentifier:@"Intro"];
        introStep.title = @"Welcome to the Study";
        introStep.text = @"Draw Something On The Next Screen";
        
        ORKDrawingStep *drawingStep = [[ORKDrawingStep alloc] initWithIdentifier:@"Drawing"];
        
        ORKInstructionStep *outroStep = [[ORKInstructionStep alloc] initWithIdentifier:@"Out"];
        outroStep.title = @"You're Done!";
        
        ORKOrderedTask *drawingOrderTask = [[ORKOrderedTask alloc] initWithIdentifier:@"drawing" steps:@[introStep, drawingStep, outroStep]];
        
        ORKTaskViewController *vc = [[ORKTaskViewController alloc] initWithTask:drawingOrderTask taskRunUUID:nil];
        vc.delegate = self;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)taskViewController:(ORKTaskViewController * __nonnull)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(nullable NSError *)error {
    
    self.presented = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSArray *paths = [[taskViewController.result.results objectAtIndex:1] results];
    for (UIBezierPath *path in paths) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [path CGPath];
        shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
        shapeLayer.lineWidth = 3.0;
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        
        [self.view.layer addSublayer:shapeLayer];
    }

}

@end
