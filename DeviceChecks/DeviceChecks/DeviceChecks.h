//
//  DeviceChecks.h
//  DeviceChecks
//
//  Created by Suresh.Balla on 11/02/16.
//  Copyright © 2016 sureshballa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceChecks : NSObject

- (id)initWithBybassFlag:(BOOL)byPass;

-(BOOL)isJailbroken;

-(NSString *)getSHA1: (NSString *)path;
-(NSString *)getMD5: (NSString *)path;


-(BOOL)isCurrentProcessRunningInDebugMode;


@end
