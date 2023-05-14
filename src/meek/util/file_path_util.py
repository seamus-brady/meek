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

import os
from pathlib import Path


# a class for handling file paths in the app
class FilePathUtil:
    APP_CONFIG_FILE: str = "./app.ini"

    @staticmethod
    def app_root_path() -> str:
        script_path: Path = Path(__file__)
        return script_path.parent.parent.absolute().__str__()

    @staticmethod
    def append_path(path_str: str) -> str:
        app_root: str = FilePathUtil.app_root_path()
        return os.path.join(app_root, path_str)
