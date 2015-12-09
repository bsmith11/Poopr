//
//  PPRPoopAnnotationView.m
//  Poopr
//
//  Created by Bradley Smith on 9/13/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "PPRPoopAnnotationView.h"

static NSString * const kPPRPoopAnnotationLabelText = @"💩";

@interface PPRPoopAnnotationView ()

@property (strong, nonatomic) UILabel *poopLabel;

@end

@implementation PPRPoopAnnotationView

#pragma mark - Lifecycle

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];

    if (self) {
        self.canShowCallout = YES;
        self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        [self setupPoopLabel];

        CGRect frame = self.frame;
        frame.size = self.poopLabel.frame.size;
        self.frame = frame;
    }

    return self;
}

#pragma mark - Setup

- (void)setupPoopLabel {
    self.poopLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.poopLabel.font = [UIFont systemFontOfSize:24.0f];
    self.poopLabel.text = kPPRPoopAnnotationLabelText;
    [self.poopLabel sizeToFit];

    [self addSubview:self.poopLabel];
}

@end
