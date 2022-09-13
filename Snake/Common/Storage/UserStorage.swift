//
//  UserStorage.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import Foundation

protocol DefaultsStorageInterface: AnyObject {
    var gameSpeed: GameSpeed { get set }
    var arenaSize: ArenaSize { get set }
    var shouldShowSettingsInformation: Bool { get set }
}

final class UserStorage {

    // MARK: - Singleton -

    static let instance: DefaultsStorageInterface = UserStorage()
    private init() { }

    // MARK: - Properties -

    // MARK: - User defaults storage

    @UserDefault(.gameSpeed, defaultValue: Constants.GameSpeed.normal)
    var gameSpeedValue: String

    @UserDefault(.arenaSize, defaultValue: Constants.ArenaSize.medium)
    var arenaSizeValue: String

    @UserDefault(.shouldShowSettingsInformation, defaultValue: true)
    var shouldShowSettingsInformation: Bool
}

// MARK: - Extensions -

// MARK: - DefaultsStorageInterface conformance -

extension UserStorage: DefaultsStorageInterface {

    var gameSpeed: GameSpeed {
        get {
            switch gameSpeedValue {
            case Constants.GameSpeed.slow:
                return .slow
            case Constants.GameSpeed.normal:
                return .normal
            case Constants.GameSpeed.fast:
                return .fast
            default:
                return .normal
            }
        }
        set { gameSpeedValue = newValue.rawValue }
    }

    var arenaSize: ArenaSize {
        get {
            switch arenaSizeValue {
            case Constants.ArenaSize.small:
                return .small
            case Constants.ArenaSize.medium:
                return .medium
            case Constants.ArenaSize.large:
                return .large
            default:
                return .medium
            }
        }
        set { arenaSizeValue = newValue.rawValue }
    }
}

// MARK: - Keys

extension UserStorage {

    enum DefaultsKeys: String, CaseIterable {
        case gameSpeed
        case arenaSize
        case shouldShowSettingsInformation
    }
}

