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
    
    var isEndOfData = false
    
    var messages = [Message]()
    
    lazy var dataSource = configureDataSource()
    
    let fetchAgent = MessageFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        
        fetchMessages(by: offsetIndex)
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.separatorStyle = .none
        
    }
    
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
                cell.loaded = message.loaded
                
                if !cell.loaded {
                    cell.loadingIndicator.startAnimating()
                }
                else {
                    cell.loadingIndicator.stopAnimating()
                    cell.loadingIndicator.hidesWhenStopped = true
                }
                
                return cell
            }
        )
        return dataSource
    }
    
    func fetchMessages(by offset: Int) {
        
        fetchAgent.fetchMessages(offset: offset, completion: { (result) in
            
            switch result {
                
            case .success(let res):
        
                self.messages.append(contentsOf: res)
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
                snapshot.appendSections([.all])
                snapshot.appendItems(self.messages, toSection: .all)
                self.dataSource.apply(snapshot, animatingDifferences: false)
                
            case .failure(let error):
                
                if error == .endOfDataError {
                    self.isEndOfData = true
                    return
                }
                
                self.displayAlert(message: error.localizedDescription)
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as! MessageBubbleView
        
        if !cell.loaded {
            
            let reloadAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
                
                let offsetToChange = Int(Int(cell.id)! / 20) * 20
                
                var reloadedMessages = [Message]()
                
                self.fetchAgent.fetchMessages(offset: offsetToChange, completion: { (result) in
                    
                    switch result {
                        
                    case .success(let res):
                        
                        reloadedMessages.append(contentsOf: res)
                        
                        self.messages[offsetToChange...offsetToChange+20] = ArraySlice<Message>(reloadedMessages)
                        
                        var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
                        snapshot.appendSections([.all])
                        snapshot.appendItems(self.messages, toSection: .all)
                        self.dataSource.apply(snapshot, animatingDifferences: false)
                        
                    case .failure(let error):
                        
                        if error == .endOfDataError {
                            self.isEndOfData = true
                            return
                        }
                        
                        self.displayAlert(message: error.localizedDescription)
                    }
                })
                
                completionHandler(true)
            }
            
            reloadAction.image = UIImage(systemName: "arrow.counterclockwise")
           
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [reloadAction])
            
            return swipeConfiguration
        }
        return UISwipeActionsConfiguration()
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            
            offsetIndex += 20
            if !endOfDataError {
            fetchMessages(by: offsetIndex)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

