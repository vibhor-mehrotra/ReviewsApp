//
//  ReviewListingVC.swift
//  ReviewsApp
//
//

import UIKit

final class ReviewListingVC: BaseVC {
    @IBOutlet weak var tableview: UITableView!
    var viewModel: ReviewListingVMProtocol!
    private let footerNib = "FooterView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicator()
        viewModel.fetchReviews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(presentSortOptions))
    }
    
    private func setLoadingFooterView() {
        let containerView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 130))
        let loadingView = Bundle.main.loadNibNamed(footerNib, owner: self, options: nil)!.last as! UIView
        loadingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 90)
        containerView.addSubview(loadingView)
        self.tableview.tableFooterView = containerView
    }
    
    private func scrollToTop(){
        if tableview.numberOfRows(inSection: 0) != 0 {
            tableview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @objc private func presentSortOptions() {
        let action = UIAlertController.actionSheetWithItems(items: viewModel.sorts, currentSelection: viewModel.selectedSort, action: { [weak self](value)  in
            guard let `self` = self else {
                return
            }
            self.showActivityIndicator()
            self.scrollToTop()
            self.viewModel.updateSort(value)
         })
         self.present(action, animated: true, completion: nil)
    }
}

extension ReviewListingVC: ReviewListVMDelegate{
    func didReceiveResponse(){
        hideActivityIndicator()
        self.tableview.isHidden = false
        self.tableview.tableFooterView = nil
        self.tableview.reloadData()
    }
    
    func didFailWithError(_ error: String?){
        hideActivityIndicator()
        self.tableview.tableFooterView = nil
        guard let err = error else {
            return
        }
        showAlertView(title: Constants.errorTitle, message: err, firstBtnTitle: Constants.firstBtnTitle)
    }
    
    func displayFooterView(){
        setLoadingFooterView()
    }
}

extension ReviewListingVC: UITableViewDataSource, UITableViewDelegate{
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = viewModel.dataForRowAt(indexPath) else {
            return UITableViewCell()
        }
        let cell: ReviewListingTVCell = tableView.deque(cellForRowAt: indexPath)
        cell.configureCell(data)
        return cell
    }
}

