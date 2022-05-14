//
//  MessagesDiffableDataSource.swift
//  ChatApp
//
//  Created by s b on 13.05.2022.
//

import UIKit

class MessagesDiffableDataSource: UICollectionViewDiffableDataSource<Section, Message> {

    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
