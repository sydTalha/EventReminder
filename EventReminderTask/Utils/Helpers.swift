//
//  Helpers.swift
//  EventReminderTask
//
//  Created by Rizwan on 9/27/23.
//

import UIKit


struct Helpers{
    static func parseDateToCountDown(date: Date) -> CountDownModel{
        
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: date)
        let daysString = String(format: "%02d", components.day ?? 0)
        let hoursString = String(format: "%02d", components.hour ?? 0)
        let minutesString = String(format: "%02d", components.minute ?? 0)
        let secondsString = String(format: "%02d", components.second ?? 0)
        let countDown = CountDownModel(day: daysString, hour: hoursString, minute: minutesString, second: secondsString)
        return countDown
    }
    
    static func getNotificationAuthorizationAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Notification Access Required",
                                      message: "Please enable notifications for this app in Settings to receive event reminders.",
                                      preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)

        return alert
    }
    
}
