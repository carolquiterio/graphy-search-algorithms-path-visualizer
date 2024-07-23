//
//  Djkstra.swift
//  SearchAlgorithm
//
//  Created by Carol Quiterio on 20/07/24.
//

import Foundation

func dijkstra(graph: [String: [String]], source: String, goal: String) -> SinglePathSolution {
    var distances = [String: Int]()
    var previousNodes = [String: String]()
    var unvisitedNodes = Set(graph.keys)
    
    for node in graph.keys {
        distances[node] = Int.max
    }
    distances[source] = 0
    
    var visited = [String]()
    
    while !unvisitedNodes.isEmpty {
        let currentNode = unvisitedNodes.min { (a, b) -> Bool in
            (distances[a] ?? Int.max) < (distances[b] ?? Int.max)
        }!
        
        if currentNode == goal {
            var path = [String]()
            var node = goal
            
            while let prev = previousNodes[node] {
                path.append(node)
                node = prev
            }
            path.append(source)
            path.reverse()
            
            return SinglePathSolution(
                hasPath: true,
                visitedList: visited,
                finalPath: path
            )
        }
        
        unvisitedNodes.remove(currentNode)
        visited.append(currentNode)
        
        if let neighbors = graph[currentNode] {
            for neighbor in neighbors {
                let newDist = (distances[currentNode] ?? Int.max) + 1
                if newDist < (distances[neighbor] ?? Int.max) {
                    distances[neighbor] = newDist
                    previousNodes[neighbor] = currentNode
                }
            }
        }
    }
    
    return SinglePathSolution(
        hasPath: false,
        visitedList: visited,
        finalPath: []
    )
}
