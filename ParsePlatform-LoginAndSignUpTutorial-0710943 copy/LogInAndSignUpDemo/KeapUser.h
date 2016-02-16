//
//  KeapUser.h
//  Keap
//
//  Created by Michael Zuccarino on 2/15/16.
//
//

#import <Foundation/Foundation.h>

@interface KeapUser : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *fullname;
@property (strong, nonatomic) NSString *school;
@property (nonatomic) BOOL needsSchoolEmail;
@property (nonatomic) BOOL needsProfilePicture;
@property (nonatomic) BOOL needsTutorial;
@property (nonatomic) BOOL needsSignUp;
@property (nonatomic) BOOL needsVerification;

// Use this to create user objects for the non-current user (i.e. other people in a chat)
+ (KeapUser *)username:(NSString *)username password:(NSString *)password fullname:(NSString *)fullname;

// Use this to access the current user singleton
+ (KeapUser *)currentUser;

// use these setter methods to update across-app settings
+ (void)setUsername:(NSString *)username;
+ (void)setEmail:(NSString *)email;
+ (void)setPassword:(NSString *)password;
+ (void)setFullname:(NSString *)fullname;
+ (void)setSchool:(NSString *)school;
+ (void)setNeedsSchoolEmail:(BOOL)needsSchoolEmail;
+ (void)setNeedsProfilePicture:(BOOL)needsProfilePicture;
+ (void)setNeedsSignUp:(BOOL)needsSignUp;
+ (void)setNeedsTutorial:(BOOL)needsTutorial ;
+ (void)setNeedsVerification:(BOOL)needsVerification;

// convenience stuff
+ (BOOL)isLoggedIn;

@end
