//
//  DataSourceItemReceiver.swift
//  DataSource
//
//  Created by Vadim Yelagin on 23/09/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

/// Implement this protocol in your `UITableViewCell` or `UICollectionView` subclass
/// to make it receive corresponding items of the dataSource associated
/// with a `TableViewDataSource` or a `CollectionViewDataSource`.
public protocol DataSourceItemReceiver: AnyObject {
	func ds_setItem(_ item: Any)
}

func configureReceiver(_ receiver: AnyObject, withItem item: Any) {
	if let receiver = receiver as? DataSourceItemReceiver {
		receiver.ds_setItem(item)
	}
}
