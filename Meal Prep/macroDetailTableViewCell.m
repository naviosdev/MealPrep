//
//  macroDetailTableViewCell.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 27/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "macroDetailTableViewCell.h"

@implementation macroDetailTableViewCell

@synthesize managedObjectContext,managedObjectModel,persistentStoreCoordinator,mealObject ,carbLabel,carbSlider,proLabel,proSlider,fatLabel,fatSlider, mealSaveData,macroPie;

- (void)awakeFromNib {
    [super awakeFromNib];

    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    //getting and setting the meal object
    NSUserDefaults *object = [NSUserDefaults standardUserDefaults];
    NSString *mealNameString = [object valueForKey:@"mealName"];
    NSLog(@"log string %@",mealNameString);
    
    //fething and setting the meal object
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meals" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mealName = %@", mealNameString];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        //error
    }
    [self setMealObject:fetchedObjects.firstObject];
    
    
    Meals *meal = (Meals *)mealObject;

    
    
    
    //unarchive macro data
    NSData *data = [meal macroStats];

    NSDictionary *dict = [NSDictionary dictionary];
    dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSLog(@"dict data: %@",dict);
    
    int carbInt = [[dict valueForKey:@"carb"]intValue];
    int proInt = [[dict valueForKey:@"pro"]intValue];
    int fatInt = [[dict valueForKey:@"fat"]intValue];

    //set values to ui
    [carbSlider setValue:carbInt];
    [proSlider setValue:proInt];
    [fatSlider setValue:fatInt];
    
    carbLabel.text = [NSString stringWithFormat:@"%d%%",(int)carbSlider.value];
    proLabel.text = [NSString stringWithFormat:@"%d%%",(int)proSlider.value];
    fatLabel.text = [NSString stringWithFormat:@"%d%%",(int)fatSlider.value];

    NSLog(@"macros for meal: %@",[meal macroStats]);

    
    [self setPieChart];
    
}


-(void)setPieChart{
    
    //unarchive macro data
    Meals *meal = (Meals *)mealObject;
    NSData *data = [meal macroStats];
    
    NSDictionary *dict = [NSDictionary dictionary];
    dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    
    //get variables
    NSNumber *carbn = [dict valueForKey:@"carb"];
    NSNumber *pron = [dict valueForKey:@"pro"];
    NSNumber *fatn = [dict valueForKey:@"fat"];
    
    
    //setcolors
    UIColor *carbColour = [UIColor colorWithRed:228.0f/255.0f
                                          green:159.0f/255.0f
                                           blue:61.0f/255.0f
                                          alpha:1.0f];
    UIColor *proColour = [UIColor colorWithRed:142.0f/255.0f
                                         green:195.0f/255.0f
                                          blue:228.0f/255.0f
                                         alpha:1.0f];
    UIColor *fatColour = [UIColor colorWithRed:184.0f/255.0f
                                         green:228.0f/255.0f
                                          blue:139.0f/255.0f
                                         alpha:1.0f];
    
    
    
    //pie
    VBPieChart *chart = [[VBPieChart alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    //[self.view addSubview:chart];
    
    // Setup some options:
    //[chart setEnableStrokeColor:YES];
    [chart setHoleRadiusPrecent:0.0]; /* hole inside of chart */
    //[chart setLabelBloc;
    //[chart setLabelsPosition:1];
    
    
    // Prepare your data
    NSArray *chartValues = @[
                             @{@"name":@"Carb", @"value":carbn, @"color":carbColour},
                             @{@"name":@"Pro", @"value":pron, @"color":proColour},
                             @{@"name":@"Fat", @"value":fatn, @"color":fatColour}
                             ];
    
    // Present pie chart with animation
    if (([carbn  isEqual: @0]) || ([pron  isEqual: @0]) || ([fatn  isEqual: @0])) {
        
    } else {
    [chart setChartValues:chartValues animation:YES duration:0.4 options:VBPieChartAnimationFan];
    
    [self.macroPie addSubview:chart];
    }
    
    
}




#pragma mark - UISlider Methods (Macros)

//cell 3 - macro set
- (IBAction)carbAction:(id)sender {
    
    carbLabel.text = [NSString stringWithFormat:@"%d%%",(int)carbSlider.value];
    //int i = 100 - (proSlider.value + carbSlider.value + fatSlider.value);
    //macroRemainingPercentLabel.text = [NSString stringWithFormat:@"(%d)",i];
    
    if ((proSlider.value + fatSlider.value + carbSlider.value) >101) {
        
        //compare between pro and fat values
        //highest one moves down
        float fatValue = 100 - (carbSlider.value + proSlider.value);
        float proValue = 100 - (carbSlider.value + fatSlider.value);
        
        if (proSlider.value < fatSlider.value) {
            [fatSlider setValue:fatValue];
        } else if (proSlider.value > fatSlider.value) {
            [proSlider setValue:proValue];
        }
        
        carbLabel.text = [NSString stringWithFormat:@"%d%%",(int)carbSlider.value];
        proLabel.text = [NSString stringWithFormat:@"%d%%",(int)proSlider.value];
        fatLabel.text = [NSString stringWithFormat:@"%d%%",(int)fatSlider.value];
    }
    
    //save data
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)carbSlider.value],@"carb", [NSNumber numberWithInt:(int)proSlider.value],@"pro", [NSNumber numberWithInt:(int)fatSlider.value],@"fat", nil];
    
    Meals *meal = (Meals *)mealObject;
    NSData *macroData = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [meal setMacroStats:macroData];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }

    [self setPieChart];
    
}

