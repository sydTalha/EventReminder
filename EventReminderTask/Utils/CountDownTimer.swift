//
//  CountDownTimer.swift
//  EventReminderTask
//
//  Created by Rizwan on 9/27/23.
//

import Foundation

protocol CountDownProtocol {
    func countDownDidUpdate(time: CountDownModel)
    func timerCompleted()
}

class CountdownTimer{
    private var timer: Timer?
    var eventDate: Date
    var delegate: CountDownProtocol?
    var hasEventPassed: Bool {
        let now = Date()
        return now >= eventDate
    }
    
    init(eventDate: Date = Date()) {
        self.eventDate = eventDate
    }
    
    func start(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            
            self.updateCountDown()
        })
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateCountDown(){
        
        if hasEventPassed {
            stop() // Stop the timer
            let countDown = CountDownModel(day: "00", hour: "00", minute: "00", second: "00")
            self.delegate?.countDownDidUpdate(time: countDown)
            self.delegate?.timerCompleted()
            return
        }
        
        
        self.delegate?.countDownDidUpdate(time: Helpers.parseDateToCountDown(date: eventDate))
    }
    
    
}
