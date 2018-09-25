
import UIKit

final class TestTableDataProvider<T: FeedViewModelType>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var items:[T] = []
    var tableView: UITableView?
    var loadMore: ((_ index: Int) -> ())?

    required init(with tableView: UITableView) {
        super.init()

        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TestTableViewCell.self)
        let item = self.items[indexPath.row]
        cell.setup(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMore?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func updateTableView(with items: [T]) {
        self.items = items
        self.tableView?.reloadData()
    }

    func insertNewItemsInTableView(with items: [T]) {
        self.items += items

        let count = self.items.count
        var indexPaths = [IndexPath]()
        for row in count - 10..<count {
            let path = IndexPath(row: row, section: 0)
            indexPaths.append(path)
        }

        tableView?.reloadData()
    }
}
