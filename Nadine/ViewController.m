//
//  ViewController.m
//  Nadine
//
//  Created by Will Clarke on 10/3/14.
//  Copyright (c) 2014 Office Nomads. All rights reserved.
//

#import "ViewController.h"

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
    NSURL *nadineURL = [NSURL URLWithString: @"http://172.16.4.29:8000/tablet/"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nadineURL];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) [self.mainWebView loadRequest:request];
         else if (error != nil) NSLog(@"Error: %@", error);
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
    NSLog(@"Refresh Button Tapped");
}

- (IBAction)homeButtonTapped:(id)sender {
    NSLog(@"Home Button Tapped");
}


@end
