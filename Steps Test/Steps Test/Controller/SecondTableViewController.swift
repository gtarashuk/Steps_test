//
//  SecondTableViewController.swift
//  Steps Test
//
//  Created by Grygorii Tarashchuk on 25.09.2022.
//

import UIKit


class SecondTableViewController: UITableViewController {
    
    var dataArray = [CommentElement]()
    var lastId = 0
    var upperBound = 0
    var limit = 10
    var needMore = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib.init(nibName: "CemmentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentCell")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CemmentTableViewCell
        let comment = self.dataArray[indexPath.row]
        cell.posIdLabel.text = String(comment.postID!)
        cell.idLabel.text    = String(comment.id!)
        cell.nameLabel.text  = comment.name
        cell.emailLabel.text = comment.email
        cell.bodyLabel.text  = comment.body

        if indexPath.row == self.dataArray.count - 1 && self.needMore {
            self.lastId = (comment.id)!
            if self.lastId + 10 < self.upperBound{
                self.loadNextPage()
            }else {
                self.loadLastPart()
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func loadNextPage(){
        APIManager.shared().getComments(start: String(self.lastId), limit: String(self.limit)) { response in
            for comment in response {
                self.dataArray.append(comment)
            }
            DispatchQueue.main.async {
                    self.tableView.reloadData()
            }
        } errorHandler: { error in
            let alertPopup = AlertPopUp(title: "error_popup_title".localized(), message: "error_default".localized())
            alertPopup.display()
        }

    }

    func loadLastPart(){
        APIManager.shared().getCommentsSlice(start: String(self.lastId), end: String(self.upperBound)) { response in
            for comment in response {
                self.dataArray.append(comment)
            }
            self.needMore = false
            DispatchQueue.main.async {
                    self.tableView.reloadData()
            }
        } errorHandler: { error in
            let alertPopup = AlertPopUp(title: "error_popup_title".localized(), message: "error_default".localized())
            alertPopup.display()
        }
    }

}
