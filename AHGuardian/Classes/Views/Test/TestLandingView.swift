
import UIKit

class TestLandingView: UIView {

    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        view.color = .white

        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.tableFooterView = self.activityIndicatorView
        view.tableFooterView?.isHidden = true
        view.backgroundColor = bg_color
        view.register(cellType: TestTableViewCell.self)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TestLandingView: ViewConfiguration {
    
    func configureViews() {
        backgroundColor = bg_color
    }
    
    func buildViewHierarchy() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
}
