//
//  ViewController.m
//  DrawingContext_1
//
//  Created by chenshuang on 2019/11/19.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "DrawView.h"

#define purpleColor [UIColor colorWithRed:99 / 255.0 green:62 / 255.0 blue:162 / 255.0 alpha:1]
#define greenColor [UIColor colorWithRed:125 / 255.0 green:162 / 255.0 blue:63 / 255.0 alpha:1]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
/** imgView */
@property(nonatomic, strong)UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.imgView.center = self.view.center;
    [self.view addSubview:self.imgView];
    
    /// 在上下文绘图 - 绘制t椭圆
//    [self drawOvalView];
    
    /// 通过UIKit上下文来绘制
//    [self drawContextByUIKit];
    
    /// 画家模型
//    self.imgView.image = [self buildImage];
    
    /// Push 和 Pop 图象状态
//    [self pushAndPopImageStatus];
    
    /// 顺时针绘制26个字母
//    [self draw26Letter];
    
//    DrawView *drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
//    drawView.center = self.view.center;
//    [self.view addSubview:drawView];
    
    // 变换状态-绘制26字母
//    self.imgView.image = [self useContextDraw26Letter];
    
    /// 创建更加精确的图层
//    self.imgView.image = [self drawMoreRigor26Letters];
    
    /// 设置线属性
//    self.imgView.image = [self setLineWidth];
    
    /// 设置线属性
    self.imgView.image = [self setLineDashWidth];
}

- (void)drawQuartz {
    // draw a rounded rectangle in uikit
    CGRect inset = CGRectMake(0, 0, 100, 100);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:inset cornerRadius:12];
    [bezierPath stroke];

    // fill an ellipse in quartz
    CGContextRef context;
    CGContextFillEllipseInRect(context, inset);
}

/// 在UIKit中创建上下文
- (void)createImageContext {
    CGSize size = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(size);
    
    // perform drawing here
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

/// 在UIKit中创建上下文 - 设备比例
- (void)createImageContext2 {
    CGSize targetSize = CGSizeZero;
    BOOL isOpaque = YES;
    CGFloat deviceScale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(targetSize, isOpaque, deviceScale);
    
    // perform drawing here
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

/// 创建PDF上下文
- (void)createPDFImageContext {
    NSString *pathToFile = @"";
    CGRect theBounds = CGRectZero;
    NSDictionary *documentInfo;
    
    UIGraphicsBeginPDFContextToFile(pathToFile, theBounds, documentInfo);
    UIGraphicsBeginPDFPage();
    
    // perform drawing here
    UIGraphicsEndPDFContext();
}

/// 在Quartz中创建上下文
- (void)createQuartzContext {
    // create a color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL) {
        NSLog(@"Error allocating color space");
        return;
    }
    
    // create the bitmap context, Note:in new version of xcode, you need to case the alpha setting
    size_t width;
    size_t height;
    size_t ARGB_COUNT;
    size_t BITS_PER_COMPONENT;
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 BITS_PER_COMPONENT,
                                                 width * ARGB_COUNT,
                                                 colorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        NSLog(@"Error: context not created!");
        CGColorSpaceRelease(colorSpace);
        return;
    }
    
    // push the context
    // this is optional, read on for an explanation of this
    UIGraphicsPushContext(context);
    
    // perform drawing here
    // balance the context push if used
    UIGraphicsPopContext();
    
    // convert to image
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    // clean up
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
}

/// 在上下文中绘图
- (void)createContext {
    CGContextRef context;
    // set the line width
    CGContextSetLineWidth(context, 4);
    
    // set the line color
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    // draw an ellipse
    CGRect rect = CGRectZero;
    CGContextStrokeEllipseInRect(context, rect);
}

/// 在上下文绘图 - 绘制椭圆
- (void)drawOvalView {
    // retrieve the current context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), YES, 0.0);
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // perform the drawing
    CGContextSetLineWidth(context, 4);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokeEllipseInRect(context, CGRectMake(0, 0, 100, 100));
    
    // retrieve the drawn image
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    self.imgView.image = img;
    
    // end the image context
    UIGraphicsEndImageContext();
}

/// 通过UIKit上下文来绘制
- (void)drawContextByUIKit {
    CGSize targetSize = CGSizeMake(100, 100);
    bool isOpaque = YES;
    CGRect rect = CGRectMake(0, 0, 100, 100);
    
    // establish the image context
    UIGraphicsBeginImageContextWithOptions(targetSize, isOpaque, 0.0);
    
    // retrieve the current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // perform the drawing
    CGContextSetLineWidth(context, 4);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokeEllipseInRect(context, rect);
    
    // retrieve the drawn image
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    self.imgView.image = img;
    
    // end the image context
    UIGraphicsEndImageContext();
}

