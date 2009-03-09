//
//  UTUBundleController.m
//  UnTinyURL
//
//  Created by uasi on 09/02/17.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "UTUBundleController.h"
#import "WebHTMLView+UnTinyURLAdditions.h"
#import <objc/runtime.h>


@implementation UTUBundleController

+ (void)load
{
    Class aClass = [WebHTMLView class];
    Method orig = class_getInstanceMethod(aClass, @selector(_updateMouseoverWithEvent:));
    Method alt = class_getInstanceMethod(aClass, @selector(utu_updateMouseoverWithEvent:));
    method_exchangeImplementations(orig, alt);

    NSLog(@"UnTinyURL loaded");
}

+ (NSMutableDictionary *)sharedUnshortenedURLCache
{
    static NSMutableDictionary *sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[NSMutableDictionary alloc] init];
    }
    return sharedInstance;
}

@end
