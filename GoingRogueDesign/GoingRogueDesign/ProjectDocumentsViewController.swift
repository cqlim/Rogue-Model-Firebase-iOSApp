//
//  ProjectDocumentsViewController.swift
//  GoingRogueDesign
//
//  Created by Jeff Deng on 3/28/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import Firebase

class ProjectDocumentsViewController: UIViewController {

    @IBOutlet weak var DocumentTableView: UITableView!
    
    var project: Project!
    var documents: [Document] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = project.title
        createDocumentArray()
        DocumentTableView.delegate = self
        DocumentTableView.dataSource = self
        
    }
    
    //Go through the list of documents based on "projectID"
    func createDocumentArray() {
        let projectID = project.id
        let db = Firestore.firestore().collection("Document")
        
        db.getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print("Error on retrieving documents from Document Collection: \(err)")
            }
            else{
                for document in QuerySnapshot!.documents{
                    if (projectID == document.get("projectID") as? String){
                       
                        let _Document = Document(title: document.get("documentName") as? String ?? "N/A", type: document.get("documentType") as? String ?? "N/A", url: document.get("documentLink") as? String ?? "www.google.com/docs/about")
                        
                        self.documents.append(_Document)
                    }
                }
                self.DocumentTableView.reloadData()
            }
            
        }
        
    }
}

extension ProjectDocumentsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let document = documents[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell") as! DocumentsViewCell
        
        cell.setDocument(document: document)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let document = documents[indexPath.row]
        let url = URL(string: document.url)
        
        UIApplication.shared.open(url! ,options: [:], completionHandler: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
