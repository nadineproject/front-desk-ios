//
//  ViewController.m
//  Nadine
//
//  Created by Will Clarke on 10/3/14.
//  Copyright (c) 2014 Office Nomads. All rights reserved.
//

#import "ViewController.h"
#define NADINE_BASE_URL @"http://172.16.4.29:8000/"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;

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


@end
