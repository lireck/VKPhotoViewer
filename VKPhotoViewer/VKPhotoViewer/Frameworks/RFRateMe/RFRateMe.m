//
//  RFRateMe.m
//  RFRateMeDemo
//
//  Created by Ricardo Funk on 1/2/14.
//  Copyright (c) 2014 Ricardo Funk. All rights reserved.
//

#import "RFRateMe.h"
#import "UIAlertView+NSCookbook.h"

#define kNumberOfDaysUntilShowAgain 3
#define kAppStoreAddress @"https://itunes.apple.com/us/app/jobsy/id687059035" //???
#define kAppName @"VKPhoto"

@implementation RFRateMe

+(void)showRateAlert {
    
    //If rate was completed, we just return if True
    BOOL rateCompleted = [[NSUserDefaults standardUserDefaults] boolForKey:@"RFRateCompleted"];
    if (rateCompleted) return;
    
    //Check if the user asked not to be prompted again for 3 days (remind me later)
    BOOL remindMeLater = [[NSUserDefaults standardUserDefaults] boolForKey:@"RFRemindMeLater"];
    
    if (remindMeLater) {
        
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *start = [[NSUserDefaults standardUserDefaults] objectForKey:@"RFStartDate"];
        NSString *end = [DateFormatter stringFromDate:[NSDate date]];
        
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [f dateFromString:start];
        NSDate *endDate = [f dateFromString:end];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
        
        if ((long)[components day] <= kNumberOfDaysUntilShowAgain) return;
        
    }
    NSString *localizedRateTextString = NSLocalizedString(@"RateText", @"");
    NSString *localizedNeverAskME = NSLocalizedString(@"NeverAsk", @"");
    NSString *localizedRateNow = NSLocalizedString(@"RateNow", @"");
    NSString *localizedremindLater = NSLocalizedString(@"RemindLater", @"");
    
    //Show rate alert
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(kAppName, @"")
                                                        message:[NSString stringWithFormat:localizedRateTextString,kAppName]
                                                       delegate:nil
                                              cancelButtonTitle:localizedRateNow
                                              otherButtonTitles:localizedNeverAskME,localizedremindLater, nil];
    
    [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        switch (buttonIndex) {
            case 0:
                
                NSLog(@"No, thanks");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RFRateCompleted"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                break;
            case 1:
                
                NSLog(@"Rate it now");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RFRateCompleted"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreAddress]];
                
                break;
            case 2:
                
                NSLog(@"Remind me later");
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *now = [NSDate date];
                [[NSUserDefaults standardUserDefaults] setObject:[dateFormatter stringFromDate:now] forKey:@"RFStartDate"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RFRemindMeLater"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                break;
        }
    }];
}

+(void)showRateAlertAfterTimesOpened:(int)times {
    //Thanks @kylnew for feedback and idea!
    
    BOOL rateCompleted = [[NSUserDefaults standardUserDefaults] boolForKey:@"RFRateCompleted"];
    if (rateCompleted) return;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger timesOpened = [defaults integerForKey:@"timesOpened"];
    [defaults setInteger:timesOpened+1 forKey:@"timesOpened"];
    [defaults synchronize];
    NSLog(@"App has been opened %ld times", (long)[defaults integerForKey:@"timesOpened"]);
    if([defaults integerForKey:@"timesOpened"] >= times){
        [RFRateMe showRateAlert];
    }


}


+(void)showRateAlertAfterDays:(int)times {
    
    BOOL rateCompleted = [[NSUserDefaults standardUserDefaults] boolForKey:@"RFRateCompleted"];
    if (rateCompleted) return;
    
    BOOL showAfterXdays = [[NSUserDefaults standardUserDefaults] boolForKey:@"RFShowAfterXDays"];
    
    if (!showAfterXdays) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *now = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:[dateFormatter stringFromDate:now] forKey:@"RFGeneralStartDate"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RFShowAfterXDays"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *start = [[NSUserDefaults standardUserDefaults] objectForKey:@"RFGeneralStartDate"];
    NSString *end = [DateFormatter stringFromDate:[NSDate date]];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:start];
    NSDate *endDate = [f dateFromString:end];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    if ((long)[components day] <= times) return;
    
    
}

@end
