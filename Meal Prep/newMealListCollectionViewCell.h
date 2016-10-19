//
//  newMealListCollectionViewCell.h
//  Trucks
//
//  Created by Naveed Ahmed on 12/05/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newMealListCollectionViewCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIView *catBg;



@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *defaultButton;


@end
