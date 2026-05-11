class Temperature:
    """A temperature value in degrees Celsius."""

    def __init__(self, celsius: float) -> None:
        self.celsius = celsius

    def to_celsius(self) -> float:
        return self.celsius

    def to_fahrenheit(self) -> float:
        return self.celsius * 9 / 5 + 32

    @classmethod
    def from_fahrenheit(cls, fahrenheit: float) -> "Temperature":
        return cls((fahrenheit - 32) * 5 / 9)

    def is_hotter_than(self, other: "Temperature") -> bool:
        return self.celsius > other.celsius
