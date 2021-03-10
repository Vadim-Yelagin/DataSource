//
//  MappedDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Combine
import Foundation

/// `DataSource` implementation that returns data from
/// another dataSource (called inner dataSource) after transforming
/// its items with `transform` function and transforming its
/// supplementary items with `supplementaryTransform` function.
///
/// MappedDataSource listens to dataChanges of its inner dataSource
/// and emits them as its own changes.
public final class MappedDataSource: DataSource {

	public let innerDataSource: DataSource

	/// Function that is applied to items of the inner dataSource
	/// before they are returned as items of the mappedDataSource.
	private let transform: (Any) -> Any

	/// Function that is applied to supplementary items of the inner dataSource
	/// before they are returned as supplementary items of the mappedDataSource.
	///
	/// The first parameter is the kind of the supplementary item.
	private let supplementaryTransform: (String, Any?) -> Any?

	public let changes: AnyPublisher<DataChange, Never>
	private let changesPassthroughSubject = PassthroughSubject<DataChange, Never>()

	private var cancellable: AnyCancellable!

	public init(_ inner: DataSource, supplementaryTransform: @escaping ((String, Any?) -> Any?) = { $1 }, transform: @escaping (Any) -> Any) {
		self.changes = self.changesPassthroughSubject.eraseToAnyPublisher()
		self.innerDataSource = inner
		self.transform = transform
		self.supplementaryTransform = supplementaryTransform
		self.cancellable = inner.changes
			.sink { [weak self] in
				self?.changesPassthroughSubject.send($0)
			}
	}

	deinit {
		self.changesPassthroughSubject.send(completion: .finished)
	}

	public var numberOfSections: Int {
		let inner = self.innerDataSource
		return inner.numberOfSections
	}

	public func numberOfItemsInSection(_ section: Int) -> Int {
		let inner = self.innerDataSource
		return inner.numberOfItemsInSection(section)
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		let inner = self.innerDataSource
		let supplementaryItem = inner.supplementaryItemOfKind(kind, inSection: section)
		return self.supplementaryTransform(kind, supplementaryItem)
	}

	public func item(at indexPath: IndexPath) -> Any {
		let inner = self.innerDataSource
		let item = inner.item(at: indexPath)
		return self.transform(item)
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		let inner = self.innerDataSource
		return inner.leafDataSource(at: indexPath)
	}
}
