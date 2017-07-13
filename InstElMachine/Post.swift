//
//  Post.swift
//  InstElMachine
//
//  Created by infuntis on 12/07/17.
//  Copyright © 2017 gala. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Post {
    
    let tags: String
    let ref: DatabaseReference?
    let imageUrl: String
    
    init(imageUrl: String, tags: String) {
        self.tags = tags
        self.imageUrl = imageUrl
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        imageUrl = snapshotValue["imageUrl"] as! String
        tags = snapshotValue["tags"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "imageUrl": imageUrl,
            "tags": tags
        ]
    }
    
}
