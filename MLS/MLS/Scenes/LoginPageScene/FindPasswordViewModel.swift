//
//  FindPasswordViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/23.
//

import Foundation

import FirebaseAuth

class FindPasswordViewModel {
    
}

// MARK: Methods
extension FindPasswordViewModel {
    func checkEmailValidation(email: String, completion: @escaping (CustomButtonType) -> Void) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            completion(.clickabled)
        } else {
            completion(.disabled)
        }
    }
    
    func checkEmailExist(email: String, completion: @escaping (Bool) -> Void) {
        completion(email == "email.com")
    }
    
    func findPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                print("send Email")
            } else {
                print("Email sending failed.")
            }
        }
    }
}
