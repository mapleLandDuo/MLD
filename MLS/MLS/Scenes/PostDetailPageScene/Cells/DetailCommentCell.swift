//
//  DetailCommentCell.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/26.
//

import UIKit

import SnapKit

protocol DetailCommentCellDelegate: AnyObject {
    func tapDeleteButton(cell: DetailCommentCell, comment: Comment)
    func tapModifyButton(cell: DetailCommentCell, comment: Comment)
    func tapReportButton(cell: DetailCommentCell, comment: Comment)
    func tapCommentProfileNameLabel(email: String, nickName: String)
}

class DetailCommentCell: UITableViewCell {
    // MARK: - Properties

    weak var delegate: DetailCommentCellDelegate?

    var comment: Comment?

    // MARK: Components

    lazy var commentProfileNameLabel: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = Typography.button.font
        button.addAction(UIAction(handler: { [weak self] _ in
            if let self = self, let email = self.comment?.user, let nickName = self.commentProfileNameLabel.titleLabel?.text {
                self.delegate?.tapCommentProfileNameLabel(email: email, nickName: nickName)
            }
        }), for: .touchUpInside)
        return button
    }()

    lazy var optionStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [modifyButton, deleteButton, reportButton])
        view.axis = .horizontal
        return view
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.setTitleColor(.red, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            if let self = self, let comment = self.comment {
                self.delegate?.tapDeleteButton(cell: self, comment: comment)
            }
        }), for: .touchUpInside)
        return button
    }()

    lazy var modifyButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            if let self = self, let comment = self.comment {
                self.delegate?.tapModifyButton(cell: self, comment: comment)
            }
        }), for: .touchUpInside)
        return button
    }()

    lazy var reportButton: UIButton = {
        let button = UIButton()
        button.setTitle("신고", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            if let self = self, let comment = self.comment {
                self.delegate?.tapReportButton(cell: self, comment: comment)
            }
        }), for: .touchUpInside)
        return button
    }()

    private let commentTextLabel: CustomLabel = {
        let label = CustomLabel(text: "", font: .systemFont(ofSize: 16))
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Bind
private extension DetailCommentCell {
    func bind(name: String, comment: String) {
        commentProfileNameLabel.setTitle(name, for: .normal)
        commentTextLabel.text = comment
    }
}

// MARK: SetUp
private extension DetailCommentCell {
    func setUp() {
        setUpConstraints()
    }

    func setUpConstraints() {
        addSubview(commentProfileNameLabel)
        addSubview(optionStackView)
        addSubview(commentTextLabel)

        commentProfileNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        optionStackView.snp.makeConstraints {
            $0.centerY.equalTo(commentProfileNameLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
        }

        commentTextLabel.snp.makeConstraints {
            $0.top.equalTo(commentProfileNameLabel.snp.bottom).offset(Constants.defaults.vertical / 2)
            $0.leading.trailing.equalToSuperview().inset(Constants.defaults.horizontal)
            $0.bottom.equalToSuperview().inset(Constants.defaults.vertical / 2)
        }
    }
}

// MARK: Bind
extension DetailCommentCell {
    func bind(comment: Comment) {
        if LoginManager.manager.email == nil {
            optionStackView.isHidden = true
        } else if comment.user != LoginManager.manager.email {
            deleteButton.isHidden = true
            modifyButton.isHidden = true
        } else {
            reportButton.isHidden = true
        }
        IndicatorMaker.showLoading()
        comment.user.toNickName { [weak self] nickName in
            IndicatorMaker.hideLoading()
            if nickName == "탈퇴 회원" {
                self?.commentProfileNameLabel.isUserInteractionEnabled = false
                self?.commentProfileNameLabel.setTitleColor(.gray, for: .normal)
            }
            self?.commentProfileNameLabel.setTitle(nickName, for: .normal)
        }
        commentTextLabel.text = comment.comment
    }
}
