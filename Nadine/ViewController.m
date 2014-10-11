//
//  ViewController.m
//  Nadine
//
//  Created by Will Clarke on 10/3/14.
//  Copyright (c) 2014 Office Nomads. All rights reserved.
//

#import "ViewController.h"
#import "SettingsViewController.h"
#define NADINE_BASE_URL @"http://apps.officenomads.com/"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topButtons;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [UIApplication sharedApplication].idleTimerDisabled = [self getDayMode];
}

- (void)viewDidAppear:(BOOL)animated {
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
    NSURL *nadineURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@tablet/members/", [self getBaseURL]]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nadineURL];
    [self.mainWebView loadRequest:request];
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
    if ([host isEqualToString:[self getBaseHostName]]) {
        // Add any of your own domains in the above line
        return YES;
    }
    
    return NO;
}

- (NSString *)getBaseHostName {
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"ONhostname"]) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:@"ONhostname"];
    } else {
        return @"apps.officenomads.com";
    }
}

- (NSString *)getBaseURL {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ONhostname"]) {
        return [NSString stringWithFormat:@"http://%@/", [[NSUserDefaults standardUserDefaults] stringForKey:@"ONhostname"]];
    } else {
        return NADINE_BASE_URL;
    }
}

- (BOOL)getDayMode {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ONdayMode"]) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:@"ONdayMode"];
    } else {
        return YES;
    }
}

@end
