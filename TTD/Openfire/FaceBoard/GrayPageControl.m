//
//  GrayPageControl.m
//
//  Created by blue on 12-9-28.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood
//

#import "GrayPageControl.h"
@implementation GrayPageControl
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    activeImage = [UIImage imageNamed:@"inactive_page_image"];
    inactiveImage = [UIImage imageNamed:@"active_page_image"];
    [self setCurrentPage:1];
    return self;
}

- (id)initWithFrame:(CGRect)aFrame {
    
	if (self = [super initWithFrame:aFrame]) {
        activeImage = [UIImage imageNamed:@"inactive_page_image"];
        inactiveImage = [UIImage imageNamed:@"active_page_image"];
        [self setCurrentPage:1];
	}
	
	return self;
}

-(void) updateDots
{
//    for (int i = 0; i < [self.subviews count]; i++)
//    {
//        UIImageView* dot = [self.subviews objectAtIndex:i];
//        if (i == self.currentPage)
//        {
//            dot.image = activeImage;
//        }
//        else
//        {
//            dot.image = inactiveImage;
//        }
//    }
    for (int i = 0; i < [self.subviews count]; i++)
        
    {
        
        UIView* dotView = [self.subviews objectAtIndex:i];
        
        UIImageView* dot = nil;
        
        
        
        for (UIView* subview in dotView.subviews)
            
        {
            
            if ([subview isKindOfClass:[UIImageView class]])
                
            {
                
                dot = (UIImageView*)subview;
                
                break;
                
            }
            
        }
        
        
        
        if (dot == nil)
            
        {
            
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, dotView.frame.size.width, dotView.frame.size.height)];
            
            [dotView addSubview:dot];
            
        }
        
        
        
        if (i == self.currentPage)
            
        {
            
            if(activeImage)
                
                dot.image = activeImage;
            
        }
        
        else
            
        {
            
            if (inactiveImage)
                
                dot.image = inactiveImage;
            
        }
        
    }

}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}
-(void)dealloc
{
    
}
@end