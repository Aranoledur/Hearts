//
//  ChooseColorViewController.m
//  hearts
//
//  Created by Admin on 20.11.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ChooseColorViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "ViewController.h"

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
@property (nonatomic, strong) UIColor *choosedColor;
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

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration repeat:(float)repeat
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void) runSpinAnimationForButton:(UIView*)view duration:(CGFloat)duration
{
    UIView *parent = [view superview];
    CGPoint rotationPoint = [parent convertPoint:parent.center fromView:parent.superview];
    
    CGFloat minX   = CGRectGetMinX(view.frame);
    CGFloat minY   = CGRectGetMinY(view.frame);
    CGFloat width  = CGRectGetWidth(view.frame);
    CGFloat height = CGRectGetHeight(view.frame);
    
    CGPoint anchorPoint =  CGPointMake((rotationPoint.x-minX)/width,
                                       (rotationPoint.y-minY)/height);
    
    view.layer.anchorPoint = anchorPoint;
    view.layer.position = rotationPoint;
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.toValue = @(M_PI * 2); // The angle we are rotating to
    rotate.duration = duration;
    
    [view.layer addAnimation:rotate forKey:@"myRotationAnimation"];
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
    
    CGAffineTransform transform = CGAffineTransformMakeScale(0.001f, 0.001f);
    
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
        [self runSpinAnimationForButton:self.firstButtonCol duration:1.f];
        [self runSpinAnimationForButton:self.secondButtonCol duration:1.f];
        [self runSpinAnimationForButton:self.thirdButtonCol duration:1.f];
        [CATransaction commit];
    }];
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

- (IBAction)colorButtonTouched:(UIButton *)sender {
    self.choosedColor = sender.backgroundColor;
    [self performSegueWithIdentifier:@"ToLoginSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ToLoginSegue"]) {
        if([segue.destinationViewController isKindOfClass:[ViewController class]]){
            ViewController *loginView = (ViewController *)segue.destinationViewController;
            loginView.choosedColor = self.choosedColor;
        }
    }
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