- (IBAction)proAction:(id)sender {
    
    proLabel.text = [NSString stringWithFormat:@"%d%%",(int)proSlider.value];
    //int i = 100 - (proSlider.value + carbSlider.value + fatSlider.value);
    //macroRemainingPercentLabel.text = [NSString stringWithFormat:@"(%d)",i];
    
    if ((proSlider.value + fatSlider.value + carbSlider.value) >101) {
        
        //compare between pro and fat values
        //highest one moves down
        float carbValue = 100 - (proSlider.value + fatSlider.value);
        float fatValue = 100 - (proSlider.value + carbSlider.value);
        
        if (carbSlider.value < fatSlider.value) {
            [fatSlider setValue:fatValue];
        } else if (carbSlider.value > fatSlider.value) {
            [carbSlider setValue:carbValue];
        }
        
        carbLabel.text = [NSString stringWithFormat:@"%d%%",(int)carbSlider.value];
        proLabel.text = [NSString stringWithFormat:@"%d%%",(int)proSlider.value];
        fatLabel.text = [NSString stringWithFormat:@"%d%%",(int)fatSlider.value];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)carbSlider.value],@"carb", [NSNumber numberWithInt:(int)proSlider.value],@"pro", [NSNumber numberWithInt:(int)fatSlider.value],@"fat", nil];
    
    Meals *meal = (Meals *)mealObject;
    NSData *macroData = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [meal setMacroStats:macroData];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }
    
    [self setPieChart];
}

- (IBAction)fatAction:(id)sender {
    
    fatLabel.text = [NSString stringWithFormat:@"%d%%",(int)fatSlider.value];

    if ((proSlider.value + fatSlider.value + carbSlider.value) > 100) {
        
        //compare between pro and fat values
        //highest one moves down
        float carbValue = 100 - (fatSlider.value + proSlider.value);
        float proValue = 100 - (fatSlider.value + carbSlider.value);
        
        if (proSlider.value < carbSlider.value) {
            [carbSlider setValue:carbValue];
        } else if (proSlider.value > carbSlider.value) {
            [proSlider setValue:proValue];
        }
        
        carbLabel.text = [NSString stringWithFormat:@"%d%%",(int)carbSlider.value];
        proLabel.text = [NSString stringWithFormat:@"%d%%",(int)proSlider.value];
        fatLabel.text = [NSString stringWithFormat:@"%d%%",(int)fatSlider.value];
    }
    
    //save data
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)carbSlider.value],@"carb", [NSNumber numberWithInt:(int)proSlider.value],@"pro", [NSNumber numberWithInt:(int)fatSlider.value],@"fat", nil];
    
    
    Meals *meal = (Meals *)mealObject;
    NSData *macroData = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [meal setMacroStats:macroData];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }
    [self setPieChart];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
