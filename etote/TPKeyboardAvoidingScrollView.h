//
//  TPKeyboardAvoidingScrollView.h
//
//  Created by Michael Tyson on 11/04/2011.
//  Copyright 2011 A Tasty Pixel. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

@interface TPKeyboardAvoidingScrollView : UIScrollView {
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
}

// Returns the view's layer. Useful if you want to access CAGradientLayer-specific properties
// because you can omit the typecast.
@property (nonatomic, readonly) CAGradientLayer *gradientLayer;

// Gradient-related properties are forwarded to layer.
// colors also accepts array of UIColor objects (in addition to array of CGColorRefs).
@property (nonatomic, retain) NSArray *colors;
@property (nonatomic, retain) NSArray *locations;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic, copy) NSString *type;

- (void)adjustOffsetToIdealIfNeeded;
@end
