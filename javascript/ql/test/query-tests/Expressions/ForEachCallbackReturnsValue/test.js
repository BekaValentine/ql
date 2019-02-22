/////////////////
//             //
//  BAD CASES  //
//             //
/////////////////

function Bad_MethodWithArrow(a) {
    a.forEach(e => {
        if (e.active) {
            return e.data;
        }
    });
    return null;
}

function Bad_ApplyWithArrow(a) {
	a.forEach.apply(a, [e => {
		if (e.active) {
			return e.data;
		}
	}]);
	return null;
}

function Bad_CallWithArrow(a) {
	a.forEach.call(a, e => {
		if (e.active) {
			return e.data;
		}
	});
	return null;
}

function Bad_MethodWithFunction(a) {
    a.forEach(function (e) {
        if (e.active) {
            return e.data;
        }
    });
    return null;
}

function Bad_ApplyWithFunction(a) {
	a.forEach.apply(a, [function (e) {
		if (e.active) {
			return e.data;
		}
	}]);
	return null;
}

function Bad_CallWithFunction(a) {
	a.forEach.call(a, function (e) {
		if (e.active) {
			return e.data;
		}
	});
	return null;
}




//////////////////
//              //
//  GOOD CASES  //
//              //
//////////////////

function Good_MethodWithArrow(a) {
    a.forEach(e => {
        if (e.active) {
            return;
        }
    });
    return null;
}

function Good_ApplyWithArrow(a) {
	a.forEach.apply(a, [e => {
		if (e.active) {
			return;
		}
	}]);
	return null;
}

function Good_CallWithArrow(a) {
	a.forEach.call(a, e => {
		if (e.active) {
			return;
		}
	});
	return null;
}

function Good_MethodWithFunction(a) {
    a.forEach(function (e) {
        if (e.active) {
            return;
        }
    });
    return null;
}

function Good_ApplyWithFunction(a) {
	a.forEach.apply(a, [function (e) {
		if (e.active) {
			return;
		}
	}]);
	return null;
}

function Good_CallWithFunction(a) {
	a.forEach.call(a, function (e) {
		if (e.active) {
			return;
		}
	});
	return null;
}