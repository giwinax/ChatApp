//
//  ViewController.swift
//  ChatApp
//
//  Created by s b on 13.05.2022.
//

import UIKit
import Alamofire

class ViewController: UITableViewController, AlertDisplayer {
    
    var offsetIndex = 0
    
    var messages = [Message]()
    
    lazy var dataSource = configureDataSource()
    
    var isFetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        
        fetchMessages(by: offsetIndex)
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.separatorStyle = .none
    
    }
    
    func fetchMessages(by offset: Int) {
//        guard !isFetching else {
//          return
//        }
        
        isFetching = true
        let mf = MessageFetcher()
        
        mf.fetchMessages(offset: offset, completion: { (result) in
            
            switch result {
                
            case .success(let res):
                self.isFetching = false
                self.messages.append(contentsOf: res)
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
                
                snapshot.appendSections([.all])
                snapshot.appendItems(self.messages, toSection: .all)
                
                self.dataSource.apply(snapshot, animatingDifferences: false)
                
            case .failure(let error):
                self.isFetching = false
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
                
                cell.id = message.id
               
//                cell.bounds = cell.bounds.insetBy(dx: 0, dy: 20.0);
                
                return cell
            }
        )
        return dataSource
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("asdasd")
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {

            offsetIndex += 20
            
            fetchMessages(by: offsetIndex)
        }
    }
    
}

