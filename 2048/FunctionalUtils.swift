//
//  FunctionalUtils.swift
//  2048
//

func bind<T, U>(_ x: T, _ closure: (T) -> U) -> U {
  return closure(x)
}
