//
//  MessagesDiffableDataSource.swift
//  ChatApp
//
//  Created by s b on 13.05.2022.
//

import UIKit

class MessagesDiffableDataSource: UITableViewDiffableDataSource<Section, Message> {

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
