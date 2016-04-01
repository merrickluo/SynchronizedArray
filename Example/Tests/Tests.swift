// https://github.com/Quick/Quick

import Quick
import Nimble
import SynchronizedArray

class SynchronizedArraySpec: QuickSpec {
    override func spec() {
        describe("init array") {
            let array = SynchronizedArray([1])
            it("should contain 1") {
                expect(array.count) == 1
                expect(array.contains(1)) == true
            }
        }
        describe("append item") {
            var array = SynchronizedArray([1])
            array.append(2)
            
            it("should has two elements now") {
                expect(array.count) == 2
            }
        }
        
        describe("append array") {
            var array = SynchronizedArray<Int>()
            array.appendContentsOf([2, 3])
            it("should have all of elment of above array now") {
                expect(array.count) == 2
            }
        }
        
        describe("remove item") {
            var array = SynchronizedArray([1, 2])
            array.removeAtIndex(1)
            it("should has contain 1 now") {
                expect(array.count) == 1
                expect(array[0]) == 1
            }
        }
        
        describe("plus equal") {
            var array = SynchronizedArray([1, 2])
            array += [3, 4]
            it("should has 4 elments now") {
                expect(array.count) == 4
                expect(array.last) == 4
            }
        }
    }
}
