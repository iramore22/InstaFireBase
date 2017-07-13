//
//  FeedViewController.swift
//  InstElMachine
//
//  Created by infuntis on 12/07/17.
//  Copyright © 2017 gala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import ActiveLabel

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ref = Database.database().reference(withPath: "instelmachine")
    var posts: [Post] = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        ref.observe(.value, with: { snapshot in
            var newItems: [Post] = []
            for item in snapshot.children {
                let postItem = Post(snapshot: item as! DataSnapshot)
                newItems.append(postItem)
            }
            self.posts = newItems.reversed()
            self.tableView.reloadData()
        })

    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedTableViewCell
        let postItem = posts[indexPath.row]
        cell.tagsLabel.enabledTypes = [.hashtag]
        cell.tagsLabel.text = postItem.tags
        cell.tagsLabel.handleHashtagTap { hashtag in
            self.findByHashTag(hashTag: hashtag)
        }
        cell.postImage.downloadImage(from: postItem.imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func findByHashTag(hashTag: String){
        var foundPosts:[Post] = []
        for post in posts {
            if post.tags.contains(hashTag) {
                foundPosts.append(post)
            }
        }
        let searchViewController = storyboard!.instantiateViewController(withIdentifier: "SearchResultsVC") as? SearhCollectionViewController
        searchViewController?.hashTag = hashTag
        searchViewController?.foundPosts = foundPosts
        
        self.navigationController!.pushViewController(searchViewController!, animated: true)
        self.navigationController?.navigationItem.title = hashTag
    }
    
    
}

class FeedTableViewCell: UITableViewCell{
    
    @IBOutlet weak var tagsLabel: ActiveLabel!
    
    @IBOutlet weak var postImage: UIImageView!
}

