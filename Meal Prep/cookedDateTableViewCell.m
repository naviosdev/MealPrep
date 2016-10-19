//
//  cookedDateTableViewCell.m
//  MealPrep
//
//  Created by Naveed Ahmed on 13/09/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "cookedDateTableViewCell.h"

@implementation cookedDateTableViewCell

@synthesize managedObjectModel,managedObjectContext,persistentStoreCoordinator,mealObject;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    //datePicker = [[UIDatePicker alloc]init];
    
    
    
 
   
    
  
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
