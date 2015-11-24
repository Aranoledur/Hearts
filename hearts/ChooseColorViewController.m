//
//  ChooseColorViewController.m
//  hearts
//
//  Created by Admin on 20.11.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ChooseColorViewController.h"
#import "QuartzCore/QuartzCore.h"

@import UIKit;

@interface ChooseColorViewController ()
{
    NSArray *_pickerData;
}
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *firstButtonCol;
@property (weak, nonatomic) IBOutlet UIButton *secondButtonCol;
@property (weak, nonatomic) IBOutlet UIButton *thirdButtonCol;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainer;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@end

@implementation ChooseColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pickerData = @[ @[@"0", @"0", @"0"],
                     @[@"1", @"1", @"1"],
                     @[@"2", @"2", @"2"],
                     @[@"3", @"3", @"3"],
                     @[@"4", @"4", @"4"],
                     @[@"5", @"5", @"5"],
                     @[@"6", @"6", @"6"],
                     @[@"7", @"7", @"7"],
                     @[@"8", @"8", @"8"],
                     @[@"9", @"9", @"9"] ];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    self.firstButtonCol.layer.cornerRadius = self.firstButtonCol.bounds.size.width/2.0;
    self.secondButtonCol.layer.cornerRadius = self.firstButtonCol.bounds.size.width/2.0;
    self.thirdButtonCol.layer.cornerRadius = self.firstButtonCol.bounds.size.width/2.0;
    CGAffineTransform transform = CGAffineTransformMakeScale(0.f, 0.f);
    self.buttonContainer.hidden = YES;
    self.buttonContainer.transform = transform;
    [self.picker selectRow:5 inComponent:0 animated:NO];
    [self.picker selectRow:5 inComponent:1 animated:NO];
    [self.picker selectRow:5 inComponent:2 animated:NO];
    self.buttonBack.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row][component];
}

int getRandomNumberBetween(int from,int to){
    return arc4random_uniform(to - from) + from;
}

double DEGREES_TO_RADIANS(float angle){
    return ((angle) / 180.0 * M_PI);
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (IBAction)buttonClicked:(id)sender {
    NSInteger first = [self.picker selectedRowInComponent:0];
    NSInteger second = [self.picker selectedRowInComponent:1];
    NSInteger third = [self.picker selectedRowInComponent:2];
    float part = 256.f / 10;
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; ++i) {
        float red = getRandomNumberBetween(first * part, (first + 1) * part);
        float green = getRandomNumberBetween(second * part, (second + 1) * part);
        float blue = getRandomNumberBetween(third * part, (third + 1) * part);
        [colors addObject:[UIColor colorWithRed:red/256 green:green/256 blue:blue/256 alpha:1.f]];
    }
    self.firstButtonCol.backgroundColor = [colors objectAtIndex:0];
    self.secondButtonCol.backgroundColor = [colors objectAtIndex:1];
    self.thirdButtonCol.backgroundColor = [colors objectAtIndex:2];
    
    
    [UIView animateWithDuration:2.0f animations:^{
        [_containerView setAlpha:0.0f];
    }];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [UIView animateWithDuration:1.0f animations:^{
        
        self.containerView.transform = transform;
    } completion:^(BOOL finished){
        
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.buttonContainer.hidden = NO;
        [UIView animateWithDuration:1.f animations:^{
            self.buttonContainer.transform = transform;
        }];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            self.buttonBack.hidden = NO;
        }];
        [self runSpinAnimationOnView: self.buttonContainer duration:4.f repeat:1];
        [CATransaction commit];
    }];
    
//    UIView* imView = self.picker;
//    
//    CGPoint point0 = imView.layer.position;
//    CGPoint point1 = { point0.x, point0.y - 50 };
//    
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
//    anim.fromValue    = [NSValue valueWithCGPoint:point0];
//    anim.toValue  = [NSValue valueWithCGPoint:point1];
//    anim.duration   = 1.5f;
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    
//    // First we update the model layer's property.
//    imView.layer.position = point1;
//    
//    // Now we attach the animation.
//    [imView.layer  addAnimation:anim forKey:@"position"];
    
    {
//        UIView *imageViewForAnimation = self.picker;
//        imageViewForAnimation.alpha = 1.0f;
//        CGRect imageFrame = imageViewForAnimation.frame;
//        //Your image frame.origin from where the animation need to get start
//        CGPoint viewOrigin = imageViewForAnimation.frame.origin;
//        viewOrigin.y = viewOrigin.y + imageFrame.size.height / 2.0f;
//        viewOrigin.x = viewOrigin.x + imageFrame.size.width / 2.0f;
        
//        imageViewForAnimation.frame = imageFrame;
//        imageViewForAnimation.layer.position = viewOrigin;
//        [self.view addSubview:imageViewForAnimation];
        
        // Set up fade out effect
//        CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//        [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.3]];
//        fadeOutAnimation.fillMode = kCAFillModeForwards;
//        fadeOutAnimation.removedOnCompletion = NO;
//        
//        // Set up scaling
//        CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
//        [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(40.0f, imageFrame.size.height * (40.0f / imageFrame.size.width))]];
//        resizeAnimation.fillMode = kCAFillModeForwards;
//        resizeAnimation.removedOnCompletion = NO;
//        
//        // Set up path movement
//        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//        pathAnimation.calculationMode = kCAAnimationPaced;
//        pathAnimation.fillMode = kCAFillModeForwards;
//        pathAnimation.removedOnCompletion = NO;
//        //Setting Endpoint of the animation
//        CGPoint endPoint = CGPointMake(viewOrigin.x - 30.0f, viewOrigin.x + 40.0f);
//        //to end animation in last tab use
//        //CGPoint endPoint = CGPointMake( 320-40.0f, 480.0f);
//        CGMutablePathRef curvedPath = CGPathCreateMutable();
//        CGPathMoveToPoint(curvedPath, NULL, viewOrigin.x, viewOrigin.y);
//        CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, viewOrigin.y, endPoint.x, viewOrigin.y, endPoint.x, endPoint.y);
//        pathAnimation.path = curvedPath;
//        CGPathRelease(curvedPath);
//        
//        CAAnimationGroup *group = [CAAnimationGroup animation];
//        group.fillMode = kCAFillModeForwards;
//        group.removedOnCompletion = NO;
//        [group setAnimations:[NSArray arrayWithObjects:fadeOutAnimation, pathAnimation, resizeAnimation, nil]];
//        group.duration = 0.7f;
//        group.delegate = self;
//        [group setValue:imageViewForAnimation forKey:@"imageViewBeingAnimated"];
//        
//        [imageViewForAnimation.layer addAnimation:group forKey:@"savingAnimation"];
    }
}
- (IBAction)buttonBackClicked:(id)sender {
    self.buttonBack.hidden = YES;
    CGAffineTransform transform = CGAffineTransformMakeScale(0.f, 0.f);
    self.buttonContainer.hidden = YES;
    self.buttonContainer.transform = transform;
    CGAffineTransform transform1 = CGAffineTransformMakeScale(1.0f, 1.f);
    self.containerView.transform = transform1;
    [_containerView setAlpha:1.0f];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
