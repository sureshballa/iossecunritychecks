//
//  IBViewController.m
//  Signature
//
//  Created by Suresh.Balla on 04/02/16.
//  Copyright © 2016 Suresh.Balla. All rights reserved.
//

#import "IBViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "AiChecksum.h"
@import Security;


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
    
#ifdef DEBUG
    resultString = @"DEBUG mode ON";
    
#else
    
    resultString = @"DEBUG mode OFF";
    
#endif
    
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
    
    //NSString *fullPath = @""; // do whatever you need to get the full path to your file
    NSString *md5 = [AiChecksum md5HashOfPath:filePath];
    NSString *sha1 = [AiChecksum shaHashOfPath:filePath];
    
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

    if([self isJailbroken])
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


-(BOOL)isJailbroken
{
#if !(TARGET_IPHONE_SIMULATOR)
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbin/sshd"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ||
        [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]])  {
        return YES;
    }
    
    FILE *f = NULL ;
    if ((f = fopen("/bin/bash", "r")) ||
        (f = fopen("/Applications/Cydia.app", "r")) ||
        (f = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r")) ||
        (f = fopen("/usr/sbin/sshd", "r")) ||
        (f = fopen("/etc/apt", "r")))  {
        fclose(f);
        return YES;
    }
    fclose(f);
    
    NSError *error;
    NSString *stringToBeWritten = @"This is a test.";
    [stringToBeWritten writeToFile:@"/private/jailbreak.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:@"/private/jailbreak.txt" error:nil];
    if(error == nil)
    {
        return YES;
    }
    
#endif
    
    return NO;
}

@end
