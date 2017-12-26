//
//  TableDataProviderProtocol.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 17/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit

protocol TableDataProviderProtocol: UITableViewDataSource, UITableViewDelegate {
    
    associatedtype T
    
    weak var tableView: UITableView? {get}
    var items:[T] {get}
    var didSelectPin: ((_ item: T) -> ())? { get }
    var loadMore: ((_ index: Int) -> ())? { get }

    init(with tableView: UITableView)
    func updateTableView(with items: [T])
    func insertNewItemsInTableView(with items: [T])
    func updateSelectButton(with index: Int, state: Bool)
}
