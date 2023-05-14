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

from src.evrim.util.file_path_util import FilePathUtil

SRC_EVRIM = 'src/evrim'


class TestFilePath(unittest.TestCase):

    def test_app_root_path(self):
        path = Path(FilePathUtil.app_root_path())
        self.assertTrue(path.is_dir())
        self.assertTrue(SRC_EVRIM in path.__str__())


if __name__ == '__main__':
    unittest.main()
