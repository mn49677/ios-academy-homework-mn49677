//
//  Result.swift
//  TV Shows
//
//  Created by Maximilian Novak on 02.08.2022..
//

import Foundation

extension Result where Success == Void {
    public static var success: Result { .success(()) }
}