/// UIKit当前的上下文
- (void)drawOvalInUIKit {
    CGRect rect = CGRectMake(0, 0, 100, 100);
    // stroke an elipse using a bezier path
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    path.lineWidth = 4;
    [[UIColor grayColor] setStroke];
    [path stroke];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    
    [self.view.layer addSublayer:layer];
}

/// 画家模型
- (UIImage *)buildImage {
    // create two circular shapes
    CGRect rect = CGRectMake(0, 0, 200, 200);
    
    UIBezierPath *shape1 = [UIBezierPath bezierPathWithOvalInRect:rect];
    rect.origin.x += 100;
    
    UIBezierPath *shape2 = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    UIGraphicsBeginImageContext(CGSizeMake(300, 200));
    
    // first draw purple
    [purpleColor set];
    [shape1 fill];
    
    // the draw green
    [[greenColor colorWithAlphaComponent:0.5] set];
    [shape2 fill];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/// Push 和 Pop 图象状态
- (void)pushAndPopImageStatus {
    CGSize size = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set initial stroke / fill colors
    [greenColor setFill];
    [purpleColor setStroke];
    
    // draw the bunny
    UIBezierPath *bunnyPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 100, 100) cornerRadius:10];    // 某个形状
    [bunnyPath fill];
    [bunnyPath stroke];
    
    // save the satate
    CGContextSaveGState(context);
    
    // change the fill / stroke colors
    [[UIColor orangeColor] setFill];
    [[UIColor blueColor] setStroke];
    
    // move then draw again
    [bunnyPath applyTransform:CGAffineTransformMakeTranslation(50.0, 0)];
    [bunnyPath fill];
    [bunnyPath stroke];
    
    // restore the previous state
    CGContextRestoreGState(context);
    
    // move then draw again
    [bunnyPath applyTransform:CGAffineTransformMakeTranslation(50, 0)];
    [bunnyPath fill];
    [bunnyPath stroke];
    
    // create image
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    self.imgView.image = img;
    UIGraphicsEndImageContext();
}

/// 转换坐标系
// Flip context by supplying the size
void flipContextVertically(CGSize size) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) {
        NSLog(@"error: no context to flip");
        return;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    transform = CGAffineTransformTranslate(transform, 0.0f, -size.height);
    CGContextConcatCTM(context, transform);
}

// flip context by retrieving image
void flipImageContextVertically() {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) {
        NSLog(@"error: no context to flip");
        return;
    }
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    flipContextVertically(img.size);
}

// query context for size and use screen scale
// to map from Quartz pixels to UIKit points
CGSize getUIKitContextSize() {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) {
        return CGSizeZero;
    }
    
    CGSize size = CGSizeMake(CGBitmapContextGetWidth(context), CGBitmapContextGetHeight(context));
    CGFloat scale = [UIScreen mainScreen].scale;
    return CGSizeMake(size.width / scale, size.height / scale);
}

// initialize context
- (void)initializeContext {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // initialize the UIKit context stack
    UIGraphicsPushContext(context);
    
    // flip the context vertically
    CGSize size = CGSizeZero;
    flipContextVertically(size);
    
    // draw the test rectangle, it will now use the uikit origin
    // instead of the Quartz origin
    CGRect testRect = CGRectMake(20, 20, 40, 40);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:testRect];
    [greenColor set];
    [path fill];
    
    // pop the context stack
    UIGraphicsPopContext();
}

/// 裁剪指定路径形状
- (void)clipPath {
     CGContextRef context = UIGraphicsGetCurrentContext();
    
    // save the state
    CGContextSaveGState(context);
    
    // add the path and clip
    UIBezierPath *path;
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    
    // perform clipped drawing here
    
    // restore the state
    CGContextRestoreGState(context);
    
    // drawing done here is not clipped
}

/// 顺时针绘制26个字母
- (void)draw26Letter {
    NSString *alphaBet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    CGPoint center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    CGFloat r = 200;
    UIFont *font = [UIFont systemFontOfSize:16];
    
    for (int i = 0; i < alphaBet.length; i++) {
        NSString *letter = [alphaBet substringWithRange:NSMakeRange(i, 1)];
        CGSize letterSize = [letter sizeWithAttributes:@{NSFontAttributeName:font}];
        
        CGFloat theta = M_PI - i * (2 * M_PI / 26.0);
        CGFloat x = center.x + r * sin(theta) - letterSize.width * 0.5;
        CGFloat y = center.y + r * cos(theta) - letterSize.height * 0.5;
        
        [letter drawAtPoint:CGPointMake(x, y) withAttributes:@{NSFontAttributeName:font}];
    }
}

