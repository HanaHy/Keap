//
//  KeapAPIBot.m
//  Keap
//
//  Created by Michael Zuccarino on 2/13/16.
//
//

#import "KeapAPIBot.h"
#import "KeapUser.h"

/*
 url(r'^login/', 'api.views.userLogin'),
 url(r'^signup/', 'api.views.userSignup'),
 url(r'^update/school/', 'api.views.updateSchool'),
 url(r'^enter/school/', 'api.views.enterInSchool'),
 url(r'^list/', 'api.views.fetchListings'),
 url(r'^allschools/', 'api.views.fetchSchools'),
 url(r'^categories/', 'api.views.allCategories'),
 url(r'^search/', 'api.views.searchListings'),
*/

#define SERVERADDRESS       "http://54.67.2.39:80/"
#define LOGIN               "login/"
#define SIGNUP              "signup/"
#define UPDATE_SCHOOL       "update/school/"
#define ENTER_SCHOOL        "enter/school/"
#define LIST_SCHOOL         "allschools/"
#define ALL_LISTINGS        "list/"
#define ALL_CATEGORIES      "categories/"
#define SEARCH              "search/"

NSString *userInfoKey     = @"userInfo";

@implementation KeapAPIBot

+ (KeapAPIBot *)botWithDelegate:(id)delegate {
    
    KeapAPIBot *apiBot = [[KeapAPIBot alloc] init];
    
    __weak id<KeapAPIDelegate> weakDelegate = delegate;
    apiBot.delegate = weakDelegate;
    
    return apiBot;
}
//
//+ (void)storeUserInformation:(PFUser *)user {
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey] != nil) {
//        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]];
//        [userInfo setObject:user.username forKey:@"username"];
//        [userInfo setObject:user.password forKey:@"password"];
//        [userInfo setObject:user.email forKey:@"email"];
//        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:userInfoKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    } else {
//        NSMutableDictionary *userInfo = [NSMutableDictionary new];
//        [userInfo setObject:user.username forKey:@"username"];
//        [userInfo setObject:user.password forKey:@"password"];
//        [userInfo setObject:user.email forKey:@"email"];
//        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:userInfoKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//}

+ (void)storeUserInformationFromJSON:(NSDictionary *)user {
    NSLog(@"%s storing user information from JSON %@",__FUNCTION__, user);
    [KeapUser currentUser];
    [KeapUser setEmail:[user objectForKey:@"email"]];
    [KeapUser setFullname:[user objectForKey:@"firstName"][0]];
    [KeapUser setPassword:[user objectForKey:@"password"]];
    [KeapUser setUsername:[user objectForKey:@"username"]];
}

+ (BOOL)isUserNeedSchool {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey] != nil) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey]];
    } else {
        
    }
    
    return NO;
}

+ (BOOL)isUserSignedIn {
    NSLog(@"%@",[NSUserDefaults standardUserDefaults]);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey] != nil) {
        return YES;
    } else {
        return NO;
    }
}

- (void)signupUserWithEmail:(NSString *)email password:(NSString *)password username:(NSString *)username fullname:(NSString *)fullname completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    [postxhashList setObject:username forKey:@"username"];
    [postxhashList setObject:password forKey:@"password"];
    [postxhashList setObject:email forKey:@"email"];
    [postxhashList setObject:fullname forKey:@"fullname"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",SERVERADDRESS,SIGNUP]]];
        
        //customize request information
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)postxhashList.count] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:result];
        
        NSURLResponse *response = nil;
        
        //fire the request and wait for response
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                NSError *error;
                NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"decoded string is %@",decodedString);
                NSDictionary *momentsData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"node array is %@",momentsData);
                
                if ([[momentsData objectForKey:@"success"] isEqualToString:@"success"]) {
                    NSMutableDictionary *dictWithPassword = [NSMutableDictionary dictionaryWithDictionary:momentsData];
                    [dictWithPassword setObject:password forKey:@"password"];
                    [KeapAPIBot storeUserInformationFromJSON:dictWithPassword];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(success, momentsData);
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(errorR, @{});
                    });
                }
            }
            @catch (NSException *exception) {
                NSLog(@"issue trying to post is %@",exception);
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(errorR, @{});
                });
            }
            @finally {
                NSLog(@"finally n shit");
            }
        }];
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception is %@",exception);
    }
    @finally
    {
        NSLog(@"elevate yo self");
    }
}

- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password username:(NSString *)username completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    [postxhashList setObject:username forKey:@"username"];
    [postxhashList setObject:password forKey:@"password"];
    [postxhashList setObject:email forKey:@"email"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",SERVERADDRESS,LOGIN]]];
        
        //customize request information
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)postxhashList.count] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:result];
        
        NSURLResponse *response = nil;
        
        //fire the request and wait for response
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                NSError *error;
                NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"decoded string is %@",decodedString);
                NSDictionary *momentsData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"node array is %@",momentsData);
                
                completion(success, momentsData);
                
            }
            @catch (NSException *exception) {
                NSLog(@"issue trying to post is %@",exception);
            }
            @finally {
                NSLog(@"finally n shit");
            }
        }];
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception is %@",exception);
    }
    @finally
    {
        NSLog(@"elevate yo self");
    }
}

