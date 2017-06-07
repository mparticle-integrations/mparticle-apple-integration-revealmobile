//
//  MPKitRevealMobile.m
//
//  Copyright 2016 mParticle, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "MPKitRevealMobile.h"
#import "mParticle.h"
#import "Reveal.h"

// // This is temporary to allow compilation (will be provided by core SDK)
// NSUInteger MPKitInstanceRevealMobile = 112;

@interface MPKitRevealMobile () <RVLBeaconDelegate>
@property (nonatomic, strong, nullable) Reveal *revealSDK;
@end

@implementation MPKitRevealMobile

/*
    mParticle will supply a unique kit code for you. Please contact our team
*/
+ (NSNumber *)kitCode {
    return @112;
}

+ (void)load {
    MPKitRegister *kitRegister = [[MPKitRegister alloc] initWithName:@"RevealMobile" className:@"MPKitRevealMobile" startImmediately:YES];
    [MParticle registerExtension:kitRegister];
}

#pragma mark - MPKitInstanceProtocol methods

#pragma mark Kit instance and lifecycle
- (nonnull instancetype)initWithConfiguration:(nonnull NSDictionary *)configuration startImmediately:(BOOL)startImmediately {
    self = [super init];

    NSString *appKey = configuration[@"apiKey"];
    if (self && appKey) {
        _configuration = configuration;

        if (startImmediately) {
            [self start];
        }
    }

    return self;
}

- (void)start {
    static dispatch_once_t kitPredicate;

    dispatch_once(&kitPredicate, ^{
        NSString *appKey = self.configuration[@"apiKey"];
        // Get a reference to the SDK object
        self.revealSDK = [Reveal sharedInstance];

        // Turn on debug logging, not for production
        if ([MParticle sharedInstance].environment == MPEnvironmentDevelopment) {
            self.revealSDK.debug = YES;
        }
        self.revealSDK.delegate = self;
        [self.revealSDK setupWithAPIKey:appKey andServiceType:RVLServiceTypeProduction];

        // Check to see if configuration contains an override to the endpoint base
        NSString *endpointBase = self.configuration[@"sdk_endpoint"];
        if (endpointBase) {
            [self.revealSDK updateAPIEndpointBase:endpointBase];
        }
        
        _started = YES;

        // Once the config values are set, start the SDK.
        // The SDK will contact the server for further config info
        // and start monitoring for beacons.
        [self.revealSDK start];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = @{mParticleKitInstanceKey:[[self class] kitCode]};

            [[NSNotificationCenter defaultCenter] postNotificationName:mParticleKitDidBecomeActiveNotification
                                                                object:nil
                                                              userInfo:userInfo];
        });
    });
}

- (id const)providerKitInstance {
    return [self started] ? self.revealSDK : nil;
}

@end
