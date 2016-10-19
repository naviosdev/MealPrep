//
//  changeDateTableViewCell.m
//  MealPrep
//
//  Created by Naveed Ahmed on 13/09/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "changeDateTableViewCell.h"

@implementation changeDateTableViewCell

@synthesize managedObjectContext,managedObjectModel,persistentStoreCoordinator,mealObject,prepDateLabel,changeDateLabel,datePicker;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    

    NSDate *datep = [[NSDate alloc]init];
    
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.hour = 3;
    
    NSCalendar *theCalendar = [NSCalendar autoupdatingCurrentCalendar];
    datep = [theCalendar dateByAddingComponents:dayComponent toDate:datep options:0];
    
    datePicker.date = datep;

    datePicker.backgroundColor = [UIColor clearColor];
    
}




- (IBAction)datePickerValueChange:(id)sender {
    
    NSUserDefaults *pickerValueDefault = [NSUserDefaults standardUserDefaults];
    [pickerValueDefault setObject:datePicker.date forKey:@"pickerValue"];
    [pickerValueDefault synchronize];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
