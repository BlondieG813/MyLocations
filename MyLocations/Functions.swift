//
//  Functions.swift
//  MyLocations
//
//  Created by Michelle Guthrie-Harrigan on 10/6/21.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}
