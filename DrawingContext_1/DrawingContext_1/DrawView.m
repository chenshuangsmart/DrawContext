//
//  DrawView.m
//  DrawingContext_1
//
//  Created by chenshuang on 2019/12/11.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "DrawView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation DrawView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self draw26Letter];
}

/// 顺时针绘制26个字母
- (void)draw26Letter {
    NSString *alphaBet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat r = 150;
    UIFont *font = [UIFont systemFontOfSize:16];
    NSDictionary *attributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor redColor]};
    
    for (int i = 0; i < alphaBet.length; i++) {
        NSString *letter = [alphaBet substringWithRange:NSMakeRange(i, 1)];
        CGSize letterSize = [letter sizeWithAttributes:@{NSFontAttributeName:font}];
        
        CGFloat theta = M_PI - i * (2 * M_PI / 26.0);
        CGFloat x = center.x + r * sin(theta) - letterSize.width * 0.5;
        CGFloat y = center.y + r * cos(theta) - letterSize.height * 0.5;
        
        [letter drawAtPoint:CGPointMake(x, y) withAttributes:attributes];
    }
}

@end
