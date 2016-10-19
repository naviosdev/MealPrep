//
//  surplusPlanDateTableViewCell.m
//  MealPrep
//
//  Created by Naveed Ahmed on 15/09/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "surplusPlanDateTableViewCell.h"

@implementation surplusPlanDateTableViewCell

@synthesize planDatePicker;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    planDatePicker.backgroundColor = [UIColor clearColor];
}



- (IBAction)planDatePickerValueChange:(id)sender {
    
    NSUserDefaults *pickerValueDefault = [NSUserDefaults standardUserDefaults];
    [pickerValueDefault setObject:planDatePicker.date forKey:@"planDateValue"];
    [pickerValueDefault synchronize];

    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
