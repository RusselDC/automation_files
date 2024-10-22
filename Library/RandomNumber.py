import random

class RandomNumber:

    def get_random_number(self):
        random_number = random.randint(1,189)

        formatted_number = f"{random_number:03}"

        return formatted_number