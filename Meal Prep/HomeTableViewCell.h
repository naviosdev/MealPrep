//
//  HomeTableViewCell.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 23/07/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *mealNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mealImageView;


@property (strong, nonatomic) IBOutlet UILabel *cookedStatus;
@property (strong, nonatomic) IBOutlet UILabel *prepTimeInfo;



@property (strong, nonatomic) IBOutlet UIImageView *cookedImageView;
@property (strong, nonatomic) IBOutlet UIImageView *storageImageView;


@end
