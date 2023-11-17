//
//  CoreDataService.h
//
//
//  Created by Reginaldo Lopes on 13/01/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LastUpdates.h"
#import "User.h"
#import "History.h"
#import "Training.h"
#import "Exercises.h"
#import "PersonalTreinees+CoreDataProperties.h"
#import "Design.h"
#import "Blog+CoreDataProperties.h"
#import "FeaturedImages.h"
#import "TrainerInfo.h"
#import "Chat.h"
#import "Radio.h"
#import "Messages.h"
#import "Notes.h"
#import "ClassSchedule.h"
#import "Trainers+CoreDataProperties.h"
#import "InAppProducts.h"
#import "InAppTransactions.h"
#import "transactionClass.h"
#import "QuestionsE.h"
#import "QuestionsP.h"
#import "QuestionsQ.h"
#import "QuestionsD.h"

#import "Global.h"


@interface CoreDataService : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator  *persistentStoreCoordinator;

- (void)initialize;
- (NSManagedObjectContext *)getManagedContext;
- (void)saveData;
- (void)setDefaultDataFromLastUpdatesTable;
- (void)dropLastUpdatesTable;
- (void)dropUserTable;
- (void)dropDesignTable;
- (void)dropRadioTable;
- (void)dropChatTable;
- (void)dropClassScheduleItemTable;
- (void)dropClassScheduleTable;
- (void)dropFeaturedImagesTable;
- (void)dropBlogTable;
- (void)dropTrainerInfoTable;
- (void)dropTrainingTable;
- (void)dropExercisesTable;
- (void) dropTrainingTrainerAccountTable;
- (void) dropExerciseTypesTable;
- (void) dropExerciseIconsTable;
- (void)dropNotesTable;
- (void)deleteDataFromExerciseTableByExerciseID:(NSString *)exID AndTrainingID:(NSString *)trID;
- (NSString *)getTrainingID:(NSString *)training_id;
- (void)deleteDataFromExerciseTableByTrainingID:(NSString *)trID;
- (NSArray *)getDataFromExercisesTableWithExerciseID:(NSString *)exID AndTrainingID:(NSString *)trID;
- (void)dropPersonalTreineesTable;
- (void)dropHistoryTable;
- (void)dropAllTrainersAccountTable;
- (void)dropQuestionsETable;
- (void)dropQuestionsPTable;
- (void)dropQuestionsQTable;
- (void)dropQuestionsDTable;
- (void)deleteHistoryDatabyTrainee:(NSString *)traineeid;
- (void)deleteSpecifiExerciseFromTrainingTable:(NSManagedObject*) obj;
- (NSArray *)getDataFromUserTableByOwner:(NSString *)owner;
- (NSArray *)getDataFromClassScheduleItemTableByWeekDay:(NSInteger)weekday;
- (LastUpdates *)getDataFromLastUpdatesTable;
- (User *)getDataFromUserTable;
- (NSMutableArray *)getDataFromPersonalTreineesTable;
- (NSMutableArray *)getDataFromPersonalTreineesTableBlocked;
- (PersonalTreinees *)getDataFromPersonalTreineesTableByTreineeID:(NSString *)trainerID;
- (NSArray *)getDataFromHistoryTable;
- (NSArray *)getDataFromHistoryTableWithUserID:(NSString *)userID;
- (NSMutableArray *)getDataFromTrainingTable:(BOOL)isHistory  withStatus:(NSString *)OnOff;
- (NSMutableArray *)getDataFromTrainingTableWithUserID:(NSString *)userID withStatus:(NSString *)OnOff;
- (NSMutableArray *) getDataFromExercisesTypes;
- (NSMutableArray *) getDataFromExercisesIcons;
- (Design *)getDataFromDesignTable;
- (Blog *)getDataFromBlogTable;
- (Radio *)getDataFromRadioTable;
- (Chat *)getDataFromChatTable;
- (ClassSchedule *)getDataFromClassScheduleTable;
- (NSArray *)getDataFromMessageTableWithUserID:(NSString *)userID TrainerID:(NSString *)trainerID;
- (NSArray *)getDataFromMessageTableWithMessageID:(NSString *)messageID;
- (TrainerInfo *)getDataFromTrainerInfoTable;
- (NSArray *)getDataFromFeaturedImagesTable;
- (QuestionsE *)getDataFromQuestionsETable:(NSString *)training_id;
- (QuestionsD *)getDataFromQuestionsDTable:(NSString *)training_id;
- (QuestionsP *)getDataFromQuestionsPTable:(NSString *)training_id;
- (QuestionsQ *)getDataFromQuestionsQTable:(NSString *)training_id;
- (void)dropBlogFeedsTable;
- (void)dropInAppProductsTable;
- (void)dropInAppTransactionsTable;
- (NSMutableArray *)getDataFromInAppProductsTable;
- (NSMutableArray *)getDataFromInAppTransactionsTable;
- (NSArray *)getDataFromTransactionsTableWithIsSync:(BOOL)isSync isonlineadvisor:(BOOL)isonlineadvisor;
- (NSString *)getTrainingIdFromProductsTableWithProductId:(NSString *)product_id;
- (int)getTypeFromProductsTableWithProductId:(NSString *)product_id;
- (void)insertUpdateDataInAppTransactionsTable:(transactionClass *)transaction;
- (NSMutableArray *)getDataFromTrainingTableWithTrainingId:(NSString *)trainig_id;
- (void)deleteTrainingWithTrainingID:(NSString *)training_id;
- (NSArray *)getDataFromTrainingTrainerAccount;
- (NSString *)getTrainerNamebyID:(NSString *)trainerID;
- (void)deleteDataFromTrainingTableByTreineeID:(NSString *)treineeID;
- (void)deleteDataFromExercisesTableByTreineeID:(NSString *)treineeID;
- (NSMutableArray *)getDataFromBlogFeedsTable;
-(void)setNoteWithUserID:(NSString *)userID TrainingID:(NSString *)trainingID ExerciseID:(NSString *)exerciseID Note:(NSString *)textNote;
- (Notes *)getDataFromNotesTableByUserID:(NSString *)userID TrainingID:(NSString *)trainingID ExerciseID:(NSString *)exerciseID;
- (NSString *)getNameFromProductsTableWithProductId:(NSString *)product_id;
- (InAppProducts * )getInAppProductDataWithProductId:(NSString *)product_id;
- (NSString *)getDescriptionFromProductsTableWithProductId:(NSString *)product_id;

- (void)deleteDataFromTrainingTable:(BOOL)isHistory;
- (void)deleteDataFromExercisesTable:(BOOL)isHistory;

- (NSArray *)getDataFromHistoryTableWithIsSync:(BOOL)isSync IsClass:(BOOL)isClass;
- (NSArray *)getDataFromHistoryTableWithID:(NSString *)classScheduleID;
- (InAppTransactions * )getInAppTransactionDataWithProductId:(NSString *)product_id;
- (BOOL )checkValiditTransactionDateWithProductId:(NSString *)product_id;
@end

////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
