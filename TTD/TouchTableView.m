//
//  TouchTableView.m
//  TTD
//
//  Created by andy on 14-5-16.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TouchTableView.h"

@implementation TouchTableView
@synthesize touchDelegate = _touchDelegate;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
         [super touchesBegan:touches withEvent:event];
    
         if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
                        [_touchDelegate respondsToSelector:@selector(tableView:touchesBegin:withEvent:)])
             {
                     [_touchDelegate tableView:self touchesBegin:touches withEvent:event];
                 }
     }

 - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
         [super touchesCancelled:touches withEvent:event];
    
        if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
                        [_touchDelegate respondsToSelector:@selector(tableView:touchesCancelled:withEvent:)])
             {
                     [_touchDelegate tableView:self touchesCancelled:touches withEvent:event];
                 }
     }

 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
         if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
                        [_touchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)])
             {
                     [_touchDelegate tableView:self touchesEnded:touches withEvent:event];
                 }
     }

 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
         [super touchesMoved:touches withEvent:event];
         if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
                        [_touchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)])
             {
                     [_touchDelegate tableView:self touchesMoved:touches withEvent:event];
                 }
     }
@end