- (void)updateUserSchool:(NSString *)name completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    KeapUser *user = [KeapUser currentUser];
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    [postxhashList setObject:name forKey:@"extension"];
    [postxhashList setObject:user.email forKey:@"email"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",SERVERADDRESS,UPDATE_SCHOOL]]];
        
        //customize request information
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)postxhashList.count] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:result];
        
        NSURLResponse *response = nil;
        
        //fire the request and wait for response
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                NSError *error;
                NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"decoded string is %@",decodedString);
                NSDictionary *momentsData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"node array is %@",momentsData);
                
                completion(success, momentsData);
            }
            @catch (NSException *exception) {
                NSLog(@"issue trying to post is %@",exception);
            }
            @finally {
                NSLog(@"finally n shit");
            }
        }];
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception is %@",exception);
    }
    @finally
    {
        NSLog(@"elevate yo self");
    }
}

- (void)addInSchool:(NSString *)name extension:(NSString *)extension completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    [postxhashList setObject:name forKey:@"schoolname"];
    [postxhashList setObject:extension forKey:@"extension"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",SERVERADDRESS,ENTER_SCHOOL]]];
        
        //customize request information
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)postxhashList.count] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:result];
        
        NSURLResponse *response = nil;
        
        //fire the request and wait for response
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                NSError *error;
                NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"decoded string is %@",decodedString);
                NSDictionary *momentsData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"node array is %@",momentsData);
                
                completion(success, momentsData);
            }
            @catch (NSException *exception) {
                NSLog(@"issue trying to post is %@",exception);
            }
            @finally {
                NSLog(@"finally n shit");
            }
        }];
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception is %@",exception);
    }
    @finally
    {
        NSLog(@"elevate yo self");
    }
}

- (void)fetchListings:(NSString *)school completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    [postxhashList setObject:school forKey:@"extension"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",SERVERADDRESS,ALL_LISTINGS]]];
        
        //customize request information
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)postxhashList.count] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:result];
        
        NSURLResponse *response = nil;
        
        //fire the request and wait for response
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                NSError *error;
                NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"decoded string is %@",decodedString);
                NSDictionary *momentsData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"node array is %@",momentsData);
                
                completion(success, momentsData);
            }
            @catch (NSException *exception) {
                NSLog(@"issue trying to post is %@",exception);
            }
            @finally {
                NSLog(@"finally n shit");
            }
        }];
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception is %@",exception);
    }
    @finally
    {
        NSLog(@"elevate yo self");
    }
}

- (void)fetchSchoolsWithCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",SERVERADDRESS,LIST_SCHOOL]]];
        
        //customize request information
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)postxhashList.count] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:result];
        
        NSURLResponse *response = nil;
        
        //fire the request and wait for response
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                NSError *error;
                NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"decoded string is %@",decodedString);
                NSDictionary *momentsData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"node array is %@",momentsData);
                
                completion(success, momentsData);
            }
            @catch (NSException *exception) {
                NSLog(@"issue trying to post is %@",exception);
            }
            @finally {
                NSLog(@"finally n shit");
            }
        }];
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception is %@",exception);
    }
    @finally
    {
        NSLog(@"elevate yo self");
    }
}

- (void)fetchCategoriesWithCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",SERVERADDRESS,ALL_CATEGORIES]]];
        
        //customize request information
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)postxhashList.count] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:result];
        
        NSURLResponse *response = nil;
        
        //fire the request and wait for response
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                NSError *error;
                NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"decoded string is %@",decodedString);
                NSDictionary *momentsData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"node array is %@",momentsData);
                
                completion(success, momentsData);
            }
            @catch (NSException *exception) {
                NSLog(@"issue trying to post is %@",exception);
            }
            @finally {
                NSLog(@"finally n shit");
            }
        }];
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception is %@",exception);
    }
    @finally
    {
        NSLog(@"elevate yo self");
    }
}

- (void)search:(NSString *)term withCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    
    [postxhashList setObject:term forKey:@"term"];
    [postxhashList setObject:@"" forKey:@"category"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",SERVERADDRESS,SEARCH]]];
        
        //customize request information
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)postxhashList.count] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:result];
        
        NSURLResponse *response = nil;
        
        //fire the request and wait for response
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                NSError *error;
                NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"decoded string is %@",decodedString);
                NSDictionary *momentsData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"node array is %@",momentsData);
                
                completion(success, momentsData);
            }
            @catch (NSException *exception) {
                NSLog(@"issue trying to post is %@",exception);
            }
            @finally {
                NSLog(@"finally n shit");
            }
        }];
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception is %@",exception);
    }
    @finally
    {
        NSLog(@"elevate yo self");
    }
}

@end
