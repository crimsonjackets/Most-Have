//
//  BRMAPViewController.m
//  BridgeSPB
//
//  Created by Stas on 12.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRMAPViewController.h"
#import "Bridge.h"
#import "Annotation.h"
#import "OneBridge.h"
#import "BRBridgeViewController.h"
#import "MoreInfoViewController.h"
#import <MapKit/MapKit.h>
#import "InitSlViewController.h"
#import "MHBridgeInfo.h"

#define METERS_PER_MILE 1609.344

@interface BRMAPViewController ()
{
    IBOutlet CLLocationManager *locationManager;
    UIImageView * rightImage;
    UIImageView * leftImage;
    float yMenuBot;
}
@end

@implementation BRMAPViewController
@synthesize map;
@synthesize bridges;

@synthesize button;
@synthesize laftBut;
@synthesize viewInfoMap;
@synthesize menu;

- (void)viewDidAppear:(BOOL)animated
{
    [bridges refreshLoad:YES];
    NSMutableArray * annotationsToRemove = [ map.annotations mutableCopy ] ;
    [ annotationsToRemove removeObject:map.userLocation ] ;
    [ map removeAnnotations:annotationsToRemove ] ;
    for(int i=0;i<13;i++)
    {
        [self inputAnnoWith:i];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    locationManager = [[CLLocationManager alloc] init];
    
    
    if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)&&([UIScreen mainScreen].bounds.size.height == 568.0))
    {
        yMenuBot=91;
        
    }
    else
    {
        yMenuBot=0;
    }
    
    
    
    //CGRect frame=menu.frame;
    //frame.origin.y+=yMenuBot;
    //menu.frame=frame;
    
    //frame=self.goToCur.frame;
    //frame.origin.y+=yMenuBot;
    //self.goToCur.frame=frame;
    
    //frame=map.frame;
    //frame.size.height+=yMenuBot;
    //map.frame=frame;
    
    //frame=viewInfoMap.frame;
    //frame.origin.y+=yMenuBot;
    //viewInfoMap.frame=frame;
    
    [self.view insertSubview:menu aboveSubview:viewInfoMap];
    
    viewInfoMap.layer.cornerRadius=5;
    
    self.bridges=[Bridge initWithView:self.view belowBiew:self.map];
    leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 30)];
    rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(260, 30, 35, 5)];
    NSArray *imageLeftRight=[NSArray arrayWithObjects:rightImage,leftImage, nil];
    self.view=[BRAppHelpers addHeadonView:self.view andImages:imageLeftRight withTarget:self];
    rightImage.image=[UIImage imageNamed:@"butClose.png"];
    leftImage.image=[UIImage imageNamed:@"Back.png"];
    [bridges refreshLoad:YES];
    button.layer.cornerRadius=5;
    laftBut.layer.cornerRadius=5;
    button.layer.borderColor=[[UIColor blackColor] CGColor];
    button.layer.borderWidth=2;
    laftBut.layer.borderColor=[[UIColor blackColor] CGColor];
    laftBut.layer.borderWidth=2;
    
    map.showsUserLocation = YES;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(59.921732f, 30.358286f), 7*METERS_PER_MILE, 7*METERS_PER_MILE);
    
    
    MKCoordinateRegion adjustRegion = [self.map regionThatFits:viewRegion];
    [map setRegion:adjustRegion animated:YES];
    
}



