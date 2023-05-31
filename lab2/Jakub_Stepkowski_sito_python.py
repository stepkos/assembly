N = 100
nprimes = 0

primes = [True for _ in range(N + 1)]
primes[0] = False
primes[1] = False

for i in range(2, len(primes)):
    if primes[i]:
        for j in range(i ** 2, len(primes), i):
            primes[j] = False

for number, isPrime in enumerate(primes):
    if isPrime:
        nprimes += 1
        print(number)

print('Liczb pierwszych:', nprimes)
