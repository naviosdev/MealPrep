//
//  newAddMealTableViewCell.h
//  Trucks
//
//  Created by Naveed Ahmed on 18/05/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newAddMealViewController.h"
#import "newMealListCollectionViewCell.h"
#import "AppDelegate.h"
#import "Meals.h"
#import "Categories.h"
#import "VBPieChart.h"

@interface newAddMealTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
{
    UIImagePickerController *ipc;
    UIPopoverController *popever;
}


//core data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


//cell 1
//@property (strong, nonatomic) IBOutlet UILabel *mealNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *mealNameTextField;


//cell 2
@property (strong, nonatomic) IBOutlet UIDatePicker *prepTImePicker;





//cell 3
@property (strong, nonatomic) IBOutlet UISlider *carbSlider;
@property (strong, nonatomic) IBOutlet UISlider *proSlider;
@property (strong, nonatomic) IBOutlet UISlider *fatSlider;
@property (strong, nonatomic) IBOutlet UILabel *carbLabel;
@property (strong, nonatomic) IBOutlet UILabel *proLabel;
@property (strong, nonatomic) IBOutlet UILabel *fatLabel;
@property (strong, nonatomic) IBOutlet UILabel *macroRemainingPercentLabel;
@property (strong, nonatomic) IBOutlet UIView *macroPie;




//cell 4
@property (strong, nonatomic) IBOutlet UICollectionView *albumColView;
@property (strong, nonatomic) NSMutableArray *albumArray;
@property (strong, nonatomic) NSMutableArray *thumbArray;



@property (nonatomic) int selectedItem;
@property (nonatomic) int selectedDefaultItem;
@property (strong,nonatomic) NSIndexPath *deleteIndexPath;

//cell 5
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;


//cell - catergories

@property (strong, nonatomic) IBOutlet UICollectionView *catColView;
@property (strong, nonatomic) NSMutableArray *catArray;
@property (strong, nonatomic) NSMutableArray *catSelectionArray;

@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;




-(void)updateArray:(NSMutableArray*)array;

-(void)reloaddata;



@property (strong, nonatomic) NSUserDefaults *mealSaveData;




@end
