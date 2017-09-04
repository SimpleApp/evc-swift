//
//  WeakObserverOrderedSet.swift
//  EVC
//
//  Created by Benjamin Garrigues on 04/09/2017.
//  Based on http://www.gregread.com/2016/02/23/multicast-delegates-in-swift/

// This struct is used by services to store the list of objects interested in
// receiving notifications.
// Is is not meant to be used elsewhere in your project, unless you know
// what you're doing in terms of performance and memory safety.

struct WeakObserverOrderedSet<T> {

    struct Weak{
        weak var value: AnyObject?
        init(_ v: AnyObject) {
            value = v
        }
    }

    var elements : [Weak] = []

    private func indexOf(value: AnyObject) -> Int? {
        for (i,v) in elements.enumerated() {
            if v.value === value {
                return i
            }
        }
        return nil
    }

    mutating func add(value : T) {
        let anyValue = value as AnyObject
        guard indexOf(value: anyValue) == nil else { return }
        elements.append(Weak(anyValue))
    }

    mutating func remove(value: T) {
        let anyValue = value as AnyObject
        guard let i = indexOf(value: anyValue) else { return }
        elements.remove(at: i)
    }

    mutating func removeReleasedObservers() {
        elements = elements.filter { $0.value != nil}
    }

    func invoke(_ f:((T) -> Void)) {
        for e in elements {
            if let eVal = e.value as? T {
                f(eVal)
            }
        }
    }
}
