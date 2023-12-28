//
//  EventViewModel.swift
//  EventReminderTask
//
//  Created by Rizwan on 9/27/23.
//

import UIKit

class EventViewModel{
    func saveTimerState(event: EventModel) {
        do{
            print("saving...")
            let encoder = JSONEncoder()
            let data = try encoder.encode(event)
            UserDefaults.standard.set(data, forKey: "event")
        }
        catch{
            print("error encoding object \(error.localizedDescription)")
        }
    }
    
    func loadTimerState(completion: (EventModel)->()) {
        if let storedEvent = UserDefaults.standard.data(forKey: "event"){
            do{
                let decoder = JSONDecoder()
                let event = try decoder.decode(EventModel.self, from: storedEvent)
                completion(event)
            }
            catch{
                print("error decoding object: \(error.localizedDescription)")
            }
        }
       
    }
    
    func removeEventFromStorage(){
        UserDefaults.standard.removeObject(forKey: "event")
    }
    
    func scheduleNotification(event: EventModel) {
        let content = UNMutableNotificationContent()
        content.title = "Event Reminder"
        content.body = "The day of event '\(event.name)' is here"
        
        let calendar = Calendar.current
        let triggerDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: event.eDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error in notification: \(error.localizedDescription)")
            } else {
                print("success in notification")
            }
        }
    }
    
    
    func cancelScheduleNotification(){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
}
