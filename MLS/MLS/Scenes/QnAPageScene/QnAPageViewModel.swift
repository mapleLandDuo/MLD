//
//  QnAPageViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/24.
//

import UIKit

class QnAPageViewModel {
    // MARK: Properties

    private let contactList = [
        Contact(icon: UIImage(systemName: "envelope.fill"), title: "text@naver.com", type: .email),
        Contact(icon: UIImage(systemName: "questionmark.bubble.fill"), title: "kakaoTalk", type: .kakaoTalk),
        Contact(icon: UIImage(systemName: "phone.circle.fill"), title: "010-xxxx-xxxx", type: .call),
    ]
    private let questionList = [
        Question(title: "사용방법이 궁금해요.", content: "사용방법이 어쩌구 저쩌구"),
        Question(title: "로그인은 언제 필요한가요?.", content: "로그인이 어쩌구 저쩌구"),
        Question(title: "추가될 기능은 무엇이 있나요?", content: "기능이 어쩌구 저쩌구"),
    ]
}

extension QnAPageViewModel {
    // MARK: Method

    func getContactList() -> [Contact] {
        return contactList
    }

    func getQuestionList() -> [Question] {
        return questionList
    }

    func getContactCount() -> Int {
        return contactList.count
    }

    func getQuestionCount() -> Int {
        return questionList.count
    }
}

struct Contact {
    let icon: UIImage?
    let title: String
    let type: ContactType
}

struct Question {
    let title: String
    let content: String
}

enum ContactType {
    case email
    case kakaoTalk
    case call
}
