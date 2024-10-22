import random
from datetime import datetime, timedelta


class RandomDate:

    def get_random_date(self):
        random_days = random.randint(0, 365 * 50)
        random_date = datetime(1970, 1, 1) + timedelta(days=random_days)
        return random_date.strftime('%m%d%Y')