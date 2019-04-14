//
//  GalleryViewController.swift
//  PhotoBrowser
//
//  Created by What on 2019/4/14.
//  Copyright © 2019 dumbass. All rights reserved.
//

import UIKit
import MBUIKit

class GalleryCell: UITableViewCell {
}

class GalleryViewController: UITableViewController, StoryboardRepresentable {
    
    private var albums: [Album] = []
    private var presenter: GalleryPresenterInput!
    static var sbName: String { return "Browser" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = GalleryPresenter(output: self)
        presenter.loadItems()
    }
}

extension GalleryViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch albums[section] {
        case .all: return 1
        case .album(let album): return album.count
        case .userCollection(let userCollection): return userCollection.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeue(GalleryCell.self, for: indexPath)
        switch albums[indexPath.section] {
        case .all: cell.textLabel?.text = "All Photos"
        case .album(let album):
            cell.textLabel?.text = album.object(at: indexPath.item).localizedTitle
        case .userCollection(let userCollection):
            cell.textLabel?.text = userCollection.object(at: indexPath.item).localizedTitle
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch albums[section] {
        case .all: return ""
        case .album: return "Album"
        case .userCollection: return "Others"
        }
    }
}

extension GalleryViewController: GalleryPresenterOutput {
    func updated(_ albums: [Album]) {
        self.albums = albums
        tableView.reloadData()
    }
}

