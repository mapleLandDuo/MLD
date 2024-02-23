//
//  DictLandingViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

import SnapKit

class DictLandingViewController: BasicController {
    // MARK: - Properties

    var viewModel: DictLandingViewModel
    
    // MARK: - Components
    
    var headerView = DictLandingHeaderView()
    
    var firstSectionView = DictLandingSearchView()
    
    var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .semanticColor.bg.primary
        let separator = UIView()
        separator.backgroundColor = .semanticColor.bolder.secondary
        
        view.addSubview(separator)
        separator.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        return view
    }()
    
    var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
        return view
    }()

    init(viewModel: DictLandingViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension DictLandingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setUp()
        viewModel.fetchSectionDatas()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - SetUp
private extension DictLandingViewController {
    func setUp() {
        setUpConstraints()
        headerView.delegate = self
        firstSectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DictHorizontalSectionTableViewCell.self, forCellReuseIdentifier: DictHorizontalSectionTableViewCell.identifier)
    }
    
    func setUpConstraints() {
        view.addSubview(headerView)
        view.addSubview(firstSectionView)
        view.addSubview(separatorView)
        view.addSubview(tableView)
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        firstSectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(firstSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(Constants.spacings.xl_2)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Bind
private extension DictLandingViewController {
    func bind() {
        viewModel.sectionHeaderInfos.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}

extension DictLandingViewController: DictLandingSearchViewDelegate {
    func didTapButton() {
        print(#function)
    }
    
    func searchBarSearchButtonClicked(searchBarText: String?) {
        print(searchBarText)
    }
    
}

extension DictLandingViewController: DictLandingHeaderViewDelegate {
    func didTapInquireButton() {
        print(#function)
    }
    
    func didTapJobBadgeButton() {
        print(#function)
    }
    
    func didTapMyPageButton() {
        let vc = LoginViewController(viewModel: LoginViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DictLandingViewController: DictHorizontalSectionTableViewCellDelegate {
    func didSelectItemAt(itemTitle: String?) {
        print(itemTitle)
    }
    
    func didTapCellButton(sectionTitle: String?) {
        print(sectionTitle)
    }
}

extension DictLandingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchSectionHeaderInfos()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DictHorizontalSectionTableViewCell.identifier, for: indexPath) as? DictHorizontalSectionTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        guard let datas = viewModel.fetchSectionHeaderInfos() else { return UITableViewCell() }
        cell.bind(data: datas[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.spacings.xl_3
    }
}
