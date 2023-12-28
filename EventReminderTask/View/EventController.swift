//
//  EventController.swift
//  EventReminderTask
//
//  Created by Rizwan on 9/27/23.
//

import UIKit

class EventController: UIViewController {

    //MARK: - Properties
    let timer = CountdownTimer()
    let viewModel = EventViewModel()
    var isTimerRunning = false
    var event: EventModel?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var dayLbl: UILabel!
    
    @IBOutlet weak var hourLbl: UILabel!
    
    @IBOutlet weak var minLbl: UILabel!
    
    @IBOutlet weak var secLbl: UILabel!
    
    @IBOutlet weak var eventTitleLbl: UILabel!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var isNotifiEnabled: UISwitch!
    @IBOutlet weak var userDateLbl: UILabel!
    
    @IBOutlet weak var untilLbl: UILabel!
    
    
    
    //MARK: - IBActions
    
    @IBAction func addEventTapped(_ sender: UIButton) {
        
        if event == nil{
            addEvent()
        }
        else{
            //ask to cancel current countdown
            self.showAlertWithCompletion(title: "Cancel Countdown", msg: "Do you want to cancel current event count down?") { action in
                self.resetUI()
                self.timer.stop()
                self.event = nil
                self.viewModel.cancelScheduleNotification()
            }
            
        }
        
    }
    
    
    
    //MARK: - Handlers
    @objc func enterBackgroundNotification(notification: Notification) {
        if let event{
            viewModel.saveTimerState(event: event)
        }
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -250
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
    }


}

//MARK: - Lifecycle
extension EventController{
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel.loadTimerState { event in
            
            print(event.isTimerRunning)
            if event.isTimerRunning{
                self.timer.eventDate = event.eDate
                if timer.hasEventPassed{
                    resetUI()
                }
                else{
                    self.event = event
                    self.eventTitleLbl.text = event.name
                    self.untilLbl.isHidden = false
                    self.userDateLbl.isHidden = false
                    self.userDateLbl.text = event.eDate.formatted()
                    self.isTimerRunning = true
                    self.timer.start()
                }
                
            }
            else{
                self.resetUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
    }
    
}

//MARK: - Interface Setup
extension EventController{
    func setupInterface(){
        timer.delegate = self
        self.nameTxtField.delegate = self
        self.addNotificationObservers()
        self.hideKeyboardWhenTappedAround()
        self.datePicker.minimumDate = Date()
    }
    
    func updateCountDown(time: CountDownModel){
        self.dayLbl.text = time.day
        self.hourLbl.text = time.hour
        self.minLbl.text = time.minute
        self.secLbl.text = time.second
    }
    
    func addNotificationObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.enterBackgroundNotification(notification:)), name: Notification.Name("didEnterBackground"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.enterBackgroundNotification(notification:)), name: Notification.Name("willTerminate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
}


//MARK: - Helpers
extension EventController{
    func addEvent(){
        if nameTxtField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false{
            self.showAlert(title: "Empty Event Name", msg: "Please enter a name for the event")
        }
        else{
            if datePicker.date < Date(){
                self.showAlert(title: "Previous Time or Date Selected", msg: "Please select a future date and time")
            }
            else{
                self.isTimerRunning = true
                
                var event = EventModel(name: nameTxtField.text ?? "event", eDate: datePicker.date, isNotify: false, isTimerRunning: isTimerRunning)
                self.untilLbl.isHidden = false
                self.userDateLbl.isHidden = false
                self.userDateLbl.text = event.eDate.formatted()
                if self.isNotifiEnabled.isOn{
                    event.isNotify = true
                    self.viewModel.scheduleNotification(event: event)
                }
                self.eventTitleLbl.text = event.name
                timer.eventDate = event.eDate
                self.event = event
                timer.start()
                self.showAlert(title: "Event Scheduled", msg: "Countdown has started")
            }
        }
    }
    
    func resetUI(){
        self.eventTitleLbl.text = "Event Count Down"
        self.nameTxtField.text?.removeAll()
        self.isNotifiEnabled.setOn(true, animated: true)
        self.untilLbl.isHidden = true
        self.userDateLbl.isHidden = true
        self.updateCountDown(time: CountDownModel(day: "00", hour: "00", minute: "00", second: "00"))
        self.viewModel.removeEventFromStorage()
    }
}

//MARK: - CountDown Delegate
extension EventController: CountDownProtocol{
    func timerCompleted() {
        print("success")
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        self.isTimerRunning = false
        self.resetUI()
        self.event = nil
        self.showAlert(title: "Event Arrived", msg: "Your schedule event has arrived")
        
    }
    
    func countDownDidUpdate(time: CountDownModel) {
        self.updateCountDown(time: time)
    }
}

//MARK: - Textfield Delegate
extension EventController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
