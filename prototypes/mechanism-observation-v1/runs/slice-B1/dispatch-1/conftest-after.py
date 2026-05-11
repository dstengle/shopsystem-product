"""Step definitions for assigned Gherkin scenarios.

Shared fixture and import setup for pytest-bdd. Step definitions
themselves are written by the Implementer as part of the work for
each `assign_scenarios` message — new phrasings produce new step
definitions here. The `temperature` module is provided by the
installed `bc-shop` package; `catalog` is available for any future
step that needs to construct a message directly.
"""
import pytest
from pytest_bdd import given, parsers, then, when

from temperature import Temperature


@pytest.fixture
def context() -> dict:
    return {}


@given(
    parsers.parse("a temperature of {celsius:g} degrees Celsius"),
    target_fixture="first_temperature",
)
def first_temperature(celsius: float) -> Temperature:
    return Temperature(celsius)


@given(
    parsers.parse("another temperature of {celsius:g} degrees Celsius"),
    target_fixture="second_temperature",
)
def second_temperature(celsius: float) -> Temperature:
    return Temperature(celsius)


@when("I compare the first to the second")
def compare_first_to_second(
    context: dict,
    first_temperature: Temperature,
    second_temperature: Temperature,
) -> None:
    context["first_hotter"] = first_temperature.is_hotter_than(second_temperature)


@then("the first is hotter than the second")
def assert_first_hotter(context: dict) -> None:
    assert context["first_hotter"] is True


@when("I convert it to Fahrenheit")
def convert_to_fahrenheit(
    context: dict,
    first_temperature: Temperature,
) -> None:
    context["fahrenheit"] = first_temperature.to_fahrenheit()


@then("I get 32 degrees Fahrenheit")
def assert_32_fahrenheit(context: dict) -> None:
    assert context["fahrenheit"] == 32
