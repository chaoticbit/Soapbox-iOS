//
//  ReadingListViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/18/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

struct readingListData {
    let threadno: String!
    let threadTitle: String!
    let avatarImage: UIImage!
    let timeElapsed: String!
    let userid: String!
    let name: String!
}

class ReadingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var readingListTableView: UITableView!
    
    let loader = UIActivityIndicatorView()
    let api = Api()
    var arrayOfReadingListData = [readingListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readingListTableView.tableFooterView = UIView()
        
        //Initialize loader
        loader.frame = CGRect(x: 0, y: -65.0, width: self.view.frame.width, height: self.view.frame.height)
        loader.isHidden = false
        loader.hidesWhenStopped = true
        loader.backgroundColor = UIColor.white
        loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        self.loader.startAnimating()
        
        populateReadingList()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.refreshReadingList {
            self.arrayOfReadingListData.removeAll()
            self.view.bringSubview(toFront: loader)
            self.loader.startAnimating()
            populateReadingList()
            appDelegate.refreshReadingList = false
        } else {
            print("No new items added")
        }
    }

    func populateReadingList() {
        let request = api.populateReadingList()
        request.validate()
        request.responseJSON { response in
            if response.error != nil {
                self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
            } else {
                if let jsonValue = response.result.value {
                    let results = JSON(jsonValue)["results"]
                    if results.count > 0 {
                        for item in results.arrayValue {
                            let url = URL(string: self.api.BASE_URL + item["avatarpath"].stringValue)
                            let data = try? Data(contentsOf: url!)
                            self.arrayOfReadingListData.append(readingListData(threadno: item["srno"].stringValue, threadTitle: item["title"].stringValue, avatarImage: UIImage(data: data!), timeElapsed: item["timestamp"].stringValue, userid: item["uid"].stringValue, name: item["fname"].stringValue + " " + item["lname"].stringValue))
                        }
                        self.loader.stopAnimating()
                        self.readingListTableView.reloadData()
                        return
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfReadingListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "readingListCell", for: indexPath) as! ReadingListTableViewCell
        
        cell.avatarImageView.image = arrayOfReadingListData[indexPath.row].avatarImage
        cell.threadTitle.text = arrayOfReadingListData[indexPath.row].threadTitle
        cell.timeElapsedLabel.text = arrayOfReadingListData[indexPath.row].timeElapsed
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}