/// 变换状态 - 顺时针绘制26个字母
- (UIImage *)useContextDraw26Letter {
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    // start drawing
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // retrieve the center and set a radius
    CGPoint center = self.view.center;
    CGFloat r = 100;
    
    // start by adjusting the context origin
    // this affects all subsequent operations
    CGContextTranslateCTM(context, center.x, center.y); // 这句是黑体
    
    UIFont *font = [UIFont systemFontOfSize:16];
    NSDictionary *attributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor redColor]};
    NSInteger length = alphabet.length;
    
    // Iterate through the alphabet
    for (int i = 0; i < length; i++) {
        // retrieve the letter and measure its display size
        NSString *letter = [alphabet substringWithRange:NSMakeRange(i, 1)];
        CGSize letterSize = [letter sizeWithAttributes:attributes];
        
        // calculate the current angular offset
        CGFloat theta = i * (2 * M_PI / (float)length);
        
        // encapsulate each stage of the drawing
        CGContextSaveGState(context);
        
        // rotate the context
        CGContextRotateCTM(context, theta);
        
        // translate up to the edge of the radius and move left by
        // half the letter width, The height translation is negative
        // as this drawing sequence uses the UIKit coordinate system.
        // Transformations that move up go to lower
        CGContextTranslateCTM(context, -letterSize.width * 0.5, -r);
        
        // draw the letter
        [letter drawAtPoint:CGPointMake(0, 0) withAttributes:attributes];
    }
    
    // restrieve and return the image
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/// 创建更加精确的图层
- (UIImage *)drawMoreRigor26Letters {
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    UIFont *font = [UIFont systemFontOfSize:16];
    NSDictionary *attributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor redColor]};
    
    // calculate the full extent
    CGFloat fullSize = 0;
    for (int i = 0; i < alphabet.length; i++) {
        NSString *letter = [alphabet substringWithRange:NSMakeRange(i, 1)];
        CGSize letterSize = [letter sizeWithAttributes:attributes];
        fullSize += letterSize.width;
    }
    
    // Initialize the consumed space
    CGFloat consumedSize = 0.0f;
    CGFloat r = 100;
    
    // start drawing
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Interate through each letter, consuming that width
    for (int i = 0; i < alphabet.length; i++) {
        // measure each letter
        NSString *letter = [alphabet substringWithRange:NSMakeRange(i, 1)];
        CGSize letterSize = [letter sizeWithAttributes:attributes];
        
        // move the pointer forward, calculating the
        // new percentage of travel along the path
        consumedSize += letterSize.width * 0.5;
        CGFloat percent = consumedSize / fullSize;
        CGFloat theta = percent * 2 * M_PI;
        consumedSize += letterSize.width * 0.5;
        
        // prepare to draw the letter by saving the state
        CGContextSaveGState(context);
        
        // rotate the context by the calculated angle
        CGContextRotateCTM(context, theta);
        
        // move to the letter position
        CGContextTranslateCTM(context, -letterSize.width * 0.5, -r);
        
        // draw the letter
        [letter drawAtPoint:CGPointMake(0, 0) withAttributes:attributes];
        
        // reset the context back to the way it was
        CGContextRestoreGState(context);
    }
    
    // restrieve and return the image
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/// 设置线属性
- (UIImage *)setLineWidth {
    UIGraphicsBeginImageContext(self.imgView.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // build a bezier path and set its width
    CGRect rect = CGRectMake(50, 50, 200, 200);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:32];
    path.lineWidth = 4;
    
    // update the context state to use 20-point wide lines
    CGContextSetLineWidth(context, 20);
    
    // draw this path using the context state
    [purpleColor set];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
    
    // draw the path directly through uikit
    [greenColor set];
    [path stroke];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/// 设置线属性
- (UIImage *)setLineDashWidth {
    UIGraphicsBeginImageContext(self.imgView.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // build a bezier path and set its width
    CGRect rect = CGRectMake(50, 50, 200, 200);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:32];
    path.lineWidth = 4;
    
    // update the context state to use 20-point wide lines
    CGContextSetLineWidth(context, 20);
    
    // draw this path using the context state
    [purpleColor set];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
    
    // draw the path directly through uikit
//    [greenColor set];
//    CGFloat dashes[] = {6,2};
//    [path setLineDash:dashes count:2 phase:0];
//    [path stroke];
    
    // 方法二 - 绘制虚线
    [greenColor set];
    CGFloat dashes[] = {6,2};
    CGContextSetLineDash(context, 0, dashes, 2);
    [path stroke];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
