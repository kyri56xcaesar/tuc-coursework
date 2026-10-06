#ifndef ENCRYPTION_UTIL_H
#define ENCRYPTION_UTIL_H

/*
 * encryption/util.h
 *
 * NOTE: this header was lost with the rest of assignment 3 and is
 * reconstructed here. logger.c calls two GMP helpers from it during RSA key
 * generation:
 *
 *   lambda_euler_function(lambda, p, q)   -> lambda = lcm(p-1, q-1)
 *   forge_d_key(d, lambda)                -> a d that is coprime to lambda
 *
 * They are small and self-contained, so they live inline in this header
 * (logger.c is the only translation unit and the Makefile compiles it alone).
 */

#include <gmp.h>

/* Carmichael's totient of n = p*q for distinct primes: lcm(p-1, q-1). */
static inline void
lambda_euler_function(mpz_t result, const mpz_t p, const mpz_t q)
{
	mpz_t p1, q1, g;
	mpz_inits(p1, q1, g, NULL);

	mpz_sub_ui(p1, p, 1);          /* p - 1 */
	mpz_sub_ui(q1, q, 1);          /* q - 1 */

	mpz_gcd(g, p1, q1);            /* gcd(p-1, q-1) */
	mpz_mul(result, p1, q1);       /* (p-1)(q-1)     */
	mpz_divexact(result, result, g); /* lcm = product / gcd */

	mpz_clears(p1, q1, g, NULL);
}

/*
 * Pick an exponent d for the key: the smallest prime strictly greater than
 * lambda that is coprime to lambda and does not reduce to 1 (mod lambda)
 * (so its modular inverse e is non-trivial). logger.c then sets e = d^-1.
 */
static inline void
forge_d_key(mpz_t d, const mpz_t lambda)
{
	mpz_t g, r;
	mpz_inits(g, r, NULL);

	mpz_add_ui(d, lambda, 1);      /* start just above lambda */
	for (;;) {
		mpz_nextprime(d, d);       /* next prime >= d+1 */
		mpz_gcd(g, d, lambda);
		mpz_mod(r, d, lambda);
		if (mpz_cmp_ui(g, 1) == 0 && mpz_cmp_ui(r, 1) != 0)
			break;                 /* coprime and inverse won't be trivial */
	}

	mpz_clears(g, r, NULL);
}

#endif /* ENCRYPTION_UTIL_H */
