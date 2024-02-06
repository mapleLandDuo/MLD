//
//  QnaViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/24.
//

import UIKit

import MessageUI
import SnapKit

class QnAViewController: UIViewController {
    // MARK: Properties

    private let viewModel = QnAPageViewModel()

    // MARK: Components

    private let qnaTableView = UITableView()
}

// MARK: Life Cycle
extension QnAViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: SetUp
private extension QnAViewController {
    func setUp() {
        self.qnaTableView.delegate = self
        self.qnaTableView.dataSource = self

        self.setUpConstraints()
    }

    func setUpConstraints() {
        view.addSubview(self.qnaTableView)

        self.qnaTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: Method
private extension QnAViewController {
    func tapCallCell(num: String) {
        if let url = NSURL(string: "tel://0" + "\(num)"),
           UIApplication.shared.canOpenURL(url as URL)
        {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}

extension QnAViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.viewModel.fetchContactCount() : self.viewModel.fetchQuestionCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        if indexPath.section == 0 {
            let item = self.viewModel.fetchContactList()[indexPath.row]
            cell.imageView?.tintColor = .systemOrange
            cell.imageView?.image = item.icon
            cell.textLabel?.text = item.title
            cell.selectionStyle = .none
        } else {
            let item = self.viewModel.fetchQuestionList()[indexPath.row]
            cell.textLabel?.text = "\(indexPath.row + 1) . \(item.title)"
            cell.selectionStyle = .none
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        headerLabel.font = Typography.title1.font
        headerLabel.textAlignment = .center
        headerLabel.textColor = .black
        headerLabel.text = section == 0 ? "문의하기" : "자주 찾는 질문"
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLabel)

        headerLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(headerView)
            $0.bottom.equalTo(headerView).inset(Constants.defaults.vertical)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch self.viewModel.fetchContactList()[indexPath.row].type {
            case .email:
                self.tapMailCell()
            case .kakaoTalk:
                AlertMaker.showAlertAction1(title: "업데이트 예정", message: "업데이트 예정 기능입니다.")
            case .call:
                self.tapCallCell(num: self.viewModel.fetchContactList()[indexPath.row].title)
            }
        case 1:
            let vc = TextController(text: "업데이트 예정 기능입니다.")
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension QnAViewController: MFMailComposeViewControllerDelegate {
    private func checkMail() {
        let sendMailErrorAlert = UIAlertController(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }

    private func tapMailCell() {
        if MFMailComposeViewController.canSendMail() {
            let compseViewController = MFMailComposeViewController()
            compseViewController.mailComposeDelegate = self
            compseViewController.setToRecipients(["maplelands2024@gmail.com"])
            compseViewController.setSubject("문의하기")
            compseViewController.setMessageBody("문의 내용을 자세하게 입력해 주세요!", isHTML: false)

            self.present(compseViewController, animated: true, completion: nil)

        } else {
            print(Error.self)
            self.checkMail()
        }
    }
}
