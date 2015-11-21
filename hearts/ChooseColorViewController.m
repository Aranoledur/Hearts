//
//  ChooseColorViewController.m
//  hearts
//
//  Created by Admin on 20.11.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ChooseColorViewController.h"
@import UIKit;

@interface ChooseColorViewController ()
{
    NSArray *_pickerData;
}
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *firstButtonCol;
-(void) someFunc:(int)h naa:(float) gh;
@property (weak, nonatomic) IBOutlet UIButton *secondButtonCol;
@property (weak, nonatomic) IBOutlet UIButton *thirdButtonCol;
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

-(void) someFunc:(int)h naa:(float) gh
{
    
}

- (IBAction)buttonClicked:(id)sender {
    NSInteger first = [self.picker selectedRowInComponent:0];
    NSInteger second = [self.picker selectedRowInComponent:1];
    NSInteger third = [self.picker selectedRowInComponent:2];
    float part = 255.f / 10;
    NSMutableArray *colors;
    for (int i = 0; i < 3; ++i) {
        int red = getRandomNumberBetween(first * part, (first + 1) * part);
        int green = getRandomNumberBetween(second * part, (second + 1) * part);
        int blue = getRandomNumberBetween(third * part, (third + 1) * part);
        [colors addObject:[UIColor colorWithRed:red green:green blue:blue alpha:1.f]];
    }
    self.firstButtonCol.backgroundColor = [colors objectAtIndex:0];
    self.secondButtonCol.backgroundColor = [colors objectAtIndex:1];
    self.thirdButtonCol.backgroundColor = [colors objectAtIndex:2];
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
