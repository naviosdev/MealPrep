//
//  prepDateTableViewCell.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 05/09/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "prepDateTableViewCell.h"

@implementation prepDateTableViewCell

@synthesize managedObjectModel,managedObjectContext,persistentStoreCoordinator, cookedDateLabel,prepDateLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    

    //setting the date for the datepicker
    NSUserDefaults *datedefault = [NSUserDefaults standardUserDefaults];
    NSDate *date = [[NSDate alloc]init];
    date = [datedefault objectForKey:@"datepicker"];


    NSDate *datep = [[NSDate alloc]init];
    

    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.hour = 3;
    NSCalendar *theCalendar = [NSCalendar autoupdatingCurrentCalendar];
    datep = [theCalendar dateByAddingComponents:dayComponent toDate:datep options:0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
