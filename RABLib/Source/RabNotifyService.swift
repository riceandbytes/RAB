//
//  RABNotifyService.swift
//  RABLib
//
//  Created by skylinefighterx on 9/20/18.
//  Copyright © 2018 Rab LLC. All rights reserved.
//

import Foundation
import UserNotifications

@available(iOS 10.0,*)
public class RabNotifyService {
    
    /// Schedule Local Notify EveryDay
    /// - must have uuid
    ///
    public class func scheduleLocalNotifyEveryDay(title: String,
                                                   body: String,
                                                   hour: Int,
                                                   minute: Int,
                                                   key: String)
    {
        pln("SCHEDULED NOTIFY FOR: \(title), body: \(body)")
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        var date = DateComponents()
        date.hour = hour
        date.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        //Create the request
        let request = UNNotificationRequest(
            identifier: key,
            content: content,
            trigger: trigger
        )
        
        //Schedule the request
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    /// Schedule Local Notify
    /// - must have uuid
    ///
    public class func scheduleLocalNotify(title: String,
                                     body: String,
                                     fireDate: Date,
                                     id: String)
    {
        /// Only schedule is fireDate is not in past
        guard fireDate > Date() else {
            return
        }
        pln("SCHEDULED NOTIFY FOR: \(title), body: \(body)")
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let d = NSCalendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: d, repeats: false)
        
        //Create the request
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        //Schedule the request
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)
    }
    
    /// Remove schduled notify
    ///
    /// - Parameter key: probably uuid
    ///
    public class func removeLocalNotifyWith(key: String) {
        pln("FOUND and REMOVE LOCAL NOTIFY")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [key])
    }
    
    /// Remove all notifcations
    public class func removeAllLocalNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// Register for remote notifcations, supports ios9 and up
    public class func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) {
                (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    /// Find pending notification
    public class func findPending(byKey: String, callback: @escaping ((UNNotificationRequest?) -> Void)) {
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            (requests) in
            for r in requests {
                if r.identifier == byKey {
                    callback(r)
                    return
                }
            }
            callback(nil)
        }
    }
    
    public class func findTriggerDate(byKey: String, callback: @escaping ((Date?) -> Void)) {
        RabNotifyService.findPending(byKey: byKey) {
            (req) in
            guard let r = req else {
                callback(nil)
                return
            }
            guard let trigger = r.trigger as? UNCalendarNotificationTrigger else {
                callback(nil)
                return
            }
            callback(trigger.nextTriggerDate())
        }
    }
}
