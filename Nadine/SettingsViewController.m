//
//  SettingsViewController.m
//  Nadine
//
//  Created by Will Clarke on 10/10/14.
//  Copyright (c) 2014 Office Nomads. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *hostnameText;
@property (weak, nonatomic) IBOutlet UISwitch *dayModeSwitch;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(280.f, 300.f);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ONhostname"]) {
        self.hostnameText.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"ONhostname"];
    } else {
        self.hostnameText.text = @"apps.officenomads.com";
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ONdayMode"]) {
        self.dayModeSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"ONdayMode"];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveSettings:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.hostnameText.text forKey:@"ONhostname"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.dayModeSwitch.on] forKey:@"ONdayMode"];
    [UIApplication sharedApplication].idleTimerDisabled = self.dayModeSwitch.on;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
