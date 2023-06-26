N = 100
nprimes = 0
primes = []

numall = [True for _ in range(N + 1)]
numall[0] = False
numall[1] = False

for i in range(2, len(numall)):
    if numall[i]:
        for j in range(i ** 2, len(numall), i):
            numall[j] = False

for number, isPrime in enumerate(numall):
    if isPrime:
        nprimes += 1
        primes.append(number)

for prime in primes:
    print(prime)
    