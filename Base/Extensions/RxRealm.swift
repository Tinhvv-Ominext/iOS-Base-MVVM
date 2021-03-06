//
//  RxRealm.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/11/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

public enum RxRealmError: Error {
    case objectDeleted
    case unknown
}

// MARK: Realm Collections type extensions

/**
 `NotificationEmitter` is a protocol to allow for Realm's collections to be handled in a generic way.

 All collections already include a `addNotificationBlock(_:)` method - making them conform to `NotificationEmitter` just makes it easier to add Rx methods to them.

 The methods of essence in this protocol are `asObservable(...)`, which allow for observing for changes on Realm's collections.
 */
public protocol NotificationEmitter {

    associatedtype ElementType: RealmCollectionValue

    /**
     Returns a `NotificationToken`, which while retained enables change notifications for the current collection.

     - returns: `NotificationToken` - retain this value to keep notifications being emitted for the current collection.
     */
    func observe(_ block: @escaping (RealmCollectionChange<Self>) -> Void) -> NotificationToken

    func toArray() -> [ElementType]

    func toAnyCollection() -> AnyRealmCollection<ElementType>
}

/**
 `RealmChangeset` is a struct that contains the data about a single realm change set.

 It includes the insertions, modifications, and deletions indexes in the data set that the current notification is about.
 */
public struct RealmChangeset {
    /// the indexes in the collection that were deleted
    public let deleted: [Int]

    /// the indexes in the collection that were inserted
    public let inserted: [Int]

    /// the indexes in the collection that were modified
    public let updated: [Int]
}

public extension ObservableType where Element: NotificationEmitter {

