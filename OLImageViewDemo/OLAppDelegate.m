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
    UIImageView *imv = [UIImageView new];
    imv.image = [UIImage animatedImageNamed:@"BB" duration:1.6];
    normalAnimatedVC.view = imv;
    
    UIViewController *magicAnimatedVC = [UIViewController new];
    magicAnimatedVC.title = @"OLImageView";
    OLImageView *Aimv = [OLImageView new];
        
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"notEven" ofType:@"gif"];
    NSData *GIFDATA = [NSData dataWithContentsOfFile:filePath];
    Aimv.image = [OLImage imageWithData:GIFDATA];
    [Aimv setFrame:CGRectMake(0, 0, 200, 200)];
    UITapGestureRecognizer *gestTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [Aimv setUserInteractionEnabled:YES];
    [Aimv addGestureRecognizer:gestTap];
    [magicAnimatedVC.view addSubview:Aimv];
    
    Aimv = [OLImageView new];
    filePath = [[NSBundle mainBundle] pathForResource:@"BLEH" ofType:@"gif"];
    GIFDATA = [NSData dataWithContentsOfFile:filePath];
    Aimv.image = [OLImage imageWithData:GIFDATA];
    [Aimv setFrame:CGRectMake(0, 200, 200, 200)];
    [magicAnimatedVC.view addSubview:Aimv];
    
    Aimv = [OLImageView new];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"fdgdf" ofType:@"gif"];
    GIFDATA = [NSData dataWithContentsOfFile:filePath];
    Aimv.image = [OLImage imageWithData:GIFDATA];
    [Aimv setFrame:CGRectMake(200, 0, 200, 200)];
    [magicAnimatedVC.view addSubview:Aimv];
    
    Aimv = [OLImageView new];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"AA" ofType:@"gif"];
    GIFDATA = [NSData dataWithContentsOfFile:filePath];
    Aimv.image = [OLImage imageWithData:GIFDATA];
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

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
