import UIKit
//
//
//class Node {
//    var nextNode: Node?
//    var value: String
//
//    init(value: String) {
//        self.value = value
//    }
//}
//
//let node1 = Node(value: "node1")
//let node2 = Node(value: "node2")
//let node3 = Node(value: "node3")
//let node4 = Node(value: "node4")
//
//node1.nextNode = node2
//node2.nextNode = node3
//node3.nextNode = node4
//node4.nextNode = nil
//
//func returnNextNode(from node: Node?)  {
//
//    guard let validNode = node else {
//        return
//    }
//    print(validNode.value)
//    returnNextNode(from: validNode.nextNode)
//
//}
//returnNextNode(from: node1)
//
//print("************************************************")
//
//
//func factorial(n: Int) -> Int{
//
//    return n < 2 ? 1 : n * factorial(n: n - 1)
//
//}
//print (factorial(n: 5))
//
//print("************************************************")
//print("************************************************")
//
//func sumNumbers (n: Int) -> Int {
//    return n <= 0 ? 0 : n + sumNumbers(n: n - 1)
//}
//print(sumNumbers(n: 3))

//var numbers = [Int]()
//numbers.append(0)
//numbers.append(1)
//print(numbers)

// MARK: - Selection Sort
func selectionSort(input: [Int]) -> [Int] {
    
    guard input.count > 1 else {
        return input
    }
    
    var result = input
    for i in 0..<result.count - 1{
        let smallest = i
        for j in i + 1..<result.count {
            let nextItem = j
            
            if result[nextItem] < result[smallest] {
                result.swapAt(nextItem, smallest)
            }
        }
    }
    return result
}
//print (selectionSort(input: [4,6,2,8,3,9,19,3,2,1,2,4,0]))

// MARK: - Instertion Sort
func InstertionSort(input: [Int]) -> [Int] {
    
    var result = input
    let count = input.count
    
    for i in 1..<count {
        var sortedindex = i
        while sortedindex > 0 && (result[sortedindex] < result[sortedindex - 1]) {
            result.swapAt(sortedindex, sortedindex - 1)
            sortedindex -= 1 // to check if we swapped the elements for ex : [5 7 3 ] first time we will swap 3 with 7 then we will reduce the index by 1 to be able to check and compare 5 with 3 [5 3 7]  so finally we will have [3 5 7 ]
        }
    }
    
    
    
    return result
}
//print (InstertionSort(input: [4,6,2,8,3,9,19,3,2,1,2,4,0]))

// MARK: - Bubble Sort
func BubbleSort(input: [Int]) -> [Int] {
    
    var result = input
    let count = input.count
    var isSwapped = false
    guard count > 1 else {
        return result
    }
    repeat {
        isSwapped = false
    for i in 1..<count {
            if (result[i] < result[i - 1]) {
                result.swapAt(i, i - 1)
                isSwapped = true
            }
        }
    } while isSwapped
     return result
        
}
//print (BubbleSort(input: [4,6,2,8,3,9,19,100,3,2,1,2,4,0]))

// MARK: - Merge Sort
func MergeSort(input: [Int]) -> [Int] {
    let count = input.count
    guard count > 1 else {
        return input
    }
    let middleIndex = count / 2
    let leftArray = MergeSort(input: Array(input[0..<middleIndex]))
    let rightArray = MergeSort(input: Array(input[middleIndex..<count]))
    return (mergeArrays(leftArray: leftArray, rightArray: rightArray))
 
}

func mergeArrays (leftArray: [Int],rightArray: [Int] ) -> [Int] {
    
    var sorted: [Int] = []
    var leftIndex = 0
    var rightIndex = 0
    
    while rightIndex < rightArray.count && leftIndex < leftArray.count {
        if leftArray[leftIndex] < rightArray[rightIndex] {
            sorted.append(leftArray[leftIndex])
            leftIndex += 1
        }
         else if leftArray[leftIndex] > rightArray[rightIndex] {
            sorted.append(rightArray[rightIndex])
            rightIndex += 1
        }
        else {
            sorted.append(leftArray[leftIndex])
            leftIndex += 1
            sorted.append(rightArray[rightIndex])
            rightIndex += 1
        }
        
    }
    if  leftIndex < leftArray.count  {
        
        sorted.append(contentsOf: leftArray[leftIndex..<leftArray.count])
    }
    else if rightIndex < rightArray.count {
        sorted.append(contentsOf: rightArray[rightIndex..<rightArray.count])
    }
    
    return sorted
}
//print(MergeSort(input: [4,6,2,8,3,9,19,100,3,2,1,2,4,0]))


// MARK: - Quick Sort
//func QuickSort(input: [Int]) -> [Int] {
//    let count = input.count
//    guard count > 1 else {
//        return input
//    }
//    let PivotIndex = count / 2
//    let pivot = input[PivotIndex]
//
//    let less = input.filter {$0 < pivot}
//    let equal = input.filter {$0 == pivot}
//    let greater = input.filter {$0 > pivot}
//
//    return ( QuickSort(input: less) + equal + QuickSort(input: greater))
//
//}
//
//print(QuickSort(input: [4,6,2,8,3,9,19,100,3,2,1,2,4,0]))

// MARK: - Stack

struct Stack<T> {
    var items = [T]()
    var count: Int?
    var isEmpty: Bool?
    mutating func push(_ item: T) -> T {
        items.append(item)
        return(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
    mutating func peek() -> T {
        if items.count == 0 {
            return 0 as! T
        }
        else {
        return items.first!
        }
    }
    mutating func countItems () -> Int {
        count = items.count
        return count ?? 0
    }
    mutating func checkEmpty () -> Bool {
        isEmpty = items.isEmpty
        return isEmpty ?? true
    }
    
}

//var stackOfNumbers = Stack<Int>()
//print ("number added successfully \(stackOfNumbers.push(2))")
//print ("number added successfully \(stackOfNumbers.push(5))")
//print ("number added successfully \(stackOfNumbers.push(7))")
//print ("number added successfully \(stackOfNumbers.push(0))")
//
//print("number removed successfully \(stackOfNumbers.pop())")
//
//print("first number is \(stackOfNumbers.peek())")
//
//
//print("Stack Size is \(stackOfNumbers.countItems())")
//print(stackOfNumbers.checkEmpty())
func fizzBuzz(_ turns: Int) -> String {
    var final: String = ""
    for number in 1 ... turns {
        if number % 3 == 0 && number % 5 == 0 {
            final.append(contentsOf: "FizzBuzz ")
        }
        else if number % 3 == 0 {
            final.append(contentsOf: "Fizz ")
        }
        else if number % 5 == 0 {
            final.append(contentsOf: "Buzz ")
        }
        else {
            final.append(contentsOf: "\(number) ")
        }
    }
    return final
}
print (fizzBuzz(15))
