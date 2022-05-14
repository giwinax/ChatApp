//
//  ViewController.swift
//  ChatApp
//
//  Created by s b on 13.05.2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var messages = [Message]()
    
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        
        fetchMessages(by: 0)
        // Do any additional setup after loading the view.
    }
    
    func fetchMessages(by offset: Int) {
        let mf = MessageFetcher()
        
        mf.fetchMessages(offset: offset, completion: { (result) in
            
            switch result {
                
            case .success(let res):
                
                self.messages = res
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
                
                snapshot.appendSections([.all])
                snapshot.appendItems(self.messages, toSection: .all)
                
                self.dataSource.apply(snapshot, animatingDifferences: false)
                
            case .failure(let error):
                
                print(error)
            }
        })
    }
    
    // MARK: - Table view data source
    func configureDataSource() -> UICollectionViewDiffableDataSource<Section, Message> {
        
        return MessagesDiffableDataSource(
            collectionView: collectionView,
            cellProvider: {  collectionView, indexPath, message in
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultcell", for: indexPath) as! MessageBubbleView
                
                cell.message = message.text
                
                return cell
            }
        )
    }
    
}

