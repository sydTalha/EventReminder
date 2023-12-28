//
//  EventModel.swift
//  EventReminderTask
//
//  Created by Rizwan on 9/28/23.
//

import Foundation

struct EventModel: Codable{
    var name: String
    var eDate: Date
    var isNotify: Bool
    var isTimerRunning: Bool
}
