//
//  LessonDetailController.swift
//  FeedUni
//
//  Created by Gabriele Suerz on 01/07/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit
import UserNotifications

class TimelineDetailController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
	
	let pickerChoices = ["5 minuti", "10 minuti", "30 minuti", "1 ora"]
	
	var selectedLesson: Lesson = Lesson()

	@IBOutlet weak var lblLessonName: UILabel!
	@IBOutlet weak var lblLessonType: UILabel!
	@IBOutlet weak var lblRoom: UILabel!
	@IBOutlet weak var lblTeacher: UILabel!
	@IBOutlet weak var lblLessonStart: UILabel!
	@IBOutlet weak var lblDuration: UILabel!
	@IBOutlet weak var pickerView: UIPickerView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.notificationSetupCheck()
		self.setGUI()
    }
	
	// MARK: - PickerView
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.pickerChoices.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int ) -> String? {
		return self.pickerChoices[row]
	}
	
	// MARK: - Actions
	
	@IBAction func setNotificationPressed(_ sender: Any) {
		let selectedRow = self.pickerView.selectedRow(inComponent: 0)
		switch selectedRow {
		case 0:
			self.setNewNotification(secondsBefore: 300)
		case 1:
			self.setNewNotification(secondsBefore: 600)
		case 2:
			self.setNewNotification(secondsBefore: 1800)
		case 3:
			self.setNewNotification(secondsBefore: 3600)
		default:
			self.setNewNotification(secondsBefore: 0)
		}
	}
	
	// MARK: - UI
	
	func setGUI() {
		self.lblLessonName.text = self.selectedLesson.lessonName
		self.lblRoom.text = self.selectedLesson.room
		self.lblTeacher.text = self.selectedLesson.teacher
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "it_IT")
		dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		let date = dateFormatter.date(from: self.selectedLesson.lessonStart!)
		let date2 = dateFormatter.date(from: self.selectedLesson.lessonEnd!)
		dateFormatter.dateFormat = "HH:mm"
		self.lblLessonStart.text = "Ore: \(dateFormatter.string(from: date!))"
		self.lblDuration.text = "Durata: \(self.stringFromTimeInterval(interval: (date2?.timeIntervalSince(date!))!))"
		
		if let type = self.selectedLesson.lessonType {
			self.lblLessonType.text = type
		} else {
			self.lblLessonType.text = "Lezione"
		}
		
		//self.timeBeforeLesson
	}
	
	func stringFromTimeInterval(interval: TimeInterval) -> String {
  		let ti = NSInteger(interval)
		
  		let minutes = (ti / 60) % 60
  		let hours = (ti / 3600)
		
  		return String(format: "%0.2d:%0.2d", hours, minutes)
	}
	
	// MARK: - Notifications stuff
	
	func notificationSetupCheck() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
		{ (success, error) in
			if success {
				
			} else {
				
			}
		}
	}
	
	func setNewNotification(secondsBefore: Int) {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "it_IT")
		dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		let date = dateFormatter.date(from: self.selectedLesson.lessonStart!)
		dateFormatter.dateFormat = "EEEE dd-MM-yyyy HH:mm"
		
		let notification = UNMutableNotificationContent()
		notification.title = self.selectedLesson.lessonName!
		notification.subtitle = dateFormatter.string(from: date!).capitalized
		notification.body = "\(self.selectedLesson.room!) \(self.selectedLesson.teacher!)"
		notification.sound = UNNotificationSound.default()
		
		let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: (date?.timeIntervalSinceNow)!.subtracting(TimeInterval(secondsBefore)), repeats: false)
		let request = UNNotificationRequest(identifier: self.selectedLesson.lessonName! + self.selectedLesson.lessonStart!, content: notification, trigger: notificationTrigger)
		
		UNUserNotificationCenter.current().add(request) { (error) in
			if error == nil {
				let alert  = UIAlertController(title: "Il promemoria è impostato", message: nil, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
					// Realm lesson save
				}))
				self.present(alert, animated: true, completion: nil)
			}
		}
	}

}
