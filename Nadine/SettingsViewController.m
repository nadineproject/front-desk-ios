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
@property (weak, nonatomic) IBOutlet UIDatePicker *openingTimePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *closingTimePicker;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(300.f, 440.f);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ONhostname"]) {
        self.hostnameText.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"ONhostname"];
    } else {
        self.hostnameText.text = @"apps.officenomads.com";
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ONOpeningTime"]) {
        NSString *openingTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"ONOpeningTime"];
        self.openingTimePicker.date = [formatter dateFromString:openingTime];
    } else {
        self.openingTimePicker.date = [formatter dateFromString:@"8:30 AM"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ONClosingTime"]) {
        NSString *closingTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"ONClosingTime"];
        self.closingTimePicker.date = [formatter dateFromString:closingTime];
    } else {
        self.closingTimePicker.date = [formatter dateFromString:@"6:00 PM"];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveSettings:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    NSString *openingTime = [formatter stringFromDate:self.openingTimePicker.date];
    NSString *closingTime = [formatter stringFromDate:self.closingTimePicker.date];
    [[NSUserDefaults standardUserDefaults] setObject:self.hostnameText.text forKey:@"ONhostname"];
    [[NSUserDefaults standardUserDefaults] setObject:openingTime forKey:@"ONOpeningTime"];
    [[NSUserDefaults standardUserDefaults] setObject:closingTime forKey:@"ONClosingTime"];
    
//    [UIApplication sharedApplication].idleTimerDisabled = self.dayModeSwitch.on;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

@end
