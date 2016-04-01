//
//  SynchronizedArray.swift
//  Pods
//
//  Created by Merrick on 4/1/16.
//
//

import Foundation

public struct SynchronizedArray<Element: Hashable>: CollectionType {
    
    public typealias Index = Array<Element>.Index
    
    private var array: [Element]
    private let accessQueue = dispatch_queue_create("SynchronizedArrayAccess", DISPATCH_QUEUE_SERIAL)
    
    public var startIndex: Index { get { return self.synchrizedArray.startIndex } }
    public var endIndex: Index { get { return self.synchrizedArray.endIndex } }
    public var count: Index.Distance { get { return self.synchrizedArray.count } }
    
    public subscript(index: Int) -> Element {
        set {
            dispatch_sync(self.accessQueue) {
                self.array[index] = newValue
            }
        }
        get {
            var element: Element!
            
            dispatch_sync(self.accessQueue) {
                element = self.array[index]
            }
            
            return element
        }
    }
    
    public mutating func append(newElement: Element) {
        dispatch_sync(self.accessQueue) {
            self.array.append(newElement)
        }
    }
    
    public mutating func appendContentsOf<S : SequenceType where S.Generator.Element == Element>(newElements: S) {
        for e in newElements {
            self.append(e)
        }
    }
    
    public mutating func appendContentsOf<C : CollectionType where C.Generator.Element == Element>(newElements: C) {
        for e in newElements {
            self.append(e)
        }
    }
    
    public mutating func removeAtIndex(index: Index) {
        dispatch_sync(self.accessQueue) {
            self.array.removeAtIndex(index)
        }
    }
    
    public func indexOf(element: Element) -> Index? {
        var index: Index? = nil
        dispatch_sync(self.accessQueue) {
            index = self.array.indexOf(element)
        }
        return index
    }
    
    public func generate() -> IndexingGenerator<Array<Element>> {
        var array: [Element] = [Element]()
        dispatch_sync(self.accessQueue) {
            array = self.array
        }
        return IndexingGenerator(array)
    }
    
    public init() {
        self.array = [Element]()
    }
    
    public init(_ array: [Element]) {
        self.array = array
    }
    
    private var synchrizedArray : [Element] {
        get {
            var array: [Element]!
            dispatch_sync(self.accessQueue) {
                array = self.array
            }
            return array
        }
    }

    mutating func plusEqual(other: [Element]) {
        dispatch_sync(self.accessQueue) {
            other.forEach { e in
                if let index = self.array.indexOf(e) {
                    self.array[index] = e
                } else {
                    self.array.append(e)
                }
            }
        }
    }
    
    mutating func minusEqual(other: [Element]) {
        other.forEach { it in
            if let index = self.indexOf(it) {
                self.removeAtIndex(index)
            }
        }
    }
}

public func +=<T: Hashable>(inout left:SynchronizedArray<T>, right: [T]) {
    left.plusEqual(right)
}

public func -=<T:Hashable>(inout left:SynchronizedArray<T>, right: [T]) {
    left.minusEqual(right)
}

public func +=<T: Hashable>(inout left:SynchronizedArray<T>, right: T) {
    left += [right]
}

public func -=<T:Hashable>(inout left:SynchronizedArray<T>, right: T) {
    left -= [right]
}

private func +<T: Hashable>(left: [T], right: [T]) -> [T] {
    return Array<T>(Set<T>(left).union(Set<T>(right)))
}

private func -<T: Hashable>(left: [T], right: [T]) -> [T] {
    return Array<T>(Set<T>(left).subtract(Set<T>(right)))
}



















