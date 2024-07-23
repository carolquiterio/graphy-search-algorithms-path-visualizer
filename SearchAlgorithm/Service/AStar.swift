//
//  AStar.swift
//  SearchAlgorithm
//
//  Created by Carol Quiterio on 20/07/24.
//
import Foundation
import CoreGraphics // Para usar funções de distância Euclidean

enum Heuristic {
    case euclidean
    case manhattan
    case diagonal
}

// Função para extrair coordenadas dos nomes dos nós
func extractCoordinates(node: String) -> CGPoint? {
    let components = node.split(separator: "-").map { Int($0) }
    if components.count == 2, let x = components[0], let y = components[1] {
        return CGPoint(x: x, y: y)
    }
    return nil
}

func aStar(graph: [String: [String]], source: String, goal: String, heuristic: Heuristic = .euclidean) -> SinglePathSolution {
    var openSet = Set([source])
    var cameFrom = [String: String]()
    var gScore = [String: Int]()
    var fScore = [String: Int]()
    
    for node in graph.keys {
        gScore[node] = Int.max
        fScore[node] = Int.max
    }
    
    gScore[source] = 0
    fScore[source] = heuristicCostEstimate(start: source, goal: goal, heuristic: heuristic)
    
    var visited = [String]()
    
    while !openSet.isEmpty {
        let current = openSet.min { (a, b) -> Bool in
            (fScore[a] ?? Int.max) < (fScore[b] ?? Int.max)
        }!
        
        if current == goal {
            var path = [String]()
            var node = goal
            
            while let prev = cameFrom[node] {
                path.append(node)
                node = prev
            }
            path.append(source)
            path.reverse()
            
            return SinglePathSolution(
                hasPath: true,
                visitedList: path, // Visited list agora contém apenas os nós do caminho final
                finalPath: path
            )
        }
        
        openSet.remove(current)
        visited.append(current)
        
        if let neighbors = graph[current] {
            for neighbor in neighbors {
                let tentativeGScore = (gScore[current] ?? Int.max) + 1
                
                if tentativeGScore < (gScore[neighbor] ?? Int.max) {
                    cameFrom[neighbor] = current
                    gScore[neighbor] = tentativeGScore
                    fScore[neighbor] = tentativeGScore + heuristicCostEstimate(start: neighbor, goal: goal, heuristic: heuristic)
                    
                    if !openSet.contains(neighbor) {
                        openSet.insert(neighbor)
                    }
                }
            }
        }
    }
    
    return SinglePathSolution(
        hasPath: false,
        visitedList: [], // Visited list vazio se não encontrar caminho
        finalPath: []
    )
}

func heuristicCostEstimate(start: String, goal: String, heuristic: Heuristic) -> Int {
    guard let startCoord = extractCoordinates(node: start), let goalCoord = extractCoordinates(node: goal) else {
        return Int.max
    }
    
    let dx = abs(startCoord.x - goalCoord.x)
    let dy = abs(startCoord.y - goalCoord.y)
    
    switch heuristic {
    case .euclidean:
        return Int(sqrt(dx * dx + dy * dy))
    case .manhattan:
        return Int(dx + dy)
    case .diagonal:
        return Int(max(dx, dy))
    }
}
