//
//  DeviceChecks.m
//  DeviceChecks
//
//  Created by Suresh.Balla on 11/02/16.
//  Copyright © 2016 sureshballa. All rights reserved.
//

#import "DeviceChecks.h"
#import "ChecksumUtilities.h"
@import Security;

@implementation DeviceChecks

BOOL _byPass;

- (id)initWithBybassFlag:(BOOL)byPass
{
    self = [super init];
    if (self) {
        _byPass = byPass;
    }
    return self;
}

-(BOOL)isJailbroken;
{
    
    if(_byPass){
        return NO;
    }
    
#if !(TARGET_IPHONE_SIMULATOR)
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbin/sshd"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"])  {
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

-(NSString *)getSHA1: (NSString *)path
{
    NSString *sha1 = [AiChecksum shaHashOfPath:path];
    
    NSLog( @"SHA1: %@", sha1 );
    
    return sha1;
}
-(NSString *)getMD5: (NSString *)path
{
    NSString *md5 = [AiChecksum md5HashOfPath:path];
    
    NSLog( @"MD5: %@", md5 );
    
    return md5;
}


-(BOOL)isCurrentProcessRunningInDebugMode
{
    if(_byPass){
        return false;
    }
    
#ifdef DEBUG
    return YES;
#else
    return NO;
    
#endif
}


@end
