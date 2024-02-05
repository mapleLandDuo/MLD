//
//  PostDetailViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/26.
//

import Foundation

class PostDetailViewModel {
    // MARK: Properties
    
    var comments: Observable<[Comment]> = Observable(nil)
    
    lazy var commentCount = 0
    
    var post: Observable<Post> = Observable(nil)
    
    var isUp: Observable<Bool> = Observable(false)
    
    var isEditing = false
    
    var editingComment: Comment?
    
    init(post: Post) {
        self.post.value = post
        updateViewCount()
    }
}

// MARK: Method
extension PostDetailViewModel {
    func loadPost(completion: @escaping () -> Void) {
        guard let postId = post.value?.id.uuidString else { return }
        FirebaseManager.firebaseManager.fetchPost(id: postId) { [weak self] post in
            self?.post.value = post
            completion()
        }
    }

    func deletPost(postId: String, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.deletePost(postID: postId) {
            completion()
        }
    }
    
    func loadComment(postId: String) {
        FirebaseManager.firebaseManager.fetchComments(postID: postId) { comments in
            if let count = comments?.count {
                self.commentCount = count
            }
            self.comments.value = comments
        }
    }
    
    func saveComment(postId: String, comment: Comment, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.saveComment(postID: postId, comment: comment) {
            completion()
        }
    }
    
    func updateComment(postId: String, comment: Comment, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.updateComment(postID: postId, comment: comment) {
            completion()
        }
    }
    
    func deleteComment(postId: String, commentId: String, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.deleteComment(postID: postId, commentID: commentId) {
            completion()
        }
    }
    
    func reportPost(postID: String, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.reportPost(postID: postID) {
            completion()
        }
    }
    
    func reportComment(postID: String, commentID: String, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.reportComment(postId: postID, commentId: commentID) {
            completion()
        }
    }
    
    func setLikeCount(postID: String, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.updateLikeCount(postID: postID) {
            completion()
        }
    }
    
    func checkMyPost() -> Bool {
        return post.value?.user == LoginManager.manager.email
    }
    
    func checkLikeCount(post: Post) {
        guard let myEmail = LoginManager.manager.email else { return }
        isUp.value = post.likes.contains(myEmail)
    }
    
    func toCompletePost(postID: String, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.toCompletePost(postID: postID) {
            completion()
        }
    }
    
    func isLogin() -> Bool {
        return LoginManager.manager.isLogin()
    }
    
    func updateViewCount() {
        guard let postId = post.value?.id.uuidString else { return }
        FirebaseManager.firebaseManager.updateViewCount(postID: postId)
    }
}
