//
//  ViewController.m
//  Nadine
//
//  Created by Will Clarke on 10/3/14.
//  Copyright (c) 2014 Office Nomads. All rights reserved.
//

#import "ViewController.h"
#define NADINE_BASE_URL @"http://apps.officenomads.com/"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topButtons;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    NSURL *nadineURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@tablet/", NADINE_BASE_URL]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nadineURL];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) [self.mainWebView loadRequest:request];
         else if (error != nil) NSLog(@"Error: %@", error);
     }];
    self.mainWebView.scrollView.bounces = NO;
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
    NSLog(@"Refresh Button Tapped");
}

- (IBAction)homeButtonTapped:(id)sender {
    NSURL *nadineURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@tablet/members/", NADINE_BASE_URL]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nadineURL];
    [self.mainWebView loadRequest:request];
    NSLog(@"Home Button Tapped");
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
    NSURL *nadineURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@tablet/members/", NADINE_BASE_URL]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nadineURL];
    [self.mainWebView loadRequest:request];
}

- (IBAction)hereTodayButtonTapped:(id)sender {
    [self clearButtonsAndSetActive:(UIButton *)sender];
    NSURL *nadineURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@tablet/here_today/", NADINE_BASE_URL]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nadineURL];
    [self.mainWebView loadRequest:request];
}

- (IBAction)visitorsButtonTapped:(id)sender {
    [self clearButtonsAndSetActive:(UIButton *)sender];
    NSURL *nadineURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@tablet/visitors/", NADINE_BASE_URL]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nadineURL];
    [self.mainWebView loadRequest:request];
}

@end
