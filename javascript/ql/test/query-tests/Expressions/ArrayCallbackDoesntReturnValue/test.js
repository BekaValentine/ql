/////////////////
//             //
//  BAD CASES  //
//             //
/////////////////

var memo = {}, arr = ["apple", "lemon", "orange"];
var ret1 = arr.map(function (curval, index) { // ARRAY_CALLBACK_RETURN_MISSING alarm because no value is returned in the callback function.
    memo[curval] = index;
});
console.log(ret1); // 'ret1' is filled with undefined.

var ret2 = Array.from([1, 2, 3], function (x) { // ARRAY_CALLBACK_RETURN_MISSING alarm because no value is returned in the callback function.
    x = x + 3;
});
console.log(ret2); // 'ret2' is filled with undefined.



//////////////////
//              //
//  GOOD CASES  //
//              //
//////////////////

var memo = {}, arr = ["apple", "lemon", "orange"];
var ret1 = arr.map(function (curval, index) {
    memo[curval] = index;
    return memo[curval];
});

var ret2 = Array.from([1, 2, 3], function (x) {
    x = x + 3;
    return x;
});