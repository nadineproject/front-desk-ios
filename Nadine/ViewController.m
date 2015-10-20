//
//  ViewController.m
//  Nadine
//
//  Created by Will Clarke on 10/3/14.
//  Copyright (c) 2014 Office Nomads. All rights reserved.
//

#import "ViewController.h"
#import "SettingsViewController.h"
#define NADINE_BASE_URL @"https://apps.officenomads.com/"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topButtons;
@property (weak, nonatomic) IBOutlet UIButton *membersButton;
@property (weak, nonatomic) IBOutlet UIButton *hereTodayButton;
@property (weak, nonatomic) IBOutlet UIButton *visitorsButton;
@property (weak, nonatomic) UIButton *currentButton;
@property (strong, nonatomic) NSTimer *screenCheckTimer;
@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenCheckTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                             target:self
                                                           selector:@selector(updateIdleTimer)
                                                           userInfo:nil
                                                            repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSURL *nadineURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@tablet/", [self getBaseURL]]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nadineURL];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) {
             [self.mainWebView loadRequest:request];
         } else if (error != nil) {
             NSLog(@"Error: %@", error);
         }
     }];
    [self updateIdleTimer];
    self.currentButton = self.membersButton;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)refreshButtonTapped:(id)sender {
    [self.mainWebView reload];
}

- (IBAction)homeButtonTapped:(id)sender {
    [self membersButtonTapped:self.membersButton];
}

- (void)clearButtonsAndSetActive:(UIButton *)activeButton {
    for (UIButton *currentButton in self.topButtons) {
        if (currentButton == activeButton) {
            currentButton.backgroundColor = [UIColor colorWithRed:51/255.f green:136/255.f blue:204/255.f alpha:1];
            [currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            currentButton.backgroundColor = [UIColor colorWithWhite:246/255.f alpha:1];
            [currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    self.currentButton = activeButton;
}

- (IBAction)membersButtonTapped:(id)sender {
    [self clearButtonsAndSetActive:(UIButton *)sender];
    NSURL *nadineURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@tablet/members/", [self getBaseURL]]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nadineURL];
    [self.mainWebView loadRequest:request];
}

- (IBAction)hereTodayButtonTapped:(id)sender {
    [self clearButtonsAndSetActive:(UIButton *)sender];
    NSURL *nadineURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@tablet/here_today/", [self getBaseURL]]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nadineURL];
    [self.mainWebView loadRequest:request];
}

- (IBAction)visitorsButtonTapped:(id)sender {
    [self clearButtonsAndSetActive:(UIButton *)sender];
    NSURL *nadineURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@tablet/visitors/", [self getBaseURL]]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nadineURL];
    [self.mainWebView loadRequest:request];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Assuming you've hooked this all up in a Storyboard with a popover presentation style
    if ([segue.identifier isEqualToString:@"showPopover"]) {
        SettingsViewController *destNav = segue.destinationViewController;
        
        // This is the important part
        UIPopoverPresentationController *popPC = destNav.popoverPresentationController;
        popPC.delegate = self;
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *host = [request.URL host];
    NSArray *pathParts = [request.URL pathComponents];
    
    if (pathParts.count > 2 && [pathParts[2] isEqualToString:@"members"] && self.currentButton != self.membersButton) {
        [self membersButtonTapped:self.membersButton];
    }
    if (pathParts.count > 2 && [pathParts[2] isEqualToString:@"here_today"] && self.currentButton != self.hereTodayButton) {
        [self membersButtonTapped:self.hereTodayButton];
    }
    if (pathParts.count > 2 && [pathParts[2] isEqualToString:@"visitors"] && self.currentButton != self.visitorsButton) {
        [self membersButtonTapped:self.visitorsButton];
    }
    
    if ([host isEqualToString:[self getBaseHostName]]) {
        // Add any of your own domains in the above line
        return YES;
    }
    
    return NO;
}

- (NSString *)getBaseHostName {
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"ONhostname"]) {
        NSString *hostname = [[NSUserDefaults standardUserDefaults] stringForKey:@"ONhostname"];
        if ([hostname rangeOfString:@":"].location != NSNotFound) {
            return [hostname substringToIndex:[hostname rangeOfString:@":"].location];
        } else {
            return hostname;
        }
    } else {
        return @"apps.officenomads.com";
    }
}

- (NSString *)getBaseURL {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ONhostname"]) {
        return [NSString stringWithFormat:@"https://%@/", [[NSUserDefaults standardUserDefaults] stringForKey:@"ONhostname"]];
    } else {
        return NADINE_BASE_URL;
    }
}

- (void)updateIdleTimer {
    NSDate *today = [NSDate date];
    NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
    [weekFormatter setDateFormat:@"EEEE"];
    [weekFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *dayOfWeek = [weekFormatter stringFromDate:today];
    
    if ([dayOfWeek isEqualToString:@"Saturday"] || [dayOfWeek isEqualToString:@"Sunday"]) {
        //ON is closed on weekends!
        [UIApplication sharedApplication].idleTimerDisabled = NO;
            return;
    }

    NSString *openingTimeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"ONOpeningTime"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"ONOpeningTime"] : @"8:30 AM";
    NSString *closingTimeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"ONClosingTime"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"ONClosingTime"] : @"6:00 PM";

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d-M-Y"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
    [dateTimeFormatter setDateFormat:@"d-M-Y h:mm a"];
    [dateTimeFormatter setTimeZone:[NSTimeZone systemTimeZone]];

    NSString *todayDateString = [dateFormatter stringFromDate:today];
    NSDate *todayOpening = [dateTimeFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", todayDateString, openingTimeString]];
    NSDate *todayClosing = [dateTimeFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", todayDateString, closingTimeString]];
    NSDate *todayDateAdjusted = [dateTimeFormatter dateFromString:[NSString stringWithFormat:@"%@", [dateTimeFormatter stringFromDate:today]]];
    
    if (([todayOpening compare:todayDateAdjusted] == NSOrderedAscending) && ([todayClosing compare:todayDateAdjusted] == NSOrderedDescending)) {
        //ON is currently OPEN!
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    } else {
        //ON is CLOSED!
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}

@end
