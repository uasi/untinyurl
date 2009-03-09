//
//  WebHTMLView+UnTinyURLAdditions.h
//  UnTinyURL
//
//  Created by uasi on 09/02/16.
//  Copyright 2009 99cm.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface WebHTMLView : NSControl { }

- (void)_setToolTip:(NSString *)string;
- (NSDictionary *)elementAtPoint:(NSPoint)point
              allowShadowContent:(BOOL)yn;
- (NSPoint)convertPoint:(NSPoint)point
               fromView:(NSView *)view;
- (void)_updateMouseoverWithEvent:(NSEvent *)event;
- (void)_updateMouseoverWithFakeEvent;

@end


@interface WebHTMLView (UnTinyURLAdditions)

- (void)utu_updateMouseoverWithEvent:(NSEvent *)event;

@end
