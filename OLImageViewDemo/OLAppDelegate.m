//
//  OLAppDelegate.m
//  OLImageViewDemo
//
//  Created by Diego Torres on 9/5/12.
//  Copyright (c) 2012 Onda Labs. All rights reserved.
//

#import "OLAppDelegate.h"
#import "OLImageView.h"
#import "OLImage.h"

@implementation OLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UIViewController *normalAnimatedVC = [UIViewController new];
    normalAnimatedVC.title = @"UIImageView";
    UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage animatedImageNamed:@"BB" duration:1.6]];
    normalAnimatedVC.view = imv;
    
    UIViewController *magicAnimatedVC = [UIViewController new];
    magicAnimatedVC.title = @"OLImageView";
    OLImageView *Aimv = [OLImageView new];

    Aimv = [[OLImageView alloc] initWithImage:[OLImage imageNamed:@"notEven.gif"]];
    [Aimv setFrame:CGRectMake(0, 0, 200, 200)];
    UITapGestureRecognizer *gestTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [Aimv setUserInteractionEnabled:YES];
    [Aimv addGestureRecognizer:gestTap];
    [magicAnimatedVC.view addSubview:Aimv];
    
    Aimv = [[OLImageView alloc] initWithImage:[OLImage imageNamed:@"BLEH.gif"]];
    [Aimv setFrame:CGRectMake(0, 200, 200, 200)];
    [magicAnimatedVC.view addSubview:Aimv];
    
    Aimv = [[OLImageView alloc] initWithImage:[OLImage imageNamed:@"fdgdf.gif"]];
    [Aimv setFrame:CGRectMake(200, 0, 200, 200)];
    [magicAnimatedVC.view addSubview:Aimv];
    
    Aimv = [[OLImageView alloc] initWithImage:[OLImage imageNamed:@"AA.gif"]];
    [Aimv setFrame:CGRectMake(200, 200, 200, 200)];
    [magicAnimatedVC.view addSubview:Aimv];
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    
    [tbc setViewControllers:[NSArray arrayWithObjects:normalAnimatedVC, magicAnimatedVC, nil]];
    self.window.rootViewController = tbc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)gestRecon
{
    OLImageView *imageView = (OLImageView *)gestRecon.view;
    if (imageView.isAnimating) {
        NSLog(@"STOP");
        [imageView stopAnimating];
    } else {
         NSLog(@"START");
        [imageView startAnimating];
    }
}

@end
