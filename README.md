# lattice-sphere-packing-proof-commitment

Public timestamp and SHA-256 commitment for candidate proofs of improved lattice sphere-packing lower bounds, including the full $\kappa=1$ logarithmic gain.

**Author / originator:** Michael Simkin  
**Date of this public commitment:** September 11, 2026

This repository records a public cryptographic commitment to mathematical work concerning lower bounds for lattice sphere packing.

I obtained proofs corresponding to the following progression:

1. A relatively simple proof giving the exponent

```math
\kappa=\frac{1}{1+e}.
```

2. A more involved construction, presented in **Appendix A**, giving

```math
\kappa=1-\varepsilon
```

for arbitrarily small fixed $\varepsilon>0$.

3. A full $\kappa=1$ construction, presented in **Appendix B**, yielding

```math
\Delta_d^L \ge c\,d^2\log\log d\,2^{-d}.
```

More precisely, for a positive integer $d$, let $\Delta_d^L$ denote the maximum density of a lattice sphere packing in $d$-dimensional Euclidean space.

The claimed theorem is:

> There exist universal constants $c>0$ and $d_0$ such that, for every integer $d\ge d_0$,
>
> ```math
> \Delta_d^L \ge c\,d^2\log\log d\,2^{-d}.
> ```
>
> This is the full logarithmic gain, corresponding to $\kappa=1$ in the notation
>
> ```math
> (\log\log d)^\kappa.
> ```

## Cryptographic commitment

The following SHA-256 hashes identify the exact file contents in my possession at the time of this public commitment:

```text
006445340f5526554be0a1185326a718769b62d9661991330f505612ca659412  Appendices_A_B.tex
233aa92e1aae7d49f9738c61b8f585e25c02423ca0a99dd7594adc2eb3f05642  Simkin_Lattice_Sphere_Packing_Preprint.tex
```

The hashes can later be verified using:

```bash
sha256sum Appendices_A_B.tex Simkin_Lattice_Sphere_Packing_Preprint.tex
```

The manuscript and appendices are now being modified, reviewed, and developed collaboratively. Later versions may therefore differ from the exact versions committed above.

The purpose of this repository is to preserve a public timestamped commitment to these specific file contents and to document my possession of them at or before the time of this commit.

<!-- BEGIN AUTO COMMITMENTS -->

## Additional cryptographic commitments

SHA-256 commitments generated for files held privately/local to this repository checkout:

006445340f5526554be0a1185326a718769b62d9661991330f505612ca659412  files/Appendices_A_B.tex
233aa92e1aae7d49f9738c61b8f585e25c02423ca0a99dd7594adc2eb3f05642  files/Simkin_Lattice_Sphere_Packing_Preprint.tex
cd6558aad76bb7c3d5106ed6dfe8897e74cba74a1c2b405efad4ab3d98febd59  files/simplified_kappa_1_divisor_star.tex

Corresponding `.ots` files are OpenTimestamps proofs.

<!-- END AUTO COMMITMENTS -->
