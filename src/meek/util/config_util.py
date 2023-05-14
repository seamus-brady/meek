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

from configparser import ConfigParser

from src.meek.util.file_path_util import FilePathUtil


# a class for managing a config file
class ConfigUtil:
    APP_CONFIG_FILE: str = "app.ini"

    @staticmethod
    def get_str(section: str, setting: str) -> str:
        config = ConfigParser()
        config.read(ConfigUtil.config_path())
        return config.get(section, setting)

    @staticmethod
    def get_int(section: str, setting: str) -> int:
        config = ConfigParser()
        config.read(ConfigUtil.config_path())
        return config.getint(section, setting)

    @staticmethod
    def get_bool(section: str, setting: str) -> bool:
        config = ConfigParser()
        config.read(ConfigUtil.config_path())
        return config.getboolean(section, setting)

    @staticmethod
    def config_path() -> str:
        return FilePathUtil.append_path(ConfigUtil.APP_CONFIG_FILE)
