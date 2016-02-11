//
//  IBViewController.m
//  Signature
//
//  Created by Suresh.Balla on 04/02/16.
//  Copyright © 2016 Suresh.Balla. All rights reserved.
//

#import "IBViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <DeviceChecks/DeviceChecks.h>

@interface IBViewController ()

@end

@implementation IBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self detectBluetooth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)detectBluetooth
{
    if(!self.bluetoothManager)
    {
        // Put on main queue so we can call UIAlertView from delegate callbacks.
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    [self centralManagerDidUpdateState:self.bluetoothManager]; // Show initial state
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *stateString = nil;
    switch(self.bluetoothManager.state)
    {
        case CBCentralManagerStateResetting: stateString = @"The connection with the system service was momentarily lost, update imminent."; break;
        case CBCentralManagerStateUnsupported: stateString = @"The platform doesn't support Bluetooth Low Energy."; break;
        case CBCentralManagerStateUnauthorized: stateString = @"The app is not authorized to use Bluetooth Low Energy."; break;
        case CBCentralManagerStatePoweredOff: stateString = @"Bluetooth is currently powered off."; break;
        case CBCentralManagerStatePoweredOn: stateString = @"Bluetooth is currently powered on and available to use."; break;
        default: stateString = @"State unknown, update imminent."; break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetooth state"
                                                     message:stateString
                                                    delegate:nil
                                           cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

-(void)checkBattery {
    
    
    
    NSString *stateString = nil;

    
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    
    if ([myDevice batteryState] == UIDeviceBatteryStateUnplugged){
        stateString = @"Not connected to USB";
    } else {
        stateString = @"Connected to USB";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"USB state"
                                                    message:stateString
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay" otherButtonTitles:nil];

    [alert show];
    
}

- (IBAction)checkUSBTouchUpInside:(id)sender {
    [self checkBattery];
}
- (IBAction)checkDebugTouchUpInside:(id)sender {
    
    NSString *resultString = nil;
    
    DeviceChecks* deviceCheckUtilities = [[DeviceChecks alloc] initWithBybassFlag:YES];
    
    
    if([deviceCheckUtilities isCurrentProcessRunningInDebugMode])
    {
        resultString = @"DEBUG mode ON";
    }
    else
    {
        resultString = @"DEBUG mode OFF";

    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DEBUG state"
                                                    message:resultString
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert show];

    
}

- (IBAction)checkSHA1TouchUpInside:(id)sender {
    
    //[[NSBundle mainBundle] pathForResource:@"embedded.mobileprovision" ofType:nil];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Signature"
                                                         ofType:nil];
    
    DeviceChecks* deviceCheckUtilities = [[DeviceChecks alloc] initWithBybassFlag:NO];

    
    NSString *md5 = [deviceCheckUtilities getMD5:filePath];
    NSString *sha1 = [deviceCheckUtilities getSHA1:filePath];
    
    NSLog( @"MD5: %@", md5 );
    NSLog( @"SHA1: %@", sha1 );
    
    NSString *resultString = nil;
    
    resultString = [NSString stringWithFormat:@"%@%@%@%@", @"MD5 for app is ", md5, @" and SHA1 is ", sha1];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signature"
                                                    message:resultString
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert show];

    
    
    
//
//    //UIImage* image = [UIImage imageNamed:@"name-in-asset-catalog"];
//    
//    filePath = [[NSBundle mainBundle] pathForResource:@"richtextfile"
//                                               ofType: @"rtf"];
//    
//    //NSString *fullPath = @""; // do whatever you need to get the full path to your file
//    md5 = [AiChecksum md5HashOfPath:filePath];
//    sha1 = [AiChecksum shaHashOfPath:filePath];
//    
//    NSLog( @"MD5: %@", md5 );
//    NSLog( @"SHA1: %@", sha1 );


}

- (IBAction)checkJailBrokenTouchUpInside:(id)sender {
    NSString *resultString = nil;
    
    DeviceChecks* deviceCheckUtilities = [[DeviceChecks alloc] initWithBybassFlag:NO];

    if([deviceCheckUtilities isJailbroken])
    {
        resultString = @"Your device is Jailbroken";

    }
    else
    {
        resultString = @"Your device is not Jailbroken";

    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"JAILBROKEN state"
                                                    message:resultString
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert show];

    
}

@end
