//
//  CustomAnnotationView.m
//  CustomAnnotationWithDrawRect
//
//  Created by Robert Ryan on 5/23/15.
//  Copyright (c) 2015 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/

#import "CustomAnnotationView.h"

void * const kAnnotationViewContext = "com.domain.app.annotation";

@interface CustomAnnotationView ()
@property (nonatomic) CGFloat width;
@end

@implementation CustomAnnotationView

// Instantiate new annotation
//
// When we instantiate a new annotation view:
//
//   - add a `UILabel`
//
//   - add an observer for the `text` property of the `UILabel` (so that we
//     can adjust the width and center offset of the annotation).

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:8];;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        self.label = label;
        
        [label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:kAnnotationViewContext];

        [self updateLabelForAnnotation:annotation];
        
        self.opaque = false;
        self.centerOffset = CGPointMake(0, -11);
    }
    return self;
}

// Deallocate annotation view
//
// Make sure to remove the observer before this is deallocated

- (void)dealloc {
    [self.label removeObserver:self forKeyPath:@"text" context:kAnnotationViewContext];
}

// Standard observer method
//
// If the label text changed, adjust the label width

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kAnnotationViewContext) {
        [self adjustLabelBubbleWidth:change[NSKeyValueChangeNewKey]];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// Custom `annotation` setter
//
// When we set/change the annotation, call method that updates the label

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    
    [self updateLabelForAnnotation:annotation];
}

/// Update label for annotation
///
/// Actually update the label
///
/// @param annotation The id<MKAnnotation> annotation.

- (void)updateLabelForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation respondsToSelector:@selector(title)]) {
        self.label.text = annotation.title;
    } else {
        self.label.text = nil;
    }
}

/// Adjust label bubble width
///
/// Actually update the label
///
/// @param string The string whose width must be calculated.

- (void)adjustLabelBubbleWidth:(NSString *)string {
    if ([string isKindOfClass:[NSString class]] && self.label) {
        NSDictionary *attributes = @{ NSFontAttributeName : self.label.font };
        CGSize size = [string sizeWithAttributes:attributes];
        self.width = MAX(size.width + 6, 22);
    } else {
        self.width = 22;
    }
    
    self.label.frame = CGRectMake(0, 33, self.width, 10);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, 44);
    
    [self setNeedsDisplay];                   // make sure to call `setNeedsDisplay` or else annotation view can be distorted in transform
    self.centerOffset = CGPointMake(0, -11);  // make sure to reset `centerOffset` so that if the annotation view is resized, that it's still centered properly
}

// Draw annotation view
//
// Draw the annotation view consisting of teardrop shaped pin with white center
// and, optionally, the bubble where the UILabel will appear.

- (void)drawRect:(CGRect)rect {
    CGFloat lineWidth = 1.0;
    CGFloat radius = 10 + lineWidth / 2.0;
    CGFloat bubbleHeight = 20;
    CGPoint point = CGPointMake(self.width / 2.0, 31);
    CGPoint nextPoint;
    
    // draw the main pin
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point];

    nextPoint = CGPointMake(point.x - radius, point.y - bubbleHeight);
    [path addCurveToPoint:nextPoint controlPoint1:CGPointMake(point.x, point.y - bubbleHeight / 2.0) controlPoint2:CGPointMake(nextPoint.x, nextPoint.y + bubbleHeight / 2.0)];
    
    CGPoint center = CGPointMake(point.x, nextPoint.y);
    [path addArcWithCenter:center radius:radius startAngle:M_PI endAngle:0 clockwise:TRUE];
    
    point = CGPointMake(nextPoint.x + radius * 2.0, nextPoint.y);
    nextPoint = CGPointMake(point.x - radius, point.y + bubbleHeight);
    [path addCurveToPoint:nextPoint controlPoint1:CGPointMake(point.x, point.y + bubbleHeight / 2.0) controlPoint2:CGPointMake(nextPoint.x, nextPoint.y - bubbleHeight / 2.0)];
    
    [[UIColor blackColor] setStroke];
    [[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.8] setFill];
    path.lineWidth = lineWidth;
    
    [path fill];
    [path stroke];
    
    // draw white filled center
    
    path = [UIBezierPath bezierPathWithArcCenter:center radius:radius / 3.0 startAngle:0 endAngle:M_PI * 2.0 clockwise:TRUE];
    path.lineWidth = lineWidth;
    [[UIColor whiteColor] setFill];
    [path fill];

    // if we need it, draw the bubble around the label
    
    if ([self.label.text length] > 0) {
        CGRect bubbleRect = CGRectMake(1, 33, self.width - 2.0, 10);
        path = [UIBezierPath bezierPathWithRoundedRect:bubbleRect cornerRadius:5];
        path.lineWidth = lineWidth;
        [[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.8] setFill];
        [path fill];
        [path stroke];
    }
}

@end
