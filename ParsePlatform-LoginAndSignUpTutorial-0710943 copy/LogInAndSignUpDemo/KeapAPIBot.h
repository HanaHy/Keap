//
//  KeapAPIBot.h
//  Keap
//
//  Created by Michael Zuccarino on 2/13/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *userInfoKey;

typedef NS_ENUM(NSInteger, KeapAPISuccessType) {
    success = 1,
    errorR,
    invalidRequest,
    other
};

@protocol KeapAPIDelegate <NSObject>

-(void)randomMethod;

@end

@interface KeapAPIBot : NSObject

@property (weak, nonatomic) id<KeapAPIDelegate> delegate;

// class methods
+ (KeapAPIBot *)botWithDelegate:(id)delegate;
//+ (void)storeUserInformation:(PFUser *)user;
+ (BOOL)isUserSignedIn;
+ (BOOL)isUserNeedSchool;

// login/ signup stuff
- (void)signupUserWithEmail:(NSString *)email
                   password:(NSString *)password
                   username:(NSString *)username
                   fullname:(NSString *)fullname
                 completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

- (void)loginUserWithEmail:(NSString *)email
                  password:(NSString *)password
                  username:(NSString *)username
                completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

// update user's school
- (void)updateUserSchool:(NSString *)name
              completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

// this was convenience API for me, only use this to create new school entries
- (void)addInSchool:(NSString *)name
          extension:(NSString *)extension
         completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

// fetch all listings for a school
- (void)fetchListings:(NSString *)school
           completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

// fetch all schools
- (void)fetchSchoolsWithCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

// fetch all categories
- (void)fetchCategoriesWithCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

// perform search with a term within the user's current school (defined in database)
- (void)search:(NSString *)term withCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

// create a listing, the number is formatted server side just make sure its under 99,999 lmfao
- (void)createListing:(NSString *)name
             category:(NSString *)category
                price:(NSNumber *)price
          description:(NSString *)prodDescription
                image:(UIImage *)image
       withCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

// get message history (all chats for a particular user)
- (void)getMessageHistoryForUser:(NSString *)user
                  withCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

// retrieve all the bids made by a user
- (void)getAllBidsForUser:(NSString *)user
           withCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;




@end
