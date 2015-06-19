//
//  ORKDrawingContentView.h
//  ResearchKit
//
//  Created by Bryan Weber on 6/6/15.
//  Copyright (c) 2015 researchkit.org. All rights reserved.
//

#import "ORKCustomStepView_Internal.h"
#import "ORKRoundTappingButton.h"


NS_ASSUME_NONNULL_BEGIN

@interface ORKDrawingContentView : ORKActiveStepCustomView

@property (nonatomic, strong) NSMutableArray *paths;

@end

NS_ASSUME_NONNULL_END
