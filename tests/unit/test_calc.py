import unittest
import calc

class TestCalc(unittest.TestCase):
    def test_add(self):
        self.assertEqual(calc.add("2", "3"), 5.0)

    def test_subtract(self):
        self.assertEqual(calc.subtract("7", "2"), 5.0)

    def test_multiply(self):
        self.assertEqual(calc.multiply("3", "4"), 12.0)

    def test_divide(self):
        self.assertEqual(calc.divide("8", "2"), 4.0)

    def test_non_numeric(self):
        with self.assertRaises(ValueError):
            calc.add("x", "1")

    def test_divide_by_zero(self):
        with self.assertRaises(ZeroDivisionError):
            calc.divide("1", "0")

if __name__ == "__main__":
    unittest.main()
