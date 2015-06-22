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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                  constant:[UIScreen mainScreen].bounds.size.width];
        width.priority = UILayoutPriorityFittingSizeLevel;
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:[UIScreen mainScreen].bounds.size.height];
        height.priority = UILayoutPriorityFittingSizeLevel;
        [self addConstraints:@[width, height]];
    }
    return self;
}

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
