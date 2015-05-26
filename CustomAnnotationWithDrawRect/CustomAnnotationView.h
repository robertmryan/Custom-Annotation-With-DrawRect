//
//  CustomAnnotationView.h
//  CustomAnnotationWithDrawRect
//
//  Created by Robert Ryan on 5/23/15.
//  Copyright (c) 2015 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/

#import <MapKit/MapKit.h>

/** Custom MKAnnotationView subclass
 
 This draws a teardrop-shaped pin with a label below it. Note, this implementation
 just uses the annotation's `title` property for the label underneath the pin. You
 can use whatever property you want, but `title` is a standard used by
 `MKPointAnnotation`, so it seemed like a logical choice.
 */

@interface CustomAnnotationView : MKAnnotationView

@property (nonatomic, strong) UILabel *label;

@end
