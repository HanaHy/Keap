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
 urlpatterns = patterns('',
 url(r'^login/', 'api.views.userLogin'),
 url(r'^signup/', 'api.views.userSignup'),
 url(r'^update/school/', 'api.views.updateSchool'),
 url(r'^enter/school/', 'api.views.enterInSchool'),
 url(r'^list/', 'api.views.fetchListings'),
 url(r'^allschools/', 'api.views.fetchSchools'),
 url(r'^categories/', 'api.views.allCategories'),
 url(r'^search/', 'api.views.searchListings'),
 url(r'^user-listings/', 'api.views.userListings'),
 url(r'^user-bids/', 'api.views.userBids'),
 url(r'^message-history/', 'api.views.messageHistory'),
 url(r'^add-message/', 'api.views.addMessage'),
 url(r'^new-listing/', 'api.views.enterListing'),
 url(r'^enter-bid/', 'api.views.enterBid'),
 )
*/

#define kSERVERADDRESS       "http://54.67.2.39:80/"
#define kLOGIN               "login/"
#define kSIGNUP              "signup/"
#define kUPDATE_SCHOOL       "update/school/"
#define kENTER_SCHOOL        "enter/school/"
#define kLIST_SCHOOL         "allschools/"
#define kALL_LISTINGS        "list/"
#define kALL_CATEGORIES      "categories/"
#define kSEARCH              "search/"
#define kUSER_LISTINGS       "user-listings/"
#define kUSER_BIDS           "user-bids/"
#define kMESSAGE_HIST        "message-history/"
#define kADD_MESSAGE         "add-message/"
#define kNEW_LISTING         "new-listing/"
#define kENTER_BID           "enter-bid/"

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
    @try {
        
        // !!!!! this shit gets unicoded on python side for login sequence only. it looks like this: @"[u'Django']"
        [KeapUser setFullname:[user objectForKey:@"firstName"][0]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
        [KeapUser setFullname:[user objectForKey:@"firstName"]];
    }
    @finally {
        //
    }
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

- (void)signupUserWithEmail:(NSString *)email
                   password:(NSString *)password
                   username:(NSString *)username
                   fullname:(NSString *)fullname completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    [postxhashList setObject:username forKey:@"username"];
    [postxhashList setObject:password forKey:@"password"];
    [postxhashList setObject:email forKey:@"email"];
    [postxhashList setObject:fullname forKey:@"fullname"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",kSERVERADDRESS,kSIGNUP]]];
        
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
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(errorR, @{});
        });
    }
    @finally
    {
        NSLog(@"elevate yo self");
    }
}

- (void)loginUserWithEmail:(NSString *)email
                  password:(NSString *)password
                  username:(NSString *)username
                completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    [postxhashList setObject:username forKey:@"username"];
    [postxhashList setObject:password forKey:@"password"];
    [postxhashList setObject:email forKey:@"email"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",kSERVERADDRESS,kLOGIN]]];
        
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
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(errorR, @{});
        });
    }
    @finally
    {
        NSLog(@"elevate yo self");
    }
}

- (void)updateUserSchool:(NSString *)name
              completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    KeapUser *user = [KeapUser currentUser];
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    [postxhashList setObject:name forKey:@"extension"];
    [postxhashList setObject:user.email forKey:@"email"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",kSERVERADDRESS,kUPDATE_SCHOOL]]];
        
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

- (void)addInSchool:(NSString *)name
          extension:(NSString *)extension
         completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    [postxhashList setObject:name forKey:@"schoolname"];
    [postxhashList setObject:extension forKey:@"extension"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",kSERVERADDRESS,kENTER_SCHOOL]]];
        
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

- (void)fetchListings:(NSString *)school
           completion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    [postxhashList setObject:school forKey:@"extension"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",kSERVERADDRESS,kALL_LISTINGS]]];
        
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
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",kSERVERADDRESS,kLIST_SCHOOL]]];
        
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
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",kSERVERADDRESS,kALL_CATEGORIES]]];
        
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

- (void)search:(NSString *)term
   forCategory:(NSString *)category
withCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    
    [postxhashList setObject:term forKey:@"term"];
    [postxhashList setObject:category forKey:@"category"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",kSERVERADDRESS,kSEARCH]]];
        
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

/*
 schoolex = bodyJSON['schoolex']
 ownerJSON = bodyJSON['owner']
 categoryJSON = bodyJSON['category']
 name = bodyJSON['name']
 price = bodyJSON['price']
 description = bodyJSON['description']
 images = bodyJSON['images']
 */

- (void)createListing:(NSString *)name
             category:(NSString *)category
                price:(NSNumber *)price
          description:(NSString *)prodDescription
                image:(UIImage *)image
       withCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    
    [postxhashList setObject:name forKey:@"name"];
    [postxhashList setObject:category forKey:@"category"];
    [postxhashList setObject:price forKey:@"price"];
    [postxhashList setObject:prodDescription forKey:@"description"];
    [postxhashList setObject:[[KeapUser currentUser] school] forKey:@"schoolex"];
    [postxhashList setObject:[[KeapUser currentUser] username] forKey:@"owner"];
    
    /*
     
     upload image here 
     
     */
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",kSERVERADDRESS,kNEW_LISTING]]];
        
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

- (void)getMessageHistoryForUser:(NSString *)user withCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    
    [postxhashList setObject:user forKey:@"user"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",kSERVERADDRESS,kMESSAGE_HIST]]];
        
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

- (void)getAllBidsForUser:(NSString *)user
           withCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    
    [postxhashList setObject:[[KeapUser currentUser] username] forKey:@"user"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",kSERVERADDRESS,kUSER_BIDS]]];
        
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

- (void)makeABidForListingID:(NSString *)listingID
                    forPrice:(NSNumber *)offer
              withCompletion:(void (^)(KeapAPISuccessType result, NSDictionary *response))completion {
    
    NSMutableDictionary *postxhashList = [[NSMutableDictionary alloc] init];
    
    [postxhashList setObject:[[KeapUser currentUser] username] forKey:@"bidder"];
    [postxhashList setObject:offer forKey:@"price"];
    [postxhashList setObject:listingID forKey:@"listing"];
    
    NSLog(@"posthash:%@",postxhashList);
    
    @try {
        NSError *error = nil;
        NSData *result =[NSJSONSerialization dataWithJSONObject:postxhashList options:0 error:&error];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s",kSERVERADDRESS,kENTER_BID]]];
        
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
