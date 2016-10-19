//
//  newAddMealViewController.h
//  Trucks
//
//  Created by Naveed Ahmed on 18/05/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newAddMealTableViewCell.h"
#import "newMealListViewController.h"
#import "StorageAddMealTableViewCell.h"

@interface newAddMealViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *ipc;
    UIPopoverController *popever;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;


@property (strong, nonatomic) IBOutlet UITableView *addMealTable;


@property (strong, nonatomic) NSMutableArray *albumArray1;
@property (strong, nonatomic) NSMutableArray *albumArray2thumb;
@property (strong, nonatomic) NSMutableArray *copAlbumArray1;


//categories
@property (strong, nonatomic) NSMutableArray *catArray;


-(NSMutableArray *)retrieveArray1;
-(NSMutableArray *)copArrayCount;



//storyboard settings
@property (strong, nonatomic) NSArray *cellHeightArray;




@end
