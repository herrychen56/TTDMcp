//
//  TouchTableView.h
//  TTD
//
//  Created by andy on 14-5-16.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TouchTableView : NSObject

@end
@protocol TouchTableViewDelegate <NSObject>

@optional
 - (void)tableView:(UITableView *)tableView touchesBegin:(NSSet *)touches withEvent:(UIEvent *)event;
 - (void)tableView:(UITableView *)tableView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
 - (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
 - (void)tableView:(UITableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@end