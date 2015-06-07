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

@property (nonatomic, strong) ORKSubheadlineLabel *tapCaptionLabel;
@property (nonatomic, strong) ORKTapCountLabel *tapCountLabel;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIBezierPath *currentPath;
@property (nonatomic, strong) NSMutableArray *paths;

@end


@implementation ORKDrawingContentView {
    
    NSArray *_constraints;
    ORKScreenType _screenType;
    UIView *_buttonContainer;
}

-(NSMutableArray *)paths {
    if (!_paths) {
        _paths = [[NSMutableArray alloc] init];
    }
    return _paths;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor purpleColor];
        _paths = [NSMutableArray new];
        
        _screenType = ORKScreenTypeiPhone4;
        _tapCaptionLabel = [ORKSubheadlineLabel new];
        
        _tapCaptionLabel.textAlignment = NSTextAlignmentCenter;
        _tapCaptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _tapCountLabel = [ORKTapCountLabel new];
        _tapCountLabel.textAlignment = NSTextAlignmentCenter;
        _tapCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _buttonContainer = [UIView new];
        _buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        _progressView = [UIProgressView new];

        _progressView.translatesAutoresizingMaskIntoConstraints = NO;
        _progressView.progressTintColor = [self tintColor];
        [_progressView setAlpha:0];

        [self addSubview:_tapCaptionLabel];
        [self addSubview:_tapCountLabel];
        [self addSubview:_progressView];
        [self addSubview:_buttonContainer];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _tapCaptionLabel.text = ORKLocalizedString(@"TOTAL_TAPS_LABEL", nil);
        
        [self setNeedsUpdateConstraints];
        
        _tapCountLabel.accessibilityTraits |= UIAccessibilityTraitUpdatesFrequently;
        

    }
    return self;
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

- (void)drawRect:(CGRect)rect {
    [[UIColor redColor] set];
    for (UIBezierPath *path in self.paths) {
        [path stroke];
    }
}

//- (void)updateConstraints {
//    if ([_constraints count]) {
//        [NSLayoutConstraint deactivateConstraints:_constraints];
//        _constraints = nil;
//    }
//    
//    ORKScreenType screenType = _screenType;
//    const CGFloat HeaderBaselineToCaptionTop = ORKGetMetricForScreenType(ORKScreenMetricCaptionBaselineToTappingLabelTop, screenType);
//    const CGFloat AssumedHeaderBaselineToStepViewTop = ORKGetMetricForScreenType(ORKScreenMetricLearnMoreBaselineToStepViewTop, screenType);
//    CGFloat margin = ORKStandardHorizMarginForView(self);
//    self.layoutMargins = (UIEdgeInsets) { .left=margin*2, .right=margin*2 };
//    
//    static const CGFloat CaptionBaselineToTapCountBaseline = 56;
//    static const CGFloat TapButtonBottomToBottom = 36;
//    
//    // On the iPhone, _progressView is positioned outside the bounds of this view, to be in-between the header and this view.
//    // On the iPad, we want to stretch this out a bit so it feels less compressed.
//    CGFloat progressViewOffset, topCaptionLabelOffset;
//    if (screenType == ORKScreenTypeiPad) {
//        progressViewOffset = 0;
//        topCaptionLabelOffset = AssumedHeaderBaselineToStepViewTop;
//    } else {
//        progressViewOffset = (HeaderBaselineToCaptionTop/3) - AssumedHeaderBaselineToStepViewTop;
//        topCaptionLabelOffset = HeaderBaselineToCaptionTop - AssumedHeaderBaselineToStepViewTop;
//    }
//
//    NSMutableArray *constraints = [NSMutableArray array];
//    
//    NSDictionary *views = NSDictionaryOfVariableBindings(_buttonContainer, _tapCaptionLabel, _tapCountLabel, _progressView);
//    [constraints addObject:[NSLayoutConstraint constraintWithItem:_progressView
//                                                        attribute:NSLayoutAttributeTop
//                                                        relatedBy:NSLayoutRelationEqual
//                                                           toItem:self
//                                                        attribute:NSLayoutAttributeTop
//                                                       multiplier:1 constant:progressViewOffset]];
//    
//    [constraints addObject:[NSLayoutConstraint constraintWithItem:_tapCaptionLabel
//                                                        attribute:NSLayoutAttributeTop
//                                                        relatedBy:NSLayoutRelationEqual
//                                                           toItem:self
//                                                        attribute:NSLayoutAttributeTop
//                                                       multiplier:1 constant:topCaptionLabelOffset]];
//    
//    [constraints addObject:[NSLayoutConstraint constraintWithItem:_tapCountLabel
//                                                        attribute:NSLayoutAttributeFirstBaseline
//                                                        relatedBy:NSLayoutRelationEqual
//                                                           toItem:_tapCaptionLabel
//                                                        attribute:NSLayoutAttributeFirstBaseline
//                                                       multiplier:1 constant:CaptionBaselineToTapCountBaseline]];
//
//    [constraints addObject:[NSLayoutConstraint constraintWithItem:self
//                                                        attribute:NSLayoutAttributeBottom
//                                                        relatedBy:NSLayoutRelationEqual
//                                                           toItem:_buttonContainer
//                                                        attribute:NSLayoutAttributeBottom
//                                                       multiplier:1 constant:TapButtonBottomToBottom]];
//    
//    [constraints addObjectsFromArray:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tapCountLabel]-(>=10)-[_buttonContainer]"
//                                             options:NSLayoutFormatAlignAllCenterX
//                                             metrics:nil views:views]];
//    
//    [constraints addObjectsFromArray:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_progressView]-|"
//                                             options:(NSLayoutFormatOptions)0
//                                             metrics:nil views:views]];
//    NSLayoutConstraint *wideProgress = [NSLayoutConstraint constraintWithItem:_progressView
//                                                                    attribute:NSLayoutAttributeWidth
//                                                                    relatedBy:NSLayoutRelationEqual
//                                                                       toItem:nil
//                                                                    attribute:NSLayoutAttributeNotAnAttribute
//                                                                   multiplier:1
//                                                                     constant:2000];
//   wideProgress.priority = UILayoutPriorityRequired-1;
//    [constraints addObject:wideProgress];
//    
//    _constraints = constraints;
//    [self addConstraints:_constraints];
//    
//    [NSLayoutConstraint activateConstraints:constraints];
//    [super updateConstraints];
//}

@end
