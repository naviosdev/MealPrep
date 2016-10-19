//
//  categoryDetailTableViewCell.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 27/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "Categories.h"
#import "catCellCollectionViewCell.h"

@interface categoryDetailTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>


@property (readonly, weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, weak, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, weak, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (weak, nonatomic) NSManagedObject *mealObject;
@property (assign, nonatomic) NSString *theString;




@property (weak, nonatomic) IBOutlet UICollectionView *catColView;
@property (strong, nonatomic) NSMutableArray *catArray;
@property (strong, nonatomic) NSMutableArray *catSelectionArray;



@end
