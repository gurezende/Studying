# Imports
import concurrent.futures
from functools import reduce
from datetime import datetime


def do_something(n):
    c = 0
    for i in range(n):
        #do something
        c += 1
    return c


def reducer(c, c1):
    reduced = c + c1
    return reduced



if __name__ == '__main__':
    start = datetime.now()
    print(start)

    #result = do_something(1_000_000_000)

    with concurrent.futures.ProcessPoolExecutor() as executor:

        # Map: apply the function to a list
        mapped = executor.map(do_something, [250_000_000, 250_000_000, 250_000_000, 250_000_000])

        # reduce the result to a single number
        result = reduce(reducer, mapped)

    print(f'Result = {result: ,}. \nLead time: {datetime.now() - start}')


