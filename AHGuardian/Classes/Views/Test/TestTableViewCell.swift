
import UIKit
import Reusable
import PureLayout

extension TestTableViewCell: Reusable { }

class TestTableViewCell: UITableViewCell {
    
    lazy var cellContentView: TestTableViewCellContentView = {
        let view = TestTableViewCellContentView.newAutoLayout()

        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TestTableViewCell: ViewConfiguration {
    
    func configureViews() {
        selectionStyle = .none
    }
    
    func buildViewHierarchy() {
        contentView.addSubview(cellContentView)
    }
    
    func setupConstraints() {
        cellContentView.autoPinEdgesToSuperviewEdges()
    }
}

extension TestTableViewCell {
    
    func setup(with item: FeedViewModelType) {
        cellContentView.setup(with: item)
    }
}