-(void) inputAnnoWith:(NSInteger)index
{
    if (index == 12) return;
    OneBridge *bridge=[self.bridges.bridges objectForKey:[NSNumber numberWithInt:index]] ;
    Annotation *annotation2 = [Annotation new];
    annotation2.index=index;
    annotation2.title = bridge.name;
    annotation2.subtitle = bridge.info;
    annotation2.coordinate = CLLocationCoordinate2DMake(bridge.coord.x, bridge.coord.y);
    [map addAnnotation:annotation2];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(Annotation*)annotation
{
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    //Новые данные
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"bridgesInfo"];
    NSArray *newBridgesInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //Массив, отображающий индексы старых данных на индексы новых
    int indexInNew[13] = {0, 1, 4, 5, 6, 7, 8, 3, 2, 10, 11, 12, 9};
    MHBridgeInfo *currBridgeInfo = newBridgesInfo[indexInNew[annotation.index]];
    
    MKAnnotationView * annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    
    
    if (annotation.index < 12){
        annotationView.image = [UIImage imageNamed: @"annOpen.png"];
    } else {
        return nil;
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComps = [calendar components:(  NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:currentDate];
    NSInteger currTime = currentComps.hour * 60 + currentComps.minute;
    
    if(currTime >= currBridgeInfo.openTime && currTime <= currBridgeInfo.closeTime){
        annotationView.image = [UIImage imageNamed: @"annClose.png"];
    }
    if (currTime >= currBridgeInfo.openTime - 30 && currTime < currBridgeInfo.openTime){
        annotationView.image = [UIImage imageNamed: @"annWait.png"];
    }
    
    if (currBridgeInfo.isOpenedTwoTimes){
        if(currTime >= currBridgeInfo.openTime2 && currTime <= currBridgeInfo.closeTime2){
            annotationView.image = [UIImage imageNamed: @"annClose.png"];
        }
        if (currTime >= currBridgeInfo.openTime2 - 30 && currTime < currBridgeInfo.openTime2){
            annotationView.image = [UIImage imageNamed: @"annWait.png"];
        }
    }
    
    
    
    if(annotation.index<9)
    {
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    } else {
        annotationView.image = [UIImage imageNamed: @"annOpen.png"];
    }
    annotationView.canShowCallout = YES;
    annotationView.frame=CGRectMake(0, 0, 14, 20);
    
    return annotationView;
    
    
}


- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    Annotation *annotationTapped = (Annotation *)view.annotation;
    BRBridgeViewController *back=[self.storyboard instantiateViewControllerWithIdentifier:@"bridgeTop"];
    NSInteger index=annotationTapped.index;
    OneBridge *bridge=[self.bridges.bridges objectForKey:[NSNumber numberWithInt:index]] ;
    back.bridge=bridge;
    [self.navigationController pushViewController:back animated:YES];
    
    //Annotation *annotationTapped = (Annotation *)view.annotation;
    
    //
    //    DetailViewController *detail = [DetailViewController new];
    //
    //   // detail=segue.destinationViewController;
    //
    //    ScaryBugDoc *bug = [self.bugs objectAtIndex:0];
    //    detail.detailItem = bug;
    //    [self.navigationController pushViewController:detail animated:YES];
    
}

- (IBAction)toGraph:(id)sender {
    MoreInfoViewController *back=[self.storyboard instantiateViewControllerWithIdentifier:@"graph"];
    back.yMenu=403+yMenuBot;
    
    //[self.navigationController popViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:NO];
    
}




-(void)leftMenu:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.75f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(map.frame.origin.y>60)
    {
        UITouch *touch = [touches anyObject];
        CGPoint touchPnt = [touch locationInView:self.view];
        
        NSInteger index=[self.bridges findBridge:touchPnt];
        [self.bridges Information:index];
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{ if(map.frame.origin.y>60)
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];
    
    NSInteger index=[self.bridges findBridge:touchPnt];
    
    [self.bridges Information:index];
}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(map.frame.origin.y>60)
    {
        UITouch *touch = [touches anyObject];
        CGPoint touchPnt = [touch locationInView:self.view];
        
        [self.bridges Information:-1];
        NSInteger index=[self.bridges findBridge:touchPnt];
        if (index>=0) {
            
            BRBridgeViewController *back=[self.storyboard instantiateViewControllerWithIdentifier:@"bridgeTop"];
            OneBridge *bridge=[self.bridges.bridges objectForKey:[NSNumber numberWithInt:index]] ;
            back.bridge=bridge;
            [self.navigationController pushViewController:back animated:YES];
            
        }
    }
}

-(void)hideBridge:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect frameCur=self.goToCur.frame;
    CGRect frame=map.frame;
    if(frame.origin.y>60)
    {
        frameCur.origin.y-=80;
        frame.origin.y=60;
        frame.size.height+=80;
        map.frame=frame;
        self.goToCur.frame=frameCur;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butClose.png"];
    }
    else
    {
        frameCur.origin.y+=80;
        frame.origin.y=140;
        frame.size.height-=80;
        map.frame=frame;
        self.goToCur.frame=frameCur;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butOpen.png"];
    }
    [self.bridges refreshLoad:NO];
    
    
}

-(void)updateStuff
{
    
    [bridges refreshLoad:YES];
    NSMutableArray * annotationsToRemove = [ map.annotations mutableCopy ] ;
    [ annotationsToRemove removeObject:map.userLocation ] ;
    [ map removeAnnotations:annotationsToRemove ] ;
    for(int i=0;i<13;i++)
    {
        [self inputAnnoWith:i];
    }
    
}

-(void)goToPush
{
    InitSlViewController * pushView=[self.storyboard instantiateViewControllerWithIdentifier:@"InitSlider"];
    pushView.controller=@"PUSHTop";
    [self.navigationController pushViewController:pushView animated:YES];
}

-(void)goHome
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.75f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



-(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    NSString *urlString = [NSString stringWithFormat:@"http://nominatim.openstreetmap.org/search?format=xml&lat=%f&lon=%f&zoom=18&addressdetails=1&accept-language=ru",pdblLatitude, pdblLongitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    
    
    locationString = [locationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return [locationString substringFromIndex:6];
}

- (BOOL)shouldAutorotate {
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (IBAction)showCurrentLocation {
    [map setCenterCoordinate:map.userLocation.coordinate animated:YES];
}

@end
