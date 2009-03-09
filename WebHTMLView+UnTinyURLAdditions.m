//
//  WebHTMLView+UnTinyURLAdditions.m
//  UnTinyURL
//
//  Created by uasi on 09/02/16.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "WebHTMLView+UnTinyURLAdditions.h"
#import "NSURLConnection+UnTinyURLAdditions.h"
#import "UTUBundleController.h"


@interface WebHTMLView (UnTinyURLPrivateMethods)

- (NSURL *)utu_unshortenedURLForURL:(NSURL *)URL;
- (void)utu_loadUnshortenedURLForURL:(NSURL *)URL;
- (NSURL *)utu_linkURLAtMouseLocation;

@end


@implementation WebHTMLView (UnTinyURLAdditions)

// To be swizzled with - (void)_updateMouseOverEvent:
- (void)utu_updateMouseoverWithEvent:(NSEvent *)event
{
    [self utu_updateMouseoverWithEvent:event];
    NSURL *linkURL = [self utu_linkURLAtMouseLocation];
    if (linkURL == nil) { return; }
    NSURL *unshortenedURL = [self utu_unshortenedURLForURL:linkURL];
    if (unshortenedURL != nil) {
        [self _setToolTip:[unshortenedURL absoluteString]];
    }
}

@end


@implementation WebHTMLView (UnTinyURLPrivateMethods)

// @returns unshortened version of URL if available, otherwise nil.
- (NSURL *)utu_unshortenedURLForURL:(NSURL *)URL
{
    NSMutableDictionary *cache = [UTUBundleController sharedUnshortenedURLCache];
    NSURL *cachedURL = [cache objectForKey:[URL absoluteString]];
    if ([cachedURL isKindOfClass:[NSURL class]]) {
        return cachedURL;
    }
    else if ([cachedURL isEqual:[NSNull null]]) {
        return nil; // Loading
    }

    if ([[URL host] isEqualToString:@"tinyurl.com"] ||
        [[URL host] isEqualToString:@"bit.ly"] ||
        [[URL host] isEqualToString:@"is.gd"] ||
        [[URL host] isEqualToString:@"rubyurl.com"]) {
        [self utu_loadUnshortenedURLForURL:URL];
    }
    
    return nil;
}

- (void)utu_loadUnshortenedURLForURL:(NSURL *)URL
{
    NSMutableDictionary *cache = [UTUBundleController sharedUnshortenedURLCache];
    [cache setObject:[NSNull null] forKey:[URL absoluteString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"HEAD"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (NSURL *)utu_linkURLAtMouseLocation
{
    NSPoint mouseLocation = [[self window] mouseLocationOutsideOfEventStream];
    mouseLocation = [self convertPoint:mouseLocation fromView:nil];
    NSDictionary *element = [self elementAtPoint:mouseLocation allowShadowContent:YES];
    return [element objectForKey:WebElementLinkURLKey];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSMutableDictionary *cache = [UTUBundleController sharedUnshortenedURLCache];
    NSURL *unshortenedURL = [(NSHTTPURLResponse *)response URL];
    [cache setObject:unshortenedURL forKey:[[connection utu_URL] absoluteString]];
    [self _updateMouseoverWithFakeEvent];
}

- (void)connection:(NSURLConnection *)connection didFailedWithError:(NSError *)error
{
    NSMutableDictionary *cache = [UTUBundleController sharedUnshortenedURLCache];
    NSURL *URL = [connection utu_URL];
    if ([[cache objectForKey:[URL absoluteString]] isEqual:[NSNull null]]) {
        [cache removeObjectForKey:URL];
    }
}

@end


