def _to_number(x: str) -> float:
    return float(x)

def add(a: str, b: str) -> float:
    return _to_number(a) + _to_number(b)

def subtract(a: str, b: str) -> float:
    return _to_number(a) - _to_number(b)

def multiply(a: str, b: str) -> float:
    return _to_number(a) * _to_number(b)

def divide(a: str, b: str) -> float:
    bval = _to_number(b)
    if bval == 0:
        raise ZeroDivisionError("Division by zero")
    return _to_number(a) / bval
