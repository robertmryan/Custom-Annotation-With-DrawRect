//
//  ViewController.m
//  CustomAnnotationWithDrawRect
//
//  Created by Robert Ryan on 5/26/15.
//  Copyright (c) 2015 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/

#import "ViewController.h"
#import "CustomAnnotationView.h"

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic) NSInteger annotationNumber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titles = @[@"Moses Harry Horwitz", @"Louis Feinberg", @"Me"];
}

- (void)viewDidAppear:(BOOL)animated {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Click \"Drop Pin\" to drop pin on center of the map, then move map, and repeat." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - IBActions

// When we drop pin, instantiate `MKPointAnnotation` and set the title for the annotation.
// Our custom annotation view will display the `title` underneath the pin.
//
// We'll look up the title in our array of titles, and when we run out, we'll just spell out
// the annotation number.

- (IBAction)didTapDropPinButton:(UIButton *)sender {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    if (self.annotationNumber < self.titles.count) {
        annotation.title = self.titles[self.annotationNumber];
    } else {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterSpellOutStyle;
        annotation.title = [formatter stringFromNumber:@(self.annotationNumber + 1)];
    }
    self.annotationNumber++;
    
    annotation.coordinate = self.mapView.centerCoordinate;
    [self.mapView addAnnotation:annotation];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"CustomAnnotation";
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        CustomAnnotationView *view = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (view) {
            view.annotation = annotation;
        } else {
            view = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        return view;
    }
    return nil;
}

@end
