# type: ignore

import asyncio
import os
from glob import iglob

import semantic_kernel as sk
from dotenv import load_dotenv
from semantic_kernel.connectors.ai.open_ai.services.open_ai_chat_completion import \
    OpenAIChatCompletion
from semantic_kernel.connectors.ai.open_ai.services.open_ai_text_completion import (
    OpenAITextCompletion,
)
from semantic_kernel.core_skills.text_skill import TextSkill
from semantic_kernel.planning.basic_planner import BasicPlanner

from src.meek.util.file_path_util import FilePathUtil


async def run(name: str) -> None:
    load_dotenv()
    api_key = os.getenv("OPENAI_API_KEY")
    kernel = sk.Kernel()
    kernel.add_chat_service(
        "dv", OpenAIChatCompletion("gpt-3.5-turbo", api_key)
    )

    skills_dir = FilePathUtil.append_path("skills")
    skill = kernel.import_semantic_skill_from_directory(skills_dir, "FunSkill")
    joke_function = skill["Joke"]

    print(joke_function("fart at a corporate meeting"))
    # all_skills = []
    # s1 = [f for f in iglob(skills_dir + "**/*", recursive=True) if os.path.isdir(f)]
    # all_skills.extend(s1)
    # for skill_folder_subdir in s1:
    #     s2 = [f for f in iglob(skill_folder_subdir + "**/*", recursive=True) if
    #           os.path.isdir(f)]
    #     all_skills.extend(s2)
    # for skill_folder in all_skills:
    #     try:
    #         kernel.import_semantic_skill_from_directory(
    #             skill_folder, os.path.basename(skill_folder)
    #         )
    #     except ValueError:
    #         pass

    # ask = """
    # I need to do a huge fart. Please create a plan.
    # """
    # planner = BasicPlanner()
    # kernel.import_semantic_skill_from_directory(skills_dir, "WriterSkill")
    #
    # original_plan = await planner.create_plan_async(ask, kernel)
    # print(original_plan.generated_plan)
    # results = await planner.execute_plan_async(original_plan, kernel)
    # print(results)


# Press the green button in the gutter to run the script.
if __name__ == "__main__":
    asyncio.run(run("PyCharm"))

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
