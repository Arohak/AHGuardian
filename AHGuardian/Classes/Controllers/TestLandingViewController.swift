
import UIKit
import Alamofire

final class TestLandingViewController: UIViewController {
    
    fileprivate typealias FeedsCallback = (_ model: LandingViewModelType) -> ()
    fileprivate typealias TableDataProvider = TestTableDataProvider

    fileprivate var tableDataProvider: TableDataProvider<FeedViewModel>?
    fileprivate var landingViewModel: LandingViewModelType?
    fileprivate let landingView = TestLandingView()
    fileprivate var tuple = (pageSize: 10, loading: false)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseConfig()
    }
}

//MARK: - Private Methods -
extension TestLandingViewController {
    
    private func baseConfig() {
        self.title = "News Feed"
        self.view = landingView
        
        configTableDataProvider()
        setupInitialState()
    }

    fileprivate func setupInitialState() {

        if APIHelper.isConnected() {
            getFeeds(showProgressHUD: true) { [weak self] viewModel in
                self?.update(with: viewModel)
            }
        } else {
            guard let landing = DBHelper.getLanding() else { return }
            let viewModel = LandingViewModel(landing)
            update(with: viewModel)
        }
    }
    
    fileprivate func configTableDataProvider() {
        tableDataProvider = TableDataProvider(with: landingView.tableView)
        tableDataProvider?.loadMore = loadMore
    }

    fileprivate func update(with  viewModel: LandingViewModelType) {
        landingViewModel = viewModel
        tableDataProvider?.updateTableView(with: viewModel.tableViewFeeds)
    }
}

//MARK: - Callbacks -
extension TestLandingViewController {
    
    fileprivate func loadMore(_ index: Int) {
        if !tuple.loading && index == tuple.pageSize - 1 {
            tuple.pageSize += 10
            tuple.loading = true
            landingView.activityIndicatorView.startAnimating()
            landingView.tableView.tableFooterView?.isHidden = false
            
            getFeeds { [weak self] viewModel in
                self?.tuple.loading = (viewModel.tableViewFeeds.count == 0)
                self?.landingView.activityIndicatorView.stopAnimating()
                self?.landingView.tableView.tableFooterView?.isHidden = true
                
                if viewModel.tableViewFeeds.count > 0 {
                    self?.landingViewModel?.tableViewFeeds += viewModel.tableViewFeeds
                    self?.tableDataProvider?.insertNewItemsInTableView(with: viewModel.tableViewFeeds)
                }
            }
        }
    }
}

//MARK: - API -
extension TestLandingViewController {
    
    private func checkNewFeeds() {
        NewsFeedEndpoint.getFeeds(showProgressHUD: false, pageSize: 1) { [weak self] data in
            let landing = Landing(data: data)
            guard let currentLanding = DBHelper.getLanding() else { return }
            
            if currentLanding.total != landing.total {
                self?.tuple = (pageSize: 10, loading: false)
                self?.setupInitialState()
            }
        }
    }

    private func getFeeds(showProgressHUD: Bool = false, callback: @escaping FeedsCallback) {
        NewsFeedEndpoint.getFeeds(showProgressHUD: showProgressHUD, pageSize: tuple.pageSize) { [weak self] data in
            let obj = Landing(data: data)

            //putt in store
            DBHelper.storeLanding(obj)

            //get from store
            guard let landing = DBHelper.getLanding((self?.tuple.pageSize)!) else { return }
            let viewModel = LandingViewModel(landing)
            callback(viewModel)
        }
    }
}
