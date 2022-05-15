//
//  ViewController.swift
//  ChatApp
//
//  Created by s b on 13.05.2022.
//

import UIKit

class ViewController: UITableViewController, AlertDisplayer {
    
    var offsetIndex = 0
    
    var messages = [Message]()
    
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        
        fetchMessages(by: offsetIndex)
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.separatorStyle = .none
        
        tableView.allowsSelection = true
    }
    
    func fetchMessages(by offset: Int) {
        
        let mf = MessageFetcher()
        
        mf.fetchMessages(offset: offset, completion: { (result) in
            
            switch result {
                
            case .success(let res):
                
                self.messages.append(contentsOf: res)
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
                
                snapshot.appendSections([.all])
                snapshot.appendItems(self.messages, toSection: .all)
                
                self.dataSource.apply(snapshot, animatingDifferences: false)
                
            case .failure(let error):
                self.displayAlert(message: error.localizedDescription)
            }
        })
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    // MARK: - Table view data source
    func configureDataSource() -> UITableViewDiffableDataSource<Section, Message> {
        
        let cellIdentifier = "defaultcell"
        
        let dataSource = MessagesDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, message in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageBubbleView
                
                cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                
                cell.messageLabel?.text = message.text
                cell.messageLabel?.numberOfLines = 0
                
                
//                cell.bounds = cell.bounds.insetBy(dx: 0, dy: 20.0);
                
                return cell
            }
        )
        return dataSource
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("test")
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {

            // increments the number of the page to request
            offsetIndex += 20

            // call your API for more data
            fetchMessages(by: offsetIndex)

            // tell the table view to reload with the new data
            self.tableView.reloadData()
        }
    }
    
}

