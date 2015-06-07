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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setBackgroundColor:[UIColor redColor]];
    
    ORKInstructionStep *introStep = [[ORKInstructionStep alloc] initWithIdentifier:@"Intro"];
    ORKDrawingStep *drawingStep = [[ORKDrawingStep alloc] initWithIdentifier:@"Drawing"];
    ORKInstructionStep *outroStep = [[ORKInstructionStep alloc] initWithIdentifier:@"Out"];

    drawingStep.stepDuration = 10;
    drawingStep.shouldContinueOnFinish = YES;
    drawingStep.shouldStartTimerAutomatically = YES;
    ORKOrderedTask *tapOrderTask = [[ORKOrderedTask alloc] initWithIdentifier:@"drawing" steps:@[introStep, drawingStep, outroStep]];
    
    
//    ORKOrderedTask *tapOrderTask2 = [ORKOrderedTask twoFingerTappingIntervalTaskWithIdentifier:@"Tap Test" intendedUseDescription:@"Tap" duration:10 options:ORKPredefinedTaskOptionNone];
    
    ORKTaskViewController *vc = [[ORKTaskViewController alloc] initWithTask:tapOrderTask taskRunUUID:nil];
    
//    ORKTappingIntervalStep *step = [[ORKTappingIntervalStep alloc] init];
//    step.stepDuration = 5;
//    ORKTappingIntervalStepViewController *vc =[[ORKTappingIntervalStepViewController alloc] initWithStep:step];
    
    //ORKDrawingStepViewController *vc = [[ORKDrawingStepViewController alloc] initWithStep:step];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
