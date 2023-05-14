#  Copyright 2023 seamus@meek.ai, Corvideon Limited.
#  #
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#  #
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.
import unittest
from pathlib import Path

from src.evrim.util.config_util import ConfigUtil


class TestConfig(unittest.TestCase):

    def test_config_path(self):
        path = Path(ConfigUtil.config_path())
        self.assertTrue(ConfigUtil.APP_CONFIG_FILE in path.__str__())
        self.assertTrue(path.is_file())

    def test_config_get_str(self):
        setting: str = ConfigUtil.get_str("ignore", "test_string")
        self.assertEqual(setting, "This is a test.")

    def test_config_get_int(self):
        setting: int = ConfigUtil.get_int("ignore", "test_int")
        self.assertEqual(int(setting), 42)

    def test_config_get_bool(self):
        setting: bool = ConfigUtil.get_bool("ignore", "test_bool")
        self.assertEqual(bool(setting), False)


if __name__ == '__main__':
    unittest.main()
