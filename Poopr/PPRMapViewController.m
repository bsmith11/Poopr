//
//  PPRMapViewController.m
//  Poopr
//
//  Created by Bradley Smith on 9/13/15.
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

@import MapKit;

#import "PPRMapViewController.h"
#import "PPRSettingsViewController.h"

#import "PPRPoopListViewModel.h"
#import "PPRSettingsViewModel.h"

#import "PPRPoopAnnotationView.h"

#import "PPRPlacemark+RZImport.h"

#import "PPRSettings.h"
#import "PPRLog.h"

#import "MKAnnotationView+PPRReuse.h"
#import "UIAlertController+PPRExtensions.h"

#import <RZCollectionList/RZCollectionList.h>
#import <RZDataBinding/RZDataBinding.h>
#import <RZUtils/RZCommonUtils.h>

static NSString * const kPPRMapTitle = @"Map";

@interface PPRMapViewController () <MKMapViewDelegate, RZCollectionListObserver>

@property (strong, nonatomic) PPRPoopListViewModel *viewModel;
@property (strong, nonatomic) UIBarButtonItem *poopBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *spinnerBarButtonItem;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation PPRMapViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(PPRPoopListViewModel *)viewModel {
    self = [super init];

    if (self) {
        _viewModel = viewModel;
        [_viewModel.poops addCollectionListObserver:self];
        
        self.title = kPPRMapTitle;
        [self setupTabBarItem];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBarButtonItems];
    [self setupMapView];
    [self setupObservers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.mapView addAnnotations:self.viewModel.poops.listObjects];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPPRSettingsRadiusDidChangeNotification object:nil];
}

#pragma mark - Setup

- (void)setupTabBarItem {
    UIImage *image = [UIImage imageNamed:@"map_icon"];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:image selectedImage:nil];
}

- (void)setupBarButtonItems {
    UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings Icon"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapSettingsBarButtonItem)];
    [self.navigationItem setLeftBarButtonItem:settingsBarButtonItem animated:YES];

    self.poopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapPoopBarButtonItem)];

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spinner.color = [UIColor blackColor];
    self.spinnerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];

    [self showPoopBarButtonItem];
}

- (void)setupMapView {
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
}

- (void)setupObservers {
    [self.viewModel rz_addTarget:self action:@selector(updateSpinner:) forKeyPathChange:RZDB_KP_OBJ(self.viewModel, loading) callImmediately:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(radiusDidChange) name:kPPRSettingsRadiusDidChangeNotification object:nil];
}

#pragma mark - Actions

- (void)didTapSettingsBarButtonItem {
    PPRSettingsViewModel *viewModel = [[PPRSettingsViewModel alloc] init];
    PPRSettingsViewController *settingsViewController = [[PPRSettingsViewController alloc] initWithViewModel:viewModel];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];

    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)didTapPoopBarButtonItem {
    __weak __typeof (self) welf = self;

    [self.viewModel addPoopWithCompletion:^(NSError *error) {
        if (error) {
            DDLogError(@"Failed to add poop with error: %@", error);

            UIAlertController *alertController = [UIAlertController ppr_alertControllerWithError:error];
            [welf presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)showPoopBarButtonItem {
    [self.spinner stopAnimating];

    [self.navigationItem setRightBarButtonItem:self.poopBarButtonItem animated:YES];
}

- (void)showSpinnerBarButtonItem {
    [self.spinner startAnimating];

    [self.navigationItem setRightBarButtonItem:self.spinnerBarButtonItem animated:YES];
}

- (void)updateSpinner:(NSDictionary *)change {
    NSNumber *loading = RZNSNullToNil(change[kRZDBChangeKeyNew]);

    if (loading.boolValue) {
        [self showSpinnerBarButtonItem];
    }
    else {
        [self showPoopBarButtonItem];
    }
}

- (void)radiusDidChange {
    [self addPoopRadiusOverlayToMapView:self.mapView];
}

- (void)addPoopRadiusOverlayToMapView:(MKMapView *)mapView {
    [mapView removeOverlays:mapView.overlays];

    if (mapView.userLocation) {
        CLLocationDistance radius = [PPRSettings radius].doubleValue;

        MKCircle *circle = [MKCircle circleWithCenterCoordinate:mapView.userLocation.coordinate radius:radius];
        [mapView addOverlay:circle];
    }
}

#pragma mark - Map View Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    PPRPoopAnnotationView *annotationView = nil;
    
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        PPRPoopAnnotationView *poopAnnotationView = (PPRPoopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:[PPRPoopAnnotationView ppr_reuseIdentifier]];

        if (!poopAnnotationView) {
            poopAnnotationView = [[PPRPoopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[PPRPoopAnnotationView ppr_reuseIdentifier]];
        }

        annotationView = poopAnnotationView;
    }

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationDistance radius = [PPRSettings radius].doubleValue;

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, radius * 2, radius * 2);
    [mapView setRegion:region animated:YES];

    self.mapView.showsUserLocation = NO;

    [self addPoopRadiusOverlayToMapView:mapView];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleRenderer.strokeColor = [UIColor brownColor];
    circleRenderer.fillColor = [[UIColor brownColor] colorWithAlphaComponent:0.2f];
    circleRenderer.lineWidth = 1.0f;

    return circleRenderer;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
//    PPRPoop *poop = (PPRPoop *)view.annotation;
}

#pragma mark - Collection List Observer Protocol

- (void)collectionListWillChangeContent:(id<RZCollectionList>)collectionList {
    //no-op
}

- (void)collectionList:(id<RZCollectionList>)collectionList didChangeSection:(id<RZCollectionListSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(RZCollectionListChangeType)type {
    //no-op
}

- (void)collectionList:(id<RZCollectionList>)collectionList didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath forChangeType:(RZCollectionListChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case RZCollectionListChangeDelete:
            [self.mapView removeAnnotation:object];
            break;

        case RZCollectionListChangeInsert:
            [self.mapView addAnnotation:object];
            break;

        case RZCollectionListChangeMove:
        case RZCollectionListChangeUpdate:
        case RZCollectionListChangeInvalid:
            //no-op
            break;
    }
}

- (void)collectionListDidChangeContent:(id<RZCollectionList>)collectionList {
    //no-op
}

@end
