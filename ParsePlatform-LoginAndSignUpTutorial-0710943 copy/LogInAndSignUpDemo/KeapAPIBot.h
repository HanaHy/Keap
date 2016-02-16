//
//  KeapAPIBot.h
//  Keap
//
//  Created by Michael Zuccarino on 2/13/16.
//
//

#import <Foundation/Foundation.h>

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
- (void)signupUserWithEmail:(NSString *)email password:(NSString *)password username:(NSString *)username fullname:(NSString *)fullname completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;
- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password username:(NSString *)username completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

- (void)updateUserSchool:(NSString *)name completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

- (void)addInSchool:(NSString *)name extension:(NSString *)extension completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

- (void)fetchListings:(NSString *)school completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

- (void)fetchSchoolsWithCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

- (void)fetchCategoriesWithCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;

- (void)search:(NSString *)term withCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion;


@end
