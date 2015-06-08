//
//  ORKDrawingContentView.m
//  ResearchKit
//
//  Created by Bryan Weber on 6/6/15.
//  Copyright (c) 2015 researchkit.org. All rights reserved.
//

#import "ORKDrawingContentView.h"
#import "ORKActiveStepTimer.h"
#import "ORKResult.h"
#import "ORKSkin.h"
#import "ORKSubheadlineLabel.h"
#import "ORKTapCountLabel.h"
#import "ORKHelpers.h"


// #define LAYOUT_DEBUG 1


@interface ORKDrawingContentView ()

@property (nonatomic, strong) UIBezierPath *currentPath;

@end


@implementation ORKDrawingContentView

- (void)drawRect:(CGRect)rect {
    [[UIColor redColor] set];
    for (UIBezierPath *path in self.paths) {
        [path stroke];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.currentPath = [UIBezierPath bezierPath];
    self.currentPath.lineWidth = 3.0;
    UITouch *touch = touches.anyObject;
    [self.currentPath moveToPoint:[touch locationInView:self]];
    [self.paths addObject:self.currentPath];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    [self.currentPath addLineToPoint:[touch locationInView:self]];
    [self setNeedsDisplay];
}

-(NSMutableArray *)paths {
    if (!_paths) {
        _paths = [[NSMutableArray alloc] init];
    }
    return _paths;
}

@end
