//
//  mealCell.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 24/11/2015.
//  Copyright (c) 2015 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mealCell : UITableViewCell



@property (strong, nonatomic) IBOutlet UILabel *mealNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mealDescLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *macroLabel;

@property (strong, nonatomic) IBOutlet UIImageView *mealImage;

@property (strong, nonatomic) IBOutlet UILabel *catLabel;

@property (strong, nonatomic) IBOutlet UIView *pieView;



@end
