//
//  StorageAddMealTableViewCell.h
//  MealPrep
//
//  Created by Naveed Ahmed on 03/10/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StorageAddMealTableViewCell : UITableViewCell


@property (nonatomic) int fridgeValue;
@property (nonatomic) int freezerValue;

@property (strong, nonatomic) IBOutlet UIStepper *fridgeStepper;
@property (strong, nonatomic) IBOutlet UILabel *fridgeDaysLabel;


@property (strong, nonatomic) IBOutlet UIStepper *freezerStepper;
@property (strong, nonatomic) IBOutlet UILabel *freezerDaysLabel;



@end
