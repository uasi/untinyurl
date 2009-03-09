//
//  NSURLConnection+UnTinyURLAdditions.m
//  UnTinyURL
//
//  Created by uasi on 09/02/17.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import "NSURLConnection+UnTinyURLAdditions.h"


// Stolen from class-dump of Foundation.framework
@interface NSURLConnectionInternal : NSObject {
    void *cfConn;
    void *currCFChallenge;
    id *currNSChallenge;
    NSURL *url;
    id delegate;
    _Bool shouldSkipCancelOnRelease;
    BOOL connectionActive;
}

@end


@interface NSURLConnectionInternal (UnTinyURLPrivateMethods)

- (NSURL *)utu_URL;

@end


@implementation NSURLConnectionInternal (UnTinyURLPrivateMethods)

- (NSURL *)utu_URL
{
    return self->url;
}

@end


@implementation NSURLConnection (UnTinyURLAdditions)

- (NSURL *)utu_URL
{
    return [self->_internal utu_URL];
}

@end
