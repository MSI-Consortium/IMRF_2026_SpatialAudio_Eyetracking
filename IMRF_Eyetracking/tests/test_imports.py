"""Lightweight import checks for modules that should work without hardware."""

import unittest


class ImportSmokeTest(unittest.TestCase):
    def test_project_config_and_triggers_import(self) -> None:
        from libs.project_config import PLOT_COLORS
        from libs.triggers import TRIGGER_MAP

        self.assertIn("cdf_A", PLOT_COLORS)
        self.assertEqual(TRIGGER_MAP["1"], "A_L")


if __name__ == "__main__":
    unittest.main()
