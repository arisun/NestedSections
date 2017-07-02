//
//  MasterViewController.swift
//  NestedSections
//
//  Created by arindam_ghosh on 12/10/16.
//  Copyright © 2016 arindam_ghosh. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController,URLSessionDownloadDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var downloads : [DownloadModel]?
    var session : URLSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MasterViewController.insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: AnyObject) {
        let urls = ["https://upload.wikimedia.org/wikipedia/commons/f/fc/Chartley_Castle-1.jpg",
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Big_Bear_Valley%2C_California.jpg/1200px-Big_Bear_Valley%2C_California.jpg",
                    "https://peach.blender.org/wp-content/uploads/poster_rodents_bunnysize.jpg?x11217",
                    "https://peach.blender.org/wp-content/uploads/poster_bunny_big.jpg?x11217",
                    "http://www.bravurabaritones.com/wp-content/uploads/2015/07/Big-Water.jpg",
                    "http://static3.businessinsider.com/image/529c795c6bb3f7b44f3706ed/big-data-will-drive-the-next-phase-of-innovation-in-mobile-computing.jpg",
                    "https://peach.blender.org/wp-content/uploads/bbb-splash.png?x11217",
                    "https://upload.wikimedia.org/wikipedia/commons/f/fc/Chartley_Castle-1.jpg",
                    "https://upload.wikimedia.org/wikipedia/commons/f/fc/Chartley_Castle-1.jpg",
                    "https://upload.wikimedia.org/wikipedia/commons/f/fc/Chartley_Castle-1.jpg"]
        for i in 0..<10{
            objects.insert(Date() as AnyObject, at: 0)
            let url = urls[i]
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.startDownload(counter: i, withURL: url)
        }

        self.tableView.reloadData()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[(indexPath as NSIndexPath).row] as! Date
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object as AnyObject?
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomRowCellMaster

        let object = objects[(indexPath as NSIndexPath).row] as! Date
        cell.titleCell!.text = object.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    // MARK : Download Data

    func startDownload(counter: Int, withURL: String){
        if downloads == nil{
            downloads = [DownloadModel]()
        }
        let url : URL = URL(string: withURL)!
        let downloadTask = session?.downloadTask(with: url)
        let downloadModel : DownloadModel = DownloadModel()
        downloadModel.id = (downloadTask?.taskIdentifier)!
        print("taskID: \(downloadTask?.taskIdentifier)")
        downloadModel.rowID = counter
        downloads?.append(downloadModel)
        downloadTask?.resume()
    }

    // MARK: NSURLSessionDownloadDelegate methods


    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){

    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){

        //let count = downloads.count
        print("TASKID : \(downloadTask.taskIdentifier)")
        if (downloads?.contains(where: {$0.id == downloadTask.taskIdentifier}))!
        {
            guard let index = downloads?.index(where: {$0.id == downloadTask.taskIdentifier}) else {
                return
            }
            print("ID:\(downloadTask.taskIdentifier), index:\(index) \n")
            let indexpath = IndexPath(row: index, section: 0)
            DispatchQueue.main.async(execute: {
                if let cell = self.tableView.cellForRow(at: indexpath) as? CustomRowCellMaster {
                    cell.progressBar.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
                }
            })
        }

    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        if (error != nil) {
            print(error!.localizedDescription)
        }else{
            print("The task finished transferring data successfully")
        }
    }
}

