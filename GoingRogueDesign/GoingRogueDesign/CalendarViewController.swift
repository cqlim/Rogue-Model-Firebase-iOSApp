//
//  CalendarViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 4/10/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import Firebase

class CalendarViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    
    var project: Project!
    var calendars: [Calendar] = []
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.refreshControl = myRefreshControl

        
        navigationItem.title = project.title
        createArray()
        
        tableview.dataSource = self
        tableview.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    // Pull down to refresh the data
    @objc func refresh(sender: UIRefreshControl){
        self.calendars.removeAll()
        createArray()

        tableview.refreshControl?.endRefreshing()
    }
    
    
    // Create the calendar object array
    func createArray(){
        let db = Firestore.firestore()
        let projectID = project.id
        
        print("ProjectID： \(projectID)")
        
        // Fetch the related calendar data by the current project ID
        db.collection("Calender").whereField("projectID", isEqualTo: projectID)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print("Error getting calendar: \(err)")
                } else {
                    for currentCalendar in querySnapshot!.documents {
                        print("Calendar name： \(currentCalendar.get("calanderName"))")
                        
                        
                        // Create the new calendar object.
                        let calendar = Calendar(name: currentCalendar.get("calanderName") as? String ?? "N/A",link: currentCalendar.get("calanderLink") as? String ?? "N/A", projectID: currentCalendar.get("projectID") as? String ?? "N/A")
                        
                        // Store the new calendar object into the 'calendar array'.
                        self.calendars.append(calendar)
                        print("Calendar Name: \(calendar.name)")
                    }
                        
                    self.tableview.reloadData()
                }
        }
    }
    
    
    // Takes the time stamp and convert to date
    func dateConvertToString(date: Date) -> String{
        let df = DateFormatter()
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        df.dateFormat = "yyyy-MM-dd' at 'hh:mm a"
        return df.string(from: date)
    }


}

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currCalendar = calendars[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell") as! CalendarViewCell
        
        cell.setCalendar(calendar: currCalendar)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currCalendar = calendars[indexPath.row]
        let url = currCalendar.link
        
        UIApplication.shared.open(URL(string:url)! as URL, options: [:], completionHandler: nil)
      
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
