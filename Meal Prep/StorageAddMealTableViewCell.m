//
//  StorageAddMealTableViewCell.m
//  MealPrep
//
//  Created by Naveed Ahmed on 03/10/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "StorageAddMealTableViewCell.h"

@implementation StorageAddMealTableViewCell

@synthesize fridgeStepper,freezerStepper, fridgeValue,freezerValue, fridgeDaysLabel, freezerDaysLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [fridgeStepper setValue:5];
    [freezerStepper setValue:12];
    
    
}



- (IBAction)fridgeStepperAction:(id)sender {
    
    fridgeValue = fridgeStepper.value;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:fridgeValue] forKey:@"fridgeValue"];
    [defaults synchronize];
    
    fridgeDaysLabel.text = [NSString stringWithFormat:@"%d days",fridgeValue];
    
}

- (IBAction)freezerStepperAction:(id)sender {
    
    freezerValue = freezerStepper.value;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:freezerValue] forKey:@"freezerValue"];
    [defaults synchronize];
    
    freezerDaysLabel.text = [NSString stringWithFormat:@"%d days",freezerValue];
}









- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