    @available(*, deprecated, renamed: "collection(from:synchronousStart:)")
    static func from(_ collection: E, scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<E> {
        return self.collection(from: collection)
    }

    /**
     Returns an `Observable<E>` that emits each time the collection data changes.
     The observable emits an initial value upon subscription.

     - parameter from: A Realm collection of type `E`: either `Results`, `List`, `LinkingObjects` or `AnyRealmCollection`.
     - parameter synchronousStart: whether the resulting `Observable` should emit its first element synchronously (e.g. better for UI bindings)

     - returns: `Observable<E>`, e.g. when called on `Results<Model>` it will return `Observable<Results<Model>>`, on a `List<User>` it will return `Observable<List<User>>`, etc.
     */
    static func collection(from collection: Element, synchronousStart: Bool = true)
        -> Observable<Element> {

            return Observable.create { observer in
                if synchronousStart {
                    observer.onNext(collection)
                }

                let token = collection.observe { changeset in

                    let value: Element

                    switch changeset {
                        case .initial(let latestValue):
                            guard !synchronousStart else { return }
                            value = latestValue

                        case .update(let latestValue, _, _, _):
                            value = latestValue

                        case .error(let error):
                            observer.onError(error)
                            return
                    }

                    observer.onNext(value)
                }

                return Disposables.create {
                    token.invalidate()
                }
            }

    }

    @available(*, deprecated, renamed: "array(from:synchronousStart:)")
    static func arrayFrom(_ collection: E, scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<Array<E.ElementType>> {
        return array(from: collection)
    }

    /**
     Returns an `Observable<Array<E.Element>>` that emits each time the collection data changes. The observable emits an initial value upon subscription.
     The result emits an array containing all objects from the source collection.

     - parameter from: A Realm collection of type `E`: either `Results`, `List`, `LinkingObjects` or `AnyRealmCollection`.
     - parameter synchronousStart: whether the resulting Observable should emit its first element synchronously (e.g. better for UI bindings)

     - returns: `Observable<Array<E.Element>>`, e.g. when called on `Results<Model>` it will return `Observable<Array<Model>>`, on a `List<User>` it will return `Observable<Array<User>>`, etc.
     */
    static func array(from collection: Element, synchronousStart: Bool = true)
        -> Observable<Array<Element.ElementType>> {

            return Observable.collection(from: collection, synchronousStart: synchronousStart)
                .map { $0.toArray() }
    }

    @available(*, deprecated, renamed: "changeset(from:synchronousStart:)")
    static func changesetFrom(_ collection: E, scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<(AnyRealmCollection<E.ElementType>, RealmChangeset?)> {
        return changeset(from: collection)
    }

    /**
     Returns an `Observable<(E, RealmChangeset?)>` that emits each time the collection data changes. The observable emits an initial value upon subscription.

     When the observable emits for the first time (if the initial notification is not coalesced with an update) the second tuple value will be `nil`.

     Each following emit will include a `RealmChangeset` with the indexes inserted, deleted or modified.

     - parameter from: A Realm collection of type `E`: either `Results`, `List`, `LinkingObjects` or `AnyRealmCollection`.
     - parameter synchronousStart: whether the resulting Observable should emit its first element synchronously (e.g. better for UI bindings)

     - returns: `Observable<(AnyRealmCollection<E.Element>, RealmChangeset?)>`
     */
    static func changeset(from collection: Element, synchronousStart: Bool = true)
        -> Observable<(AnyRealmCollection<Element.ElementType>, RealmChangeset?)> {
            let objectsRef = ThreadSafeReference(to: collection.toAnyCollection())
            return Observable.create {[objectsRef] observer in
                let realm = try! Realm()
                guard let `objectsRef` = realm.resolve(objectsRef) else { return Disposables.create() }
                if synchronousStart {
                    observer.onNext((objectsRef, nil))
                }

                let token = objectsRef.observe { changeset in

                    switch changeset {
                        case .initial(let value):
                            guard !synchronousStart else { return }
                            observer.onNext((value, nil))
                        case .update(let value, let deletes, let inserts, let updates):
                            observer.onNext((value, RealmChangeset(deleted: deletes, inserted: inserts, updated: updates)))
                        case .error(let error):
                            observer.onError(error)
                            return
                    }
                }

                return Disposables.create {
                    token.invalidate()
                }
            }
    }

}

public extension Observable {

    @available(*, deprecated, renamed: "from(realm:)")
    static func from(_ realm: Realm, scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<(Realm, Realm.Notification)> {
        return from(realm: realm)
    }

    /**
     Returns an `Observable<(Realm, Realm.Notification)>` that emits each time the Realm emits a notification.

     The Observable you will get emits a tuple made out of:

     * the realm that emitted the event
     * the notification type: this can be either `.didChange` which occurs after a refresh or a write transaction ends,
     or `.refreshRequired` which happens when a write transaction occurs from a different thread on the same realm file

     For more information look up: [Realm.Notification](https://realm.io/docs/swift/latest/api/Enums/Notification.html)

     - parameter realm: A Realm instance
     - returns: `Observable<(Realm, Realm.Notification)>`, which you can subscribe to
     */
    static func from(realm: Realm) -> Observable<(Realm, Realm.Notification)> {

        return Observable<(Realm, Realm.Notification)>.create { observer in
            let token = realm.observe { (notification: Realm.Notification, realm: Realm) in
                observer.onNext((realm, notification))
            }

            return Disposables.create {
                token.invalidate()
            }
        }
    }
}

// MARK: Realm type extensions

extension Realm: ReactiveCompatible { }

extension Reactive where Base == Realm {

    /**
     Returns bindable sink wich adds object sequence to the current Realm

     - parameter: update - if set to `true` it will override existing objects with matching primary key
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<S>`, which you can use to subscribe an `Observable` to
     */
    public func add<S: Sequence>(update: Bool = false, onError: ((S?, Error)->Void)? = nil)
        -> AnyObserver<S> where S.Iterator.Element: Object {

            return RealmObserver(realm: base) { realm, elements, error in
                guard let realm = realm else {
                    onError?(nil, error ?? RxRealmError.unknown)
                    return
                }

                do {
                    try realm.safeWrite {
                        let updateFlag: Realm.UpdatePolicy = update ? .all : .error
                        realm.add(elements, update: updateFlag)
                    }
                } catch let e {
                    onError?(elements, e)
                }
            }
            .asObserver()
    }

    /**
     Returns bindable sink wich adds an object to Realm

     - parameter: update - if set to `true` it will override existing objects with matching primary key
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<O>`, which you can use to subscribe an `Observable` to
     */
    public func add<O: Object>(update: Bool = false,
                               onError: ((O?, Error)->Void)? = nil) -> AnyObserver<O> {

        return RealmObserver(realm: base) { realm, element, error in
            guard let realm = realm else {
                onError?(nil, error ?? RxRealmError.unknown)
                return
            }

            do {
                try realm.safeWrite {
                    let updateFlag: Realm.UpdatePolicy = update ? .all : .error
                    realm.add(element, update: updateFlag)
                }
            } catch let e {
                onError?(element, e)
            }
        }.asObserver()
    }

    /**
     Returns bindable sink wich deletes objects in sequence from Realm.

     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<S>`, which you can use to subscribe an `Observable` to
     */
    public func delete<S: Sequence>(onError: ((S?, Error)->Void)? = nil)
        -> AnyObserver<S> where S.Iterator.Element: Object {

            return RealmObserver(realm: base, binding: { realm, elements, error in
                guard let realm = realm else {
                    onError?(nil, error ?? RxRealmError.unknown)
                    return
                }

                do {
                    try realm.safeWrite {
                        realm.delete(elements)
                    }
                } catch let e {
                    onError?(elements, e)
                }
            }).asObserver()
    }

    /**
     Returns bindable sink wich deletes objects in sequence from Realm.

     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<O>`, which you can use to subscribe an `Observable` to
     */
    public func delete<O: Object>(onError: ((O?, Error)->Void)? = nil) -> AnyObserver<O> {
        return RealmObserver(realm: base, binding: { realm, element, error in
            guard let realm = realm else {
                onError?(nil, error ?? RxRealmError.unknown)
                return
            }

            do {
                try realm.safeWrite {
                    realm.delete(element)
                }
            } catch let e {
                onError?(element, e)
            }
        }).asObserver()
    }
}

extension Reactive where Base == Realm {

    /**
     Returns bindable sink wich adds object sequence to a Realm

     - parameter: configuration (by default uses `Realm.Configuration.defaultConfiguration`)
     to use to get a Realm for the write operations
     - parameter: update - if set to `true` it will override existing objects with matching primary key
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<S>`, which you can use to subscribe an `Observable` to
     */
    public static func add<S: Sequence>(
        configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration,
        update: Bool = false,
        onError: ((S?, Error)->Void)? = nil) -> AnyObserver<S> where S.Iterator.Element: Object {

        return RealmObserver(configuration: configuration) { realm, elements, error in
            guard let realm = realm else {
                onError?(nil, error ?? RxRealmError.unknown)
                return
            }

            do {
                try realm.safeWrite {
                    let updateFlag: Realm.UpdatePolicy = update ? .all : .error
                    realm.add(elements, update: updateFlag)
                }
            } catch let e {
                onError?(elements, e)
            }
        }.asObserver()
    }

    /**
     Returns bindable sink which adds an object to a Realm

     - parameter: configuration (by default uses `Realm.Configuration.defaultConfiguration`)
     to use to get a Realm for the write operations
     - parameter: update - if set to `true` it will override existing objects with matching primary key
     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<O>`, which you can use to subscribe an `Observable` to
     */
    public static func add<O: Object>(
        configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration,
        update: Bool = false,
        onError: ((O?, Error)->Void)? = nil) -> AnyObserver<O> {

        return RealmObserver(configuration: configuration) { realm, element, error in
            guard let realm = realm else {
                onError?(nil, error ?? RxRealmError.unknown)
                return
            }

            do {
                try realm.safeWrite {
                    let updateFlag: Realm.UpdatePolicy = update ? .all : .error
                    realm.add(element, update: updateFlag)
                }
            } catch let e {
                onError?(element, e)
            }
        }.asObserver()
    }

    /**
     Returns bindable sink, which deletes objects in sequence from Realm.

     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<S>`, which you can use to subscribe an `Observable` to
     */
    public static func delete<S: Sequence>(onError: ((S?, Error)->Void)? = nil)
        -> AnyObserver<S>  where S.Iterator.Element: Object {

            return AnyObserver { event in

                guard let elements = event.element,
                    var generator = elements.makeIterator() as S.Iterator?,
                    let first = generator.next(),
                    let realm = first.realm else {
                        onError?(nil, RxRealmError.unknown)
                        return
                }

                do {
                    try realm.safeWrite {
                        realm.delete(elements)
                    }
                } catch let e {
                    onError?(elements, e)
                }
            }
    }

    /**
     Returns bindable sink, which deletes object from Realm

     - parameter: onError - closure to implement custom error handling
     - returns: `AnyObserver<O>`, which you can use to subscribe an `Observable` to
     */
    public static func delete<O: Object>(onError: ((O?, Error)->Void)? = nil) -> AnyObserver<O> {

        return AnyObserver { event in

            guard let element = event.element, let realm = element.realm else {
                onError?(nil, RxRealmError.unknown)
                return
            }

            do {
                try realm.safeWrite {
                    realm.delete(element)
                }
            } catch let e {
                onError?(element, e)
            }
        }
    }
}


