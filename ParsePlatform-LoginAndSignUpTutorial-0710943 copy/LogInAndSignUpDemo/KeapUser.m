//
//  KeapUser.m
//  Keap
//
//  Created by Michael Zuccarino on 2/15/16.
//
//

#import "KeapUser.h"
#import "KeapAPIBot.h"

@interface KeapUser ()

@end

@implementation KeapUser

+ (KeapUser *)username:(NSString *)username password:(NSString *)password fullname:(NSString *)fullname {
    KeapUser *user = [KeapUser new];
    
    user.username = username;
    user.password = password;
    user.fullname = fullname;
    
    return user;
}

+ (KeapUser *)currentUser {
    static KeapUser *currentKeapUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentKeapUser = [KeapUser getCurrentUser];
    });
    return currentKeapUser;
}

+ (KeapUser *)getCurrentUser {
    
    NSString *username = @"";
    NSString *fullname = @"";
    NSString *email = @"";
    NSString *school = @"";
    BOOL needsProfilePicture = YES;
    BOOL needsSchoolEmail = YES;
    BOOL needsTutorial = YES;
    BOOL needsSignUp = YES;
    BOOL needsVerification = YES;
    
    KeapUser *user = [KeapUser new];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey] != nil) {
        NSDictionary *userSettings = [[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey];
        username = [userSettings objectForKey:@"username"];
        fullname = [userSettings objectForKey:@"firstname"];
        email = [userSettings objectForKey:@"email"];
        school = [userSettings objectForKey:@"school"];
        needsSchoolEmail = [[userSettings objectForKey:@"needsSchoolEmail"] boolValue];
        needsProfilePicture = [[userSettings objectForKey:@"needsProfilePicture"] boolValue];
        needsTutorial = [[userSettings objectForKey:@"needsTutorial"] boolValue];
        needsSignUp = [[userSettings objectForKey:@"needsSignUp"] boolValue];
        needsVerification = [[userSettings objectForKey:@"needsVerification"] boolValue];
    } else {
        NSMutableDictionary *newUser = [NSMutableDictionary new];
        [newUser setObject:@"" forKey:@"username"];
        [newUser setObject:@"" forKey:@"firstname"];
        [newUser setObject:@"" forKey:@"email"];
        [newUser setObject:@"" forKey:@"school"];
        [newUser setObject:[NSNumber numberWithBool:YES] forKey:@"needsSchoolEmail"];
        [newUser setObject:[NSNumber numberWithBool:YES] forKey:@"needsProfilePicture"];
        [newUser setObject:[NSNumber numberWithBool:YES] forKey:@"needsTutorial"];
        [newUser setObject:[NSNumber numberWithBool:YES] forKey:@"needsSignUp"];
        [newUser setObject:[NSNumber numberWithBool:YES] forKey:@"needsVerification"];
        [[NSUserDefaults standardUserDefaults] setObject:newUser forKey:userInfoKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    user.username = username;
    user.password = @"";
    user.fullname = fullname;
    user.email = email;
    user.school = school;
    user.needsProfilePicture = needsProfilePicture;
    user.needsSchoolEmail = needsSchoolEmail;
    user.needsSignUp = needsSignUp;
    user.needsTutorial = needsTutorial;
    user.needsVerification = needsVerification;
    
    return user;
}

+ (void)setUsername:(NSString *)username {
    NSMutableDictionary *userSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]];
    [userSettings setObject:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:userSettings forKey:userInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [KeapUser currentUser].username = username;
}

+ (void)setEmail:(NSString *)email {
    NSMutableDictionary *userSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]];
    [userSettings setObject:email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setObject:userSettings forKey:userInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [KeapUser currentUser].email = email;
}

+ (void)setPassword:(NSString *)password {
    NSMutableDictionary *userSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]];
    [userSettings setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:userSettings forKey:userInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [KeapUser currentUser].password = password;
}

+ (void)setFullname:(NSString *)fullname {
    NSMutableDictionary *userSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]];
    [userSettings setObject:fullname forKey:@"firstname"];
    [[NSUserDefaults standardUserDefaults] setObject:userSettings forKey:userInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [KeapUser currentUser].fullname = fullname;
}

+ (void)setSchool:(NSString *)school {
    NSLog(@"%s updating: %@",__FUNCTION__, school);
    NSMutableDictionary *userSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]];
    [userSettings setObject:school forKey:@"school"];
    [[NSUserDefaults standardUserDefaults] setObject:userSettings forKey:userInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [KeapUser currentUser].school = school;
}

+ (void)setNeedsSchoolEmail:(BOOL)needsSchoolEmail {
    NSMutableDictionary *userSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]];
    [userSettings setObject:[NSNumber numberWithBool:needsSchoolEmail] forKey:@"needsSchoolEmail"];
    [[NSUserDefaults standardUserDefaults] setObject:userSettings forKey:userInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [KeapUser currentUser].needsSchoolEmail = needsSchoolEmail;
}

+ (void)setNeedsProfilePicture:(BOOL)needsProfilePicture {
    NSMutableDictionary *userSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]];
    [userSettings setObject:[NSNumber numberWithBool:needsProfilePicture] forKey:@"needsProfilePicture"];
    [[NSUserDefaults standardUserDefaults] setObject:userSettings forKey:userInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [KeapUser currentUser].needsProfilePicture = needsProfilePicture;
}

+ (void)setNeedsSignUp:(BOOL)needsSignUp {
    NSMutableDictionary *userSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]];
    [userSettings setObject:[NSNumber numberWithBool:needsSignUp] forKey:@"needsSignUp"];
    [[NSUserDefaults standardUserDefaults] setObject:userSettings forKey:userInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [KeapUser currentUser].needsSignUp = needsSignUp;
}

+ (void)setNeedsTutorial:(BOOL)needsTutorial {
    NSMutableDictionary *userSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]];
    [userSettings setObject:[NSNumber numberWithBool:needsTutorial] forKey:@"needsTutorial"];
    [[NSUserDefaults standardUserDefaults] setObject:userSettings forKey:userInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [KeapUser currentUser].needsTutorial = needsTutorial;
}

+ (void)setNeedsVerification:(BOOL)needsVerification {
    NSMutableDictionary *userSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]];
    [userSettings setObject:[NSNumber numberWithBool:needsVerification] forKey:@"needsVerification"];
    [[NSUserDefaults standardUserDefaults] setObject:userSettings forKey:userInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [KeapUser currentUser].needsVerification = needsVerification;
}

+ (BOOL)isLoggedIn {
    [KeapUser currentUser];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]);
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey] objectForKey:@"username"] isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}

//@property (strong, nonatomic) NSString *password;
//@property (strong, nonatomic) NSString *email;
//@property (strong, nonatomic) NSString *fullname;
//@property (nonatomic) BOOL needsSchoolEmail;
//@property (nonatomic) BOOL needsProfilePicture;
//@property (nonatomic) BOOL needsTutorial;
//@property (nonatomic) BOOL needsSignUp;
//@property (nonatomic) BOOL needsVerification;

@end